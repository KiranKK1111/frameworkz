import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/db/seed.dart';
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_misc.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

const _categories = ['lead', 'client', 'project', 'invoice'];

class TemplatesPage extends ConsumerStatefulWidget {
  const TemplatesPage({super.key});
  @override
  ConsumerState<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends ConsumerState<TemplatesPage> {
  String? _selectedId;
  bool _creating = false;

  Future<void> _restore() async {
    final n = await restoreMissingTemplates(ref.read(databaseProvider));
    BzToasts.info(n == 0 ? 'All built-in templates are present' : 'Restored $n template${n == 1 ? '' : 's'}');
  }

  void _openEditorSheet(BuildContext context, EmailTemplate? t) {
    showBzModal(
      context: context,
      title: t?.name ?? 'New template',
      subtitle: t == null ? 'Create a reusable email' : (t.triggerStatus != null ? 'Suggested on "${t.triggerStatus!.label}"' : 'Manual template'),
      icon: BootstrapIcons.envelope_paper,
      fullscreenOnPhone: true,
      bodyPadding: const EdgeInsets.all(14),
      child: _TemplateEditor(key: ValueKey(t?.id ?? 'new'), template: t, embedded: true, onDone: () => Navigator.of(context).maybePop()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templates = ref.watch(templatesProvider).value ?? const <EmailTemplate>[];
    final phone = context.isPhone;
    final selected = _creating ? null : (templates.where((t) => t.id == _selectedId).firstOrNull ?? templates.firstOrNull);
    if (!_creating && selected != null && _selectedId != selected.id) _selectedId = selected.id;

    Widget list({required bool phoneMode}) => ListView(
          shrinkWrap: phoneMode,
          physics: phoneMode ? const NeverScrollableScrollPhysics() : null,
          children: [
            for (final cat in _categories)
              if (templates.any((t) => t.category == cat)) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: Text(cat.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.8, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant)),
                ),
                for (final t in templates.where((t) => t.category == cat))
                  BzHoverRow(
                    selected: !phoneMode && !_creating && t.id == selected?.id,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: phoneMode ? 12 : 10),
                    onTap: () {
                      if (phoneMode) {
                        _openEditorSheet(context, t);
                      } else {
                        setState(() {
                          _creating = false;
                          _selectedId = t.id;
                        });
                      }
                    },
                    child: Row(children: [
                      Icon(t.triggerStatus != null ? StatusStyle.leadIcon(t.triggerStatus!) : BootstrapIcons.envelope, size: 14, color: t.triggerStatus != null ? StatusStyle.lead(t.triggerStatus!).color : theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(t.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                          Text(t.triggerStatus != null ? 'On "${t.triggerStatus!.label}"' : 'Manual', style: theme.textTheme.bodySmall),
                        ]),
                      ),
                      if (t.autoSend) const Tooltip(message: 'Auto-send enabled', child: Icon(BootstrapIcons.lightning_charge_fill, size: 12, color: BzColors.buzz)),
                      if (phoneMode) Icon(BootstrapIcons.chevron_right, size: 13, color: theme.colorScheme.onSurfaceVariant),
                    ]),
                  ),
              ],
          ],
        );

    final header = BzPageHeader(
      title: 'Email templates',
      subtitle: 'Ready-made emails for every stage. Names, dates and links fill themselves in.',
      icon: BootstrapIcons.envelope_paper,
      actions: [
        BzButton(label: 'Restore', icon: BootstrapIcons.arrow_counterclockwise, variant: BzVariant.light, onPressed: _restore),
        BzButton(label: 'New template', icon: BootstrapIcons.plus_lg, onPressed: () => phone ? _openEditorSheet(context, null) : setState(() => _creating = true)),
      ],
    );

    if (phone) {
      return BzPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header,
            BzCard(padding: const EdgeInsets.all(6), child: list(phoneMode: true)),
          ],
        ),
      );
    }

    return BzPage(
      scroll: false,
      maxWidth: 1600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: context.isTablet ? 260 : 320, child: BzCard(padding: const EdgeInsets.all(8), fill: true, child: list(phoneMode: false))),
                const SizedBox(width: 16),
                Expanded(
                  child: _creating || selected != null
                      ? _TemplateEditor(key: ValueKey(_creating ? 'new' : selected!.id), template: _creating ? null : selected, onDone: () => setState(() => _creating = false))
                      : const BzEmptyState(icon: BootstrapIcons.envelope_paper, title: 'No templates', message: 'Create one or restore the defaults.'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TemplateEditor extends ConsumerStatefulWidget {
  const _TemplateEditor({super.key, required this.template, required this.onDone, this.embedded = false});
  final EmailTemplate? template;
  final VoidCallback onDone;

  /// True when shown inside a bottom sheet (no card chrome, no fill).
  final bool embedded;
  @override
  ConsumerState<_TemplateEditor> createState() => _TemplateEditorState();
}

class _TemplateEditorState extends ConsumerState<_TemplateEditor> {
  late final _name = TextEditingController(text: widget.template?.name ?? '');
  late final _subject = TextEditingController(text: widget.template?.subject ?? '');
  late final _body = TextEditingController(text: widget.template?.body ?? 'Hi {{first_name}},\n\n\n\n{{signature}}');
  late LeadStatus? _trigger = widget.template?.triggerStatus;
  late String _category = widget.template?.category ?? 'lead';
  late bool _autoSend = widget.template?.autoSend ?? false;
  bool _preview = false;
  bool _dirty = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _subject, _body]) {
      c.addListener(() {
        if (!_dirty) setState(() => _dirty = true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _subject, _body]) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, String> get _sampleVars => {
        ...TemplateEngine.baseVars(ref.read(settingsSnapshotProvider)),
        'contact_name': 'Rahul Sharma',
        'first_name': 'Rahul',
        'business': 'Chennai Fitness Lab',
        'service': 'Monthly Retainer',
        'potential_value': '₹30,000',
        'proposal_link': 'https://drive.google.com/proposal',
        'meeting_date': 'Tue, 14 Oct',
        'meeting_time': '11:00 AM',
        'meet_link': 'https://meet.google.com/abc-defg-hij',
        'project_name': 'October launch reels',
        'invoice_id': 'INV-0007',
        'invoice_amount': '₹30,000',
        'invoice_balance': '₹15,000',
        'invoice_due': '20 Oct 2026',
      };

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _subject.text.trim().isEmpty) {
      BzToasts.warning('Name and subject are required');
      return;
    }
    final repo = ref.read(templatesRepoProvider);
    final id = widget.template?.id ?? 'tpl_${DateTime.now().millisecondsSinceEpoch}';
    if (_trigger != null) {
      final clash = await repo.forStatus(_trigger!);
      if (!mounted) return;
      if (clash != null && clash.id != id) {
        final ok = await showBzConfirm(context, title: 'Replace trigger?', message: '"${clash.name}" is already suggested for ${_trigger!.label}. Make this template the suggestion instead?', confirmLabel: 'Use this one', variant: BzVariant.primary, icon: BootstrapIcons.arrow_left_right);
        if (!ok) return;
        await repo.upsert(clash.copyWith(triggerStatus: const drift.Value(null)));
      }
    }
    await repo.upsert(EmailTemplate(
      id: id,
      name: _name.text.trim(),
      triggerStatus: _trigger,
      category: _category,
      subject: _subject.text.trim(),
      body: _body.text,
      autoSend: _autoSend,
      isBuiltIn: widget.template?.isBuiltIn ?? false,
      sortOrder: widget.template?.sortOrder ?? 100,
      updatedAt: DateTime.now(),
    ));
    BzToasts.success('Template saved', message: _name.text.trim());
    if (mounted) setState(() => _dirty = false);
    widget.onDone();
  }

  Future<void> _delete() async {
    final t = widget.template;
    if (t == null) return;
    final ok = await showBzConfirm(context, title: 'Delete template?', message: '"${t.name}" will be removed. Built-in templates can be restored later.', confirmLabel: 'Delete');
    if (!ok) return;
    await ref.read(templatesRepoProvider).delete(t.id);
    BzToasts.info('Template deleted');
    widget.onDone();
  }

  Future<void> _duplicate() async {
    final t = widget.template;
    if (t == null) return;
    await ref.read(templatesRepoProvider).upsert(t.copyWith(id: 'tpl_${DateTime.now().millisecondsSinceEpoch}', name: '${t.name} (copy)', triggerStatus: const drift.Value(null), isBuiltIn: false, sortOrder: 100));
    BzToasts.success('Template duplicated');
  }

  void _insert(String token) {
    final sel = _body.selection;
    final text = _body.text;
    final start = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final t = '{{$token}}';
    _body.text = text.replaceRange(start, end, t);
    _body.selection = TextSelection.collapsed(offset: start + t.length);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actions = <Widget>[
      if (widget.template != null) BzIconButton(icon: BootstrapIcons.copy, tooltip: 'Duplicate', onPressed: _duplicate),
      if (widget.template != null) BzIconButton(icon: BootstrapIcons.trash3, tooltip: 'Delete', variant: BzVariant.danger, onPressed: _delete),
      const SizedBox(width: 4),
      BzButton(label: _dirty || widget.template == null ? 'Save' : 'Saved', icon: BootstrapIcons.check2, size: BzSize.sm, onPressed: _dirty || widget.template == null ? _save : null),
    ];

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.embedded) ...[
          Row(mainAxisAlignment: MainAxisAlignment.end, children: actions.map((a) => a is BzButton ? Flexible(child: a) : a).toList()),
          const SizedBox(height: 10),
        ],
        BzRow([
          BzField(label: 'Template name', required: true, flex: 2, child: BzTextField(controller: _name, hint: 'Proposal follow-up')),
          BzField(
            label: 'Category',
            child: BzDropdown<String>(value: _category, items: _categories, labelOf: (c) => c[0].toUpperCase() + c.substring(1), onChanged: (v) => setState(() {
                  _category = v ?? _category;
                  _dirty = true;
                })),
          ),
          BzField(
            label: 'Suggest for status',
            child: BzDropdown<LeadStatus?>(value: _trigger, items: [null, ...LeadStatus.values], labelOf: (s) => s?.label ?? 'Manual only', iconOf: (s) => s == null ? BootstrapIcons.hand_index : StatusStyle.leadIcon(s), onChanged: (v) => setState(() {
                  _trigger = v;
                  _dirty = true;
                })),
          ),
        ]),
        const SizedBox(height: 14),
        BzField(label: 'Subject', required: true, child: BzTextField(controller: _subject, prefixIcon: BootstrapIcons.type, hint: 'Proposal for {{business}} · {{service}}')),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(child: Text('Body', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600))),
          const SizedBox(width: 8),
          Flexible(flex: 4, child: BzSegmented<bool>(value: _preview, options: [(false, 'Edit', BootstrapIcons.pencil), (true, context.isPhone ? 'Preview' : 'Preview with sample data', BootstrapIcons.eye)], onChanged: (v) => setState(() => _preview = v))),
        ]),
        const SizedBox(height: 8),
        if (_preview)
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(BzTheme.radiusLg), border: Border.all(color: theme.colorScheme.outline)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(TemplateEngine.render(_subject.text, _sampleVars), style: theme.textTheme.titleMedium),
              const Divider(height: 20),
              SelectableText(TemplateEngine.render(_body.text, _sampleVars), style: theme.textTheme.bodyMedium?.copyWith(height: 1.6)),
            ]),
          ).animate().fadeIn(duration: 200.ms)
        else
          BzTextField(controller: _body, minLines: context.isPhone ? 10 : 14, maxLines: 30),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            Padding(padding: const EdgeInsets.only(top: 6, right: 4), child: Text('Insert placeholder:', style: theme.textTheme.labelSmall)),
            for (final p in TemplateEngine.placeholders)
              Tooltip(
                message: p.$2,
                child: ActionChip(label: Text('{{${p.$1}}}', style: const TextStyle(fontSize: 11, fontFamily: 'Inter')), visualDensity: VisualDensity.compact, onPressed: () => _insert(p.$1)),
              ),
          ],
        ),
        const SizedBox(height: 14),
        BzSwitchTile(
          title: 'Auto-send without review',
          subtitle: 'Off (recommended): the composer opens prefilled so you can personalise before sending.',
          icon: BootstrapIcons.lightning_charge,
          value: _autoSend,
          onChanged: (v) => setState(() {
            _autoSend = v;
            _dirty = true;
          }),
        ),
      ],
    );

    if (widget.embedded) return body;

    return BzCard(
      title: widget.template == null ? 'New template' : widget.template!.name,
      subtitle: widget.template?.isBuiltIn == true ? 'Built-in · your edits are kept; "Restore" only brings back deleted ones' : 'Custom template',
      actions: actions,
      padding: EdgeInsets.zero,
      fill: true,
      child: SingleChildScrollView(padding: const EdgeInsets.all(18), child: body),
    );
  }
}
