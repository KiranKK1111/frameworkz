import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../leads/status_change_dialog.dart';

/// "Mark done" flow: capture the outcome and optionally move the lead to its
/// next status (which schedules the next follow-up automatically).
Future<bool> completeFollowUpFlow(BuildContext context, FollowUp fu) async {
  final container = ProviderScope.containerOf(context);
  Lead? lead;
  if (fu.leadId != null) lead = await container.read(leadsRepoProvider).byId(fu.leadId!);
  if (!context.mounted) return false;

  final res = await showBzModal<(String, LeadStatus?)>(
    context: context,
    title: 'Complete follow-up',
    subtitle: fu.title,
    icon: BootstrapIcons.check_circle_fill,
    variant: BzVariant.success,
    width: 560,
    child: _CompleteBody(fu: fu, lead: lead),
  );
  if (res == null || !context.mounted) return false;

  await container.read(automationProvider).completeFollowUp(fu, outcome: res.$1);
  BzToasts.success('Follow-up completed', message: fu.title);
  if (lead != null && res.$2 != null && res.$2 != lead.status && context.mounted) {
    await showStatusChangeDialog(context, lead, res.$2!);
  }
  return true;
}

class _CompleteBody extends StatefulWidget {
  const _CompleteBody({required this.fu, required this.lead});
  final FollowUp fu;
  final Lead? lead;
  @override
  State<_CompleteBody> createState() => _CompleteBodyState();
}

class _CompleteBodyState extends State<_CompleteBody> {
  final _outcome = TextEditingController();
  LeadStatus? _next;

  static LeadStatus? suggestNext(LeadStatus s) => switch (s) {
        LeadStatus.newLead => LeadStatus.contacted,
        LeadStatus.contacted => LeadStatus.replied,
        LeadStatus.replied => LeadStatus.callScheduled,
        LeadStatus.callScheduled => LeadStatus.proposalSent,
        LeadStatus.proposalSent => LeadStatus.negotiation,
        LeadStatus.negotiation => LeadStatus.won,
        _ => null,
      };

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) _next = null;
  }

  @override
  void dispose() {
    _outcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lead = widget.lead;
    final suggestion = lead != null ? suggestNext(lead.status) : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BzField(label: 'Outcome / notes', child: BzTextField(controller: _outcome, autofocus: true, minLines: 3, maxLines: 5, hint: 'Spoke to Rahul, wants a proposal by Friday…')),
        if (lead != null) ...[
          const SizedBox(height: 16),
          Text('UPDATE LEAD STATUS', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.8, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChoiceChip(
                label: const Text('Keep as is', style: TextStyle(fontSize: 12)),
                selected: _next == null,
                onSelected: (_) => setState(() => _next = null),
              ),
              for (final s in LeadStatus.values.where((s) => s != lead.status))
                ChoiceChip(
                  avatar: Icon(StatusStyle.leadIcon(s), size: 13, color: _next == s ? Colors.white : StatusStyle.lead(s).color),
                  label: Text(s.label + (s == suggestion ? '  ★' : ''), style: const TextStyle(fontSize: 12)),
                  selected: _next == s,
                  selectedColor: StatusStyle.lead(s).color,
                  labelStyle: TextStyle(color: _next == s ? Colors.white : null),
                  onSelected: (_) => setState(() => _next = s),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _next == null
                ? 'The lead stays "${lead.status.label}". No new follow-up is scheduled.'
                : 'Moving to "${_next!.label}" schedules the next follow-up and suggests an email automatically.',
            style: theme.textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            const SizedBox(width: 8),
            BzButton(label: _next == null ? 'Mark done' : 'Done & move to ${_next!.label}', icon: BootstrapIcons.check2, variant: BzVariant.success, onPressed: () => Navigator.of(context).pop((_outcome.text.trim(), _next))),
          ],
        ),
      ],
    );
  }
}

/// Snooze / reschedule menu.
Future<void> snoozeFollowUp(BuildContext context, FollowUp fu, {int? days, bool pick = false}) async {
  final container = ProviderScope.containerOf(context);
  DateTime? newDue;
  if (pick) {
    final d = await showDatePicker(context: context, initialDate: fu.dueAt.isBefore(DateTime.now()) ? DateTime.now() : fu.dueAt, firstDate: DateTime(2015), lastDate: DateTime(2100));
    if (d == null) return;
    newDue = fu.hasTime ? DateTime(d.year, d.month, d.day, fu.dueAt.hour, fu.dueAt.minute) : DateUtilsX.startOfDay(d);
  } else {
    final base = DateUtilsX.startOfDay(DateTime.now()).add(Duration(days: days ?? 1));
    newDue = fu.hasTime ? DateTime(base.year, base.month, base.day, fu.dueAt.hour, fu.dueAt.minute) : base;
  }
  final updated = await container.read(automationProvider).reschedule(fu, newDue);
  BzToasts.info('Rescheduled', message: '${updated.title} → ${updated.hasTime ? Fmt.dateTime(updated.dueAt) : Fmt.weekday(updated.dueAt)}');
}

Future<void> skipFollowUp(BuildContext context, FollowUp fu) async {
  final ok = await showBzConfirm(context, title: 'Skip this follow-up?', message: '"${fu.title}" will be marked as skipped. The lead keeps its status.', confirmLabel: 'Skip', variant: BzVariant.warning, icon: BootstrapIcons.skip_forward);
  if (!ok || !context.mounted) return;
  await ProviderScope.containerOf(context).read(automationProvider).skipFollowUp(fu);
  BzToasts.info('Follow-up skipped');
}

Future<void> deleteFollowUp(BuildContext context, FollowUp fu) async {
  final ok = await showBzConfirm(context, title: 'Delete follow-up?', message: 'This removes "${fu.title}" and its calendar event. This cannot be undone.', confirmLabel: 'Delete');
  if (!ok || !context.mounted) return;
  await ProviderScope.containerOf(context).read(automationProvider).deleteFollowUp(fu);
  BzToasts.info('Follow-up deleted');
}

/// Compact action row used by lists (dashboard, follow-ups page, detail pages).
class FollowUpQuickActions extends StatelessWidget {
  const FollowUpQuickActions({super.key, required this.fu, this.onEmail, this.compact = false});
  final FollowUp fu;
  final VoidCallback? onEmail;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (fu.status != FollowUpStatus.pending) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!compact)
          BzButton(label: 'Done', icon: BootstrapIcons.check2, size: BzSize.sm, variant: BzVariant.success, onPressed: () => completeFollowUpFlow(context, fu))
        else
          BzIconButton(icon: BootstrapIcons.check2, tooltip: 'Mark done', variant: BzVariant.success, onPressed: () => completeFollowUpFlow(context, fu)),
        const SizedBox(width: 4),
        if (onEmail != null) BzIconButton(icon: BootstrapIcons.envelope, tooltip: 'Send email', onPressed: onEmail),
        PopupMenuButton<String>(
          tooltip: 'Snooze',
          icon: const Icon(BootstrapIcons.alarm, size: 15),
          splashRadius: 16,
          onSelected: (v) {
            switch (v) {
              case 'tomorrow':
                snoozeFollowUp(context, fu, days: 1);
              case '2d':
                snoozeFollowUp(context, fu, days: 2);
              case 'week':
                snoozeFollowUp(context, fu, days: 7);
              case 'pick':
                snoozeFollowUp(context, fu, pick: true);
              case 'skip':
                skipFollowUp(context, fu);
              case 'delete':
                deleteFollowUp(context, fu);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'tomorrow', child: Text('Snooze to tomorrow')),
            PopupMenuItem(value: '2d', child: Text('Snooze 2 days')),
            PopupMenuItem(value: 'week', child: Text('Snooze 1 week')),
            PopupMenuItem(value: 'pick', child: Text('Pick a date…')),
            PopupMenuDivider(),
            PopupMenuItem(value: 'skip', child: Text('Skip')),
            PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: BzColors.danger))),
          ],
        ),
      ],
    );
  }
}
