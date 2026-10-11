import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_alert.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

/// Opens the email composer pre-filled from a template. Returns `true` when an
/// email was sent.
Future<bool> showComposeEmailDialog(
  BuildContext context, {
  required String to,
  required Map<String, String> vars,
  required EntityType entityType,
  required String entityId,
  EmailTemplate? template,
  String category = 'lead',
  String? subject,
  String? body,
}) async {
  final sent = await showBzModal<bool>(
    context: context,
    title: 'Compose email',
    subtitle: template != null ? 'Template: ${template.name}' : 'Write a personal email',
    icon: BootstrapIcons.envelope_paper,
    width: 860,
    bodyPadding: EdgeInsets.zero,
    child: _ComposeBody(to: to, vars: vars, template: template, category: category, entityType: entityType, entityId: entityId, subject: subject, body: body),
  );
  return sent ?? false;
}

class _ComposeBody extends ConsumerStatefulWidget {
  const _ComposeBody({
    required this.to,
    required this.vars,
    required this.template,
    required this.category,
    required this.entityType,
    required this.entityId,
    this.subject,
    this.body,
  });

  final String to;
  final Map<String, String> vars;
  final EmailTemplate? template;
  final String category;
  final EntityType entityType;
  final String entityId;
  final String? subject;
  final String? body;

  @override
  ConsumerState<_ComposeBody> createState() => _ComposeBodyState();
}

class _ComposeBodyState extends ConsumerState<_ComposeBody> {
  late final TextEditingController _to;
  late final TextEditingController _subject;
  late final TextEditingController _body;
  EmailTemplate? _template;
  bool _preview = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _template = widget.template;
    _to = TextEditingController(text: widget.to);
    _subject = TextEditingController(text: widget.subject ?? (widget.template != null ? TemplateEngine.render(widget.template!.subject, widget.vars) : ''));
    _body = TextEditingController(text: widget.body ?? (widget.template != null ? TemplateEngine.render(widget.template!.body, widget.vars) : ''));
  }

  @override
  void dispose() {
    _to.dispose();
    _subject.dispose();
    _body.dispose();
    super.dispose();
  }

  void _applyTemplate(EmailTemplate? t) {
    setState(() {
      _template = t;
      if (t != null) {
        _subject.text = TemplateEngine.render(t.subject, widget.vars);
        _body.text = TemplateEngine.render(t.body, widget.vars);
      }
    });
  }

  Future<void> _send() async {
    final to = _to.text.trim();
    if (to.isEmpty || !to.contains('@')) {
      BzToasts.warning('Add a valid recipient email address');
      return;
    }
    if (_subject.text.trim().isEmpty) {
      BzToasts.warning('Subject is empty');
      return;
    }
    final gmail = ref.read(gmailServiceProvider);
    final settings = ref.read(settingsSnapshotProvider);
    if (!gmail.available) {
      BzToasts.warning('Gmail is not connected', message: 'Connect Google in Settings or open in your mail app.');
      return;
    }
    setState(() => _sending = true);
    try {
      final html = EmailHtml.wrap(bodyText: _body.text, brand: settings.businessName, footer: settings.signature.isNotEmpty ? settings.signature.split('\n').first : 'Sent by ${settings.businessName}');
      final id = await gmail.send(
        to: to,
        subject: _subject.text.trim(),
        textBody: _body.text,
        htmlBody: html,
        fromName: settings.myName.isNotEmpty ? settings.myName : settings.businessName,
      );
      await ref.read(emailLogsRepoProvider).log(entityType: widget.entityType, entityId: widget.entityId, to: to, subject: _subject.text.trim(), body: _body.text, templateId: _template?.id, gmailMessageId: id);
      await ref.read(databaseProvider).logActivity(entityType: widget.entityType, entityId: widget.entityId, kind: ActivityKind.emailSent, title: 'Email sent: ${_subject.text.trim()}', detail: 'To $to');
      if (widget.entityType == EntityType.lead) {
        await ref.read(leadsRepoProvider).patch(widget.entityId, LeadsCompanion(lastContact: drift.Value(DateTime.now())));
      }
      BzToasts.success('Email sent to $to', message: _subject.text.trim());
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      await ref.read(emailLogsRepoProvider).log(entityType: widget.entityType, entityId: widget.entityId, to: to, subject: _subject.text.trim(), body: _body.text, templateId: _template?.id, error: e.toString());
      BzToasts.error('Could not send email', message: e.toString());
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openInMailApp() async {
    final uri = Uri(scheme: 'mailto', path: _to.text.trim(), queryParameters: {'subject': _subject.text, 'body': _body.text});
    await launchUrl(uri);
  }

  void _insert(String token) {
    final sel = _body.selection;
    final text = _body.text;
    final start = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final rendered = widget.vars['{{$token}}'] ?? widget.vars[token] ?? '{{$token}}';
    _body.text = text.replaceRange(start, end, rendered);
    _body.selection = TextSelection.collapsed(offset: start + rendered.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templates = (ref.watch(templatesProvider).value ?? const []);
    final google = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final settings = ref.watch(settingsSnapshotProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!google.connected)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: BzAlert(
              variant: BzVariant.warning,
              title: 'Gmail not connected',
              message: 'Connect your Google account to send directly from FrameWorkz. You can still open this draft in your mail app.',
              action: BzButton(
                label: 'Connect',
                size: BzSize.sm,
                variant: BzVariant.warning,
                onPressed: () {
                  Navigator.of(context).pop(false);
                  context.go(Routes.settings);
                },
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: BzRow([
            BzField(label: 'To', required: true, child: BzTextField(controller: _to, prefixIcon: BootstrapIcons.at, hint: 'name@company.com')),
            BzField(
              label: 'Template',
              child: BzDropdown<EmailTemplate?>(
                value: _template,
                items: [null, ...templates],
                labelOf: (t) => t == null ? 'No template' : t.name,
                iconOf: (t) => t == null ? BootstrapIcons.pencil : BootstrapIcons.envelope_paper,
                onChanged: _applyTemplate,
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: BzField(label: 'Subject', required: true, child: BzTextField(controller: _subject, prefixIcon: BootstrapIcons.type, hint: 'A clear, specific subject line')),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          child: Row(
            children: [
              Text('Message', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              BzSegmented<bool>(
                value: _preview,
                options: const [(false, 'Edit', BootstrapIcons.pencil), (true, 'Preview', BootstrapIcons.eye)],
                onChanged: (v) => setState(() => _preview = v),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: _preview
              ? _EmailPreview(subject: _subject.text, body: _body.text, brand: settings.businessName, to: _to.text)
              : BzTextField(controller: _body, minLines: 12, maxLines: 18, hint: 'Write your message…'),
        ),
        if (!_preview)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                Padding(padding: const EdgeInsets.only(top: 5, right: 2), child: Text('Insert:', style: theme.textTheme.labelSmall)),
                for (final p in const ['first_name', 'business', 'service', 'meeting_date', 'meeting_time', 'meet_link', 'proposal_link', 'my_name', 'my_business'])
                  ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 11, fontFamily: 'Inter')),
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _insert(p),
                  ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        const Divider(),
        Container(
          color: theme.colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (google.connected)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    const Icon(BootstrapIcons.google, size: 13, color: BzColors.success),
                    const SizedBox(width: 6),
                    Expanded(child: Text('Sending as ${google.email ?? 'Gmail'}', style: theme.textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
                  ]),
                ),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 8,
                children: [
                  BzButton(
                    label: 'Copy',
                    icon: BootstrapIcons.copy,
                    variant: BzVariant.light,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'Subject: ${_subject.text}\n\n${_body.text}'));
                      BzToasts.info('Email copied to clipboard');
                    },
                  ),
                  BzButton(label: 'Mail app', icon: BootstrapIcons.box_arrow_up_right, variant: BzVariant.light, onPressed: _openInMailApp),
                  BzButton(label: 'Skip', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop(false)),
                  BzButton(label: _sending ? 'Sending…' : 'Send email', icon: BootstrapIcons.send_fill, loading: _sending, onPressed: google.connected && !_sending ? _send : null),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmailPreview extends StatelessWidget {
  const _EmailPreview({required this.subject, required this.body, required this.brand, required this.to});
  final String subject;
  final String body;
  final String brand;
  final String to;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(BzTheme.radiusLg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.all(22),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: BzColors.gray200), boxShadow: BzShadows.md(context)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 6, color: BzColors.primary),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 6),
                child: Text(brand.toUpperCase(), style: const TextStyle(fontSize: 12, letterSpacing: 1.2, color: BzColors.gray600, fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 4, 28, 10),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(subject.isEmpty ? '(no subject)' : subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: BzColors.gray900)),
                  const SizedBox(height: 2),
                  Text('To: $to', style: const TextStyle(fontSize: 12, color: BzColors.gray600)),
                ]),
              ),
              const Divider(color: BzColors.gray200),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 26),
                child: SelectableText(body, style: const TextStyle(fontSize: 14, height: 1.6, color: BzColors.gray900)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                color: BzColors.gray100,
                child: Row(children: [
                  const Icon(BootstrapIcons.lightning_charge, size: 11, color: BzColors.gray600),
                  const SizedBox(width: 6),
                  Text('Sent with FrameWorkz', style: TextStyle(fontSize: 11, color: BzColors.gray600)),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
