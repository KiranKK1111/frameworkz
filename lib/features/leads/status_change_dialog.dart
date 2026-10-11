import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_alert.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../email/compose_email_dialog.dart';
import 'convert_to_client_dialog.dart';

class StatusParams {
  StatusParams({this.note = '', this.meetingAt, this.duration = 45, this.lostReason = '', this.proposalLink = '', this.openEmail = true});
  final String note;
  final DateTime? meetingAt;
  final int duration;
  final String lostReason;
  final String proposalLink;
  final bool openEmail;
}

const lostReasons = ['Budget', 'Went with another studio', 'No response', 'Timing / postponed', 'Not a fit', 'Other'];

/// Shows the "what happens next" sheet for a status change, then runs the
/// automation and the follow-on flows (email composer, convert-to-client).
Future<StatusChangeResult?> showStatusChangeDialog(BuildContext context, Lead lead, LeadStatus to) async {
  if (lead.status == to) return null;
  final container = ProviderScope.containerOf(context);
  final settings = container.read(settingsSnapshotProvider);
  final template = await container.read(templatesRepoProvider).forStatus(to);
  if (!context.mounted) return null;

  final params = await showBzModal<StatusParams>(
    context: context,
    title: 'Move to ${to.label}',
    subtitle: lead.business,
    icon: StatusStyle.leadIcon(to),
    variant: StatusStyle.lead(to),
    width: 600,
    child: _StatusBody(lead: lead, to: to, settings: settings, template: template),
  );
  if (params == null || !context.mounted) return null;
  return runStatusChange(context, lead, to, params: params, template: template);
}

Future<StatusChangeResult?> runStatusChange(BuildContext context, Lead lead, LeadStatus to, {StatusParams? params, EmailTemplate? template}) async {
  final p = params ?? StatusParams();
  final container = ProviderScope.containerOf(context);
  final automation = container.read(automationProvider);
  final settings = container.read(settingsSnapshotProvider);
  try {
    if (p.proposalLink.isNotEmpty && p.proposalLink != lead.proposalLink) {
      await container.read(leadsRepoProvider).patch(lead.id, LeadsCompanion(proposalLink: drift.Value(p.proposalLink)));
      lead = lead.copyWith(proposalLink: p.proposalLink);
    }
    final result = await automation.changeStatus(lead, to, note: p.note, meetingAt: p.meetingAt, meetingDurationMinutes: p.duration, lostReason: p.lostReason);

    final fu = result.followUp;
    BzToasts.success(
      '${lead.business} → ${to.label}',
      message: fu == null
          ? 'No follow-up scheduled for this status.'
          : (fu.hasTime ? 'Meeting on ${Fmt.dateTime(fu.dueAt)}' : 'Next follow-up ${Fmt.relativeDay(fu.dueAt).toLowerCase()} (${Fmt.weekday(fu.dueAt)})') +
              (result.calendarSynced ? ' · added to Google Calendar' : ''),
    );
    if (result.calendarError != null) {
      BzToasts.warning('Calendar not updated', message: result.calendarError);
    }

    if (!context.mounted) return result;

    if (to == LeadStatus.won) {
      await showConvertToClientDialog(context, result.lead);
      if (!context.mounted) return result;
    }

    final tpl = template ?? result.suggestedTemplate;
    if (p.openEmail && tpl != null && lead.email.trim().isNotEmpty) {
      await showComposeEmailDialog(
        context,
        to: lead.email,
        vars: TemplateEngine.leadVars(result.lead, settings, meeting: fu?.hasTime == true ? fu : null),
        template: tpl,
        entityType: EntityType.lead,
        entityId: lead.id,
      );
    }
    return result;
  } catch (e) {
    BzToasts.error('Status change failed', message: e.toString());
    return null;
  }
}

class _StatusBody extends ConsumerStatefulWidget {
  const _StatusBody({required this.lead, required this.to, required this.settings, required this.template});
  final Lead lead;
  final LeadStatus to;
  final AppSettingsState settings;
  final EmailTemplate? template;

  @override
  ConsumerState<_StatusBody> createState() => _StatusBodyState();
}

class _StatusBodyState extends ConsumerState<_StatusBody> {
  final _note = TextEditingController();
  late final TextEditingController _proposal = TextEditingController(text: widget.lead.proposalLink);
  DateTime _meetingDate = DateUtilsX.startOfDay(DateTime.now()).add(const Duration(days: 1));
  TimeOfDay _meetingTime = const TimeOfDay(hour: 11, minute: 0);
  int _duration = 45;
  String _lostReason = lostReasons.first;
  bool _openEmail = true;

  bool get _isMeeting => widget.to == LeadStatus.callScheduled;

  @override
  void dispose() {
    _note.dispose();
    _proposal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final google = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final days = widget.settings.followUpRules[widget.to];
    final hasEmail = widget.lead.email.trim().isNotEmpty;
    final meetingAt = DateTime(_meetingDate.year, _meetingDate.month, _meetingDate.day, _meetingTime.hour, _meetingTime.minute);

    final steps = <(IconData, String, BzVariant)>[
      (BootstrapIcons.clock_history, 'Last contact → today (${Fmt.date(DateTime.now())})', BzVariant.secondary),
      if (_isMeeting)
        (BootstrapIcons.camera_video, 'Meeting on ${Fmt.dateTime(meetingAt)} · $_duration min', BzVariant.primary)
      else if (days != null)
        (BootstrapIcons.bell, 'Next follow-up in ${Fmt.plural(days, 'day')} → ${Fmt.weekday(DateUtilsX.startOfDay(DateTime.now()).add(Duration(days: days)))}', BzVariant.warning)
      else
        (BootstrapIcons.bell_slash, 'No automatic follow-up for ${widget.to.label}', BzVariant.secondary),
      if ((days != null || _isMeeting) && google.connected && widget.settings.calendarSync)
        (BootstrapIcons.google, _isMeeting && widget.settings.calendarCreateMeet ? 'Google Calendar event with Meet link' : 'Google Calendar reminder', BzVariant.success)
      else if (days != null || _isMeeting)
        (BootstrapIcons.google, 'Google Calendar not connected — reminder stays in FrameWorkz', BzVariant.secondary),
      if (widget.template != null && hasEmail)
        (BootstrapIcons.envelope_paper, 'Email template "${widget.template!.name}" ready to send', BzVariant.info)
      else if (widget.template != null)
        (BootstrapIcons.envelope_x, 'Email template available, but the lead has no email', BzVariant.secondary),
      if (widget.to == LeadStatus.won) (BootstrapIcons.trophy, 'Convert to client & create first project', BzVariant.success),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            LeadStatusBadge(widget.lead.status, withIcon: true),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(BootstrapIcons.arrow_right, size: 14)),
            LeadStatusBadge(widget.to, soft: false, withIcon: true),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHigh, borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.colorScheme.outline)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WHAT HAPPENS AUTOMATICALLY', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.8, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              for (final s in steps)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(children: [
                    Icon(s.$1, size: 14, color: s.$3 == BzVariant.secondary ? theme.colorScheme.onSurfaceVariant : s.$3.emphasis(theme.brightness)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(s.$2, style: theme.textTheme.bodyMedium)),
                  ]),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_isMeeting) ...[
          BzRow([
            BzField(label: 'Meeting date', required: true, child: BzDateField(value: _meetingDate, clearable: false, onChanged: (d) => setState(() => _meetingDate = d ?? _meetingDate))),
            BzField(label: 'Time', required: true, child: BzTimeField(value: _meetingTime, onChanged: (t) => setState(() => _meetingTime = t ?? _meetingTime))),
            BzField(
              label: 'Duration',
              child: BzDropdown<int>(value: _duration, items: const [15, 30, 45, 60, 90], labelOf: (d) => '$d min', onChanged: (d) => setState(() => _duration = d ?? 45)),
            ),
          ]),
          const SizedBox(height: 14),
        ],
        if (widget.to == LeadStatus.proposalSent) ...[
          BzField(label: 'Proposal link', help: 'Google Drive / Docs link — inserted into the email as {{proposal_link}}', child: BzTextField(controller: _proposal, prefixIcon: BootstrapIcons.link_45deg, hint: 'https://…')),
          const SizedBox(height: 14),
        ],
        if (widget.to == LeadStatus.lost) ...[
          BzField(label: 'Reason', child: BzDropdown<String>(value: _lostReason, items: lostReasons, labelOf: (s) => s, onChanged: (v) => setState(() => _lostReason = v ?? _lostReason))),
          const SizedBox(height: 14),
        ],
        BzField(label: 'Note (optional)', child: BzTextField(controller: _note, minLines: 2, maxLines: 4, hint: 'What was discussed, next steps, objections…')),
        if (widget.template != null && hasEmail) ...[
          const SizedBox(height: 12),
          BzSwitchTile(title: 'Open email composer after saving', subtitle: 'Prefilled with "${widget.template!.name}" — you can edit before sending', value: _openEmail, icon: BootstrapIcons.envelope, onChanged: (v) => setState(() => _openEmail = v)),
        ],
        if (widget.to == LeadStatus.won && widget.lead.clientId != null) ...[
          const SizedBox(height: 12),
          const BzAlert(variant: BzVariant.info, message: 'This lead is already linked to a client; the conversion step will be skipped.', dense: true),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            const SizedBox(width: 8),
            BzButton(
              label: _isMeeting ? 'Schedule & save' : 'Save status',
              icon: BootstrapIcons.check2,
              variant: StatusStyle.lead(widget.to) == BzVariant.warning || StatusStyle.lead(widget.to) == BzVariant.info ? BzVariant.primary : StatusStyle.lead(widget.to),
              onPressed: () => Navigator.of(context).pop(StatusParams(
                note: _note.text.trim(),
                meetingAt: _isMeeting ? meetingAt : null,
                duration: _duration,
                lostReason: widget.to == LeadStatus.lost ? _lostReason : '',
                proposalLink: _proposal.text.trim(),
                openEmail: _openEmail,
              )),
            ),
          ],
        ),
      ],
    );
  }
}
