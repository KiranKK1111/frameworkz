import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/responsive.dart';
import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_alert.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_misc.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../email/compose_email_dialog.dart';
import '../followups/followup_actions.dart';
import '../followups/followup_form_dialog.dart';
import 'convert_to_client_dialog.dart';
import 'lead_form_dialog.dart';
import 'leads_page.dart';
import 'status_change_dialog.dart';

class LeadDetailPage extends ConsumerWidget {
  const LeadDetailPage({super.key, required this.leadId});
  final String leadId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadAsync = ref.watch(leadProvider(leadId));
    final lead = leadAsync.value;
    if (leadAsync.isLoading) return const BzLoading();
    if (lead == null) {
      return BzEmptyState(icon: BootstrapIcons.question_circle, title: 'Lead not found', message: 'It may have been deleted.', actionLabel: 'Back to leads', onAction: () => context.go(Routes.leads));
    }
    final theme = Theme.of(context);

    final followUps = ref.watch(leadFollowUpsProvider(leadId)).value ?? const <FollowUp>[];
    final activities = ref.watch(activitiesProvider((EntityType.lead, leadId))).value ?? const <Activity>[];
    final emails = ref.watch(emailLogsProvider((EntityType.lead, leadId))).value ?? const <EmailLog>[];
    final pending = followUps.where((f) => f.status == FollowUpStatus.pending).toList();
    final history = followUps.where((f) => f.status != FollowUpStatus.pending).toList();

    final phone = context.isPhone;
    final headerActions = <Widget>[
      _StatusButton(lead: lead),
      BzButton(label: 'Follow-up', icon: BootstrapIcons.bell, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, lead: lead)),
      BzButton(label: 'Meeting', icon: BootstrapIcons.camera_video, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, lead: lead, meeting: true)),
      BzButton(label: 'Email', icon: BootstrapIcons.envelope, variant: BzVariant.light, onPressed: lead.email.isEmpty ? null : () => _compose(context, ref, lead, null)),
      BzMoreMenu(entries: [
        BzMenuEntry('Edit details', BootstrapIcons.pencil, () => showLeadFormDialog(context, ref, existing: lead)),
        if (lead.clientId == null) BzMenuEntry('Convert to client', BootstrapIcons.person_check, () => showConvertToClientDialog(context, lead)),
        BzMenuEntry('Copy contact details', BootstrapIcons.copy, () {
          Clipboard.setData(ClipboardData(text: [lead.business, lead.contactPerson, lead.phone, lead.email, lead.instagram].where((s) => s.isNotEmpty).join('\n')));
          BzToasts.info('Contact details copied');
        }),
        BzMenuEntry('Delete lead', BootstrapIcons.trash3, () async {
          final ok = await showBzConfirm(context, title: 'Delete lead?', message: 'This permanently removes ${lead.business}, its follow-ups and history.', confirmLabel: 'Delete');
          if (ok) {
            await ref.read(leadsRepoProvider).delete(lead.id);
            BzToasts.info('Lead deleted');
            if (context.mounted) context.go(Routes.leads);
          }
        }, danger: true),
      ]),
    ];

    return BzPage(
      maxWidth: 1500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BzAvatar(lead.business, size: phone ? 44 : 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      InkWell(onTap: () => context.go(Routes.leads), child: Text('Leads', style: theme.textTheme.bodySmall?.copyWith(color: BzColors.primary))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: Icon(BootstrapIcons.chevron_right, size: 10, color: theme.colorScheme.onSurfaceVariant)),
                      Text(lead.id, style: theme.textTheme.bodySmall),
                    ]),
                    const SizedBox(height: 4),
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 10, runSpacing: 6, children: [
                      Text(lead.business, style: theme.textTheme.headlineSmall?.copyWith(fontSize: phone ? 20 : 22)),
                      LeadStatusBadge(lead.status, withIcon: true),
                      if (lead.clientId != null) InkWell(onTap: () => context.go(Routes.client(lead.clientId!)), child: BzBadge('Client ${lead.clientId}', variant: BzVariant.success, icon: BootstrapIcons.person_check)),
                    ]),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 6, children: [
                      if (lead.contactPerson.isNotEmpty) BzMetaChip(icon: BootstrapIcons.person, text: lead.contactPerson),
                      if (lead.phone.isNotEmpty) BzMetaChip(icon: BootstrapIcons.telephone, text: lead.phone, onTap: () => launchUrl(Uri.parse('tel:${lead.phone}'))),
                      if (lead.phone.isNotEmpty) BzMetaChip(icon: BootstrapIcons.whatsapp, text: 'WhatsApp', color: BzColors.success, onTap: () => openWhatsApp(lead.phone)),
                      if (lead.email.isNotEmpty) BzMetaChip(icon: BootstrapIcons.envelope, text: lead.email, onTap: () => _compose(context, ref, lead, null)),
                      if (lead.instagram.isNotEmpty) BzMetaChip(icon: BootstrapIcons.instagram, text: lead.instagram, color: BzColors.pink, onTap: () => openInstagram(lead.instagram)),
                      BzMetaChip(icon: StatusStyle.source(lead.source), text: lead.source.label),
                      BzMetaChip(icon: StatusStyle.service(lead.service), text: lead.service.label),
                      if (lead.potentialValue > 0) BzMetaChip(icon: BootstrapIcons.currency_rupee, text: Fmt.money(lead.potentialValue)),
                    ]),
                  ],
                ),
              ),
              if (!context.isCompact) ...[
                const SizedBox(width: 12),
                Wrap(spacing: 8, runSpacing: 8, children: headerActions),
              ],
            ],
          ).animate().fadeIn(duration: 250.ms),
          if (context.isCompact) ...[
            const SizedBox(height: 14),
            BzResponsiveGrid(minItemWidth: 104, maxColumns: 3, gap: 8, children: headerActions),
          ],
          const SizedBox(height: 20),
          if (lead.status.isOpen && lead.nextFollowUp != null && DateUtilsX.isPastDay(lead.nextFollowUp!))
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: BzAlert(
                variant: BzVariant.danger,
                title: 'Follow-up overdue',
                message: 'Was due ${Fmt.relativeDay(lead.nextFollowUp).toLowerCase()} (${Fmt.weekday(lead.nextFollowUp)}). Mark it done or snooze it.',
                action: pending.isNotEmpty ? BzButton(label: 'Mark done', size: BzSize.sm, variant: BzVariant.danger, onPressed: () => completeFollowUpFlow(context, pending.first)) : null,
              ),
            ),
          // Pipeline stepper (its steps scroll horizontally when narrow)
          _PipelineStepper(lead: lead),
          const SizedBox(height: 20),
          BzTwoColumn(
            ratio: 3,
            rightFlex: 2,
            left: BzFillColumn(
                  children: [
                    BzCard(
                      title: 'Follow-ups & meetings',
                      subtitle: pending.isEmpty ? 'Nothing scheduled' : '${pending.length} pending',
                      actions: [BzButton(label: 'Schedule', icon: BootstrapIcons.plus_lg, size: BzSize.sm, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, lead: lead))],
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          if (followUps.isEmpty) const BzEmptyState(icon: BootstrapIcons.bell, title: 'No follow-ups', message: 'Change the status or schedule one manually.', compact: true),
                          for (final f in pending) _FollowUpTile(fu: f, lead: lead),
                          if (history.isNotEmpty && pending.isNotEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8), child: BzLabeledDivider('History')),
                          for (final f in history.take(6)) _FollowUpTile(fu: f, lead: lead),
                        ],
                      ),
                    ),
                    BzCard(
                      title: 'Details',
                      actions: [BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showLeadFormDialog(context, ref, existing: lead))],
                      child: Column(
                        children: [
                          BzKeyValue('Added', Fmt.dateTime(lead.dateAdded), icon: BootstrapIcons.calendar_plus),
                          BzKeyValue('Last contact', lead.lastContact == null ? '—' : '${Fmt.date(lead.lastContact)} (${Fmt.relativeDay(lead.lastContact)})', icon: BootstrapIcons.clock_history),
                          BzKeyValue('Next follow-up', '', icon: BootstrapIcons.bell, valueWidget: Align(alignment: Alignment.centerLeft, child: DueBadge(lead.nextFollowUp))),
                          BzKeyValue('Potential value', lead.potentialValue > 0 ? Fmt.money(lead.potentialValue) : '—', icon: BootstrapIcons.currency_rupee),
                          BzKeyValue('Proposal', lead.proposalLink, icon: BootstrapIcons.file_earmark_text, onTap: () => launchUrl(Uri.parse(lead.proposalLink))),
                          BzKeyValue('Drive folder', lead.driveFolder, icon: BootstrapIcons.folder, onTap: () => launchUrl(Uri.parse(lead.driveFolder))),
                          if (lead.lostReason.isNotEmpty) BzKeyValue('Lost reason', lead.lostReason, icon: BootstrapIcons.emoji_frown),
                          if (lead.externalKey != null) BzKeyValue('Imported from', lead.externalKey!.startsWith('form') ? 'Google Form' : 'Google Sheets', icon: BootstrapIcons.file_earmark_spreadsheet),
                          if (lead.notes.isNotEmpty) ...[
                            const Divider(height: 20),
                            Align(alignment: Alignment.centerLeft, child: Text('Notes', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600))),
                            const SizedBox(height: 4),
                            Align(alignment: Alignment.centerLeft, child: SelectableText(lead.notes, style: theme.textTheme.bodyMedium)),
                          ],
                        ],
                      ),
                    ),
                    BzCard(
                      fill: true,
                      title: 'Emails sent',
                      subtitle: emails.isEmpty ? 'No emails yet' : '${emails.length} sent',
                      actions: [BzButton(label: 'Compose', icon: BootstrapIcons.envelope_plus, size: BzSize.sm, variant: BzVariant.light, onPressed: lead.email.isEmpty ? null : () => _compose(context, ref, lead, null))],
                      padding: const EdgeInsets.all(8),
                      child: emails.isEmpty
                          ? Padding(padding: const EdgeInsets.all(12), child: Text(lead.email.isEmpty ? 'Add an email address to send templated emails.' : 'Change the status to get a suggested template, or compose freely.', style: theme.textTheme.bodySmall))
                          : Column(children: [
                              for (final e in emails.take(8))
                                BzHoverRow(
                                  onTap: () => showBzModal(context: context, title: e.subject, subtitle: 'To ${e.toAddress} · ${Fmt.dateTime(e.sentAt)}', icon: BootstrapIcons.envelope_open, width: 640, child: SelectableText(e.body, style: theme.textTheme.bodyMedium?.copyWith(height: 1.6))),
                                  child: Row(children: [
                                    Icon(e.error == null ? BootstrapIcons.send_check : BootstrapIcons.envelope_x, size: 15, color: e.error == null ? BzColors.success : BzColors.danger),
                                    const SizedBox(width: 10),
                                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(e.subject, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                      Text(e.error ?? 'To ${e.toAddress}', style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                                    ])),
                                    Text(Fmt.timeAgo(e.sentAt), style: theme.textTheme.labelSmall),
                                  ]),
                                ),
                            ]),
                    ),
                  ],
                ),
            right: BzCard(
                  fill: true,
                  title: 'Timeline',
                  subtitle: 'Everything that happened with this lead',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NoteComposer(leadId: lead.id),
                      const SizedBox(height: 16),
                      if (activities.isEmpty) Text('No activity yet.', style: theme.textTheme.bodySmall),
                      for (var i = 0; i < activities.length; i++)
                        BzTimelineItem(
                          icon: _activityIcon(activities[i].kind),
                          color: _activityColor(activities[i].kind),
                          title: activities[i].title,
                          detail: activities[i].detail,
                          time: activities[i].createdAt,
                          isLast: i == activities.length - 1,
                        ),
                    ],
                  ),
                ),
          ),
        ],
      ),
    );
  }

  static IconData _activityIcon(ActivityKind k) => switch (k) {
        ActivityKind.created => BootstrapIcons.stars,
        ActivityKind.statusChanged => BootstrapIcons.arrow_right_circle,
        ActivityKind.note => BootstrapIcons.journal_text,
        ActivityKind.followUpDone => BootstrapIcons.check_circle_fill,
        ActivityKind.followUpSnoozed => BootstrapIcons.alarm,
        ActivityKind.emailSent => BootstrapIcons.send_check,
        ActivityKind.meetingScheduled => BootstrapIcons.camera_video,
        ActivityKind.converted => BootstrapIcons.trophy,
        ActivityKind.calendarSynced => BootstrapIcons.google,
        ActivityKind.imported => BootstrapIcons.file_earmark_spreadsheet,
        ActivityKind.invoice => BootstrapIcons.receipt,
        ActivityKind.project => BootstrapIcons.camera_reels,
      };

  static Color _activityColor(ActivityKind k) => switch (k) {
        ActivityKind.followUpDone || ActivityKind.converted || ActivityKind.emailSent => BzColors.success,
        ActivityKind.followUpSnoozed => BzColors.warning,
        ActivityKind.note => BzColors.secondary,
        ActivityKind.calendarSynced => BzColors.teal,
        _ => BzColors.primary,
      };
}

Future<void> _compose(BuildContext context, WidgetRef ref, Lead lead, EmailTemplate? tpl) {
  return showComposeEmailDialog(context, to: lead.email, vars: TemplateEngine.leadVars(lead, ref.read(settingsSnapshotProvider)), template: tpl, entityType: EntityType.lead, entityId: lead.id);
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({required this.lead});
  final Lead lead;
  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 6),
      builder: (context, controller, _) => BzButton(
        label: context.isPhone ? 'Status' : 'Change status',
        icon: BootstrapIcons.arrow_repeat,
        trailingIcon: BootstrapIcons.chevron_down,
        onPressed: () => controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        for (final s in LeadStatus.values)
          MenuItemButton(
            onPressed: s == lead.status ? null : () => showStatusChangeDialog(context, lead, s),
            leadingIcon: Icon(StatusStyle.leadIcon(s), size: 14, color: StatusStyle.lead(s).color),
            child: SizedBox(width: 180, child: Text(s.label, style: TextStyle(fontWeight: s == lead.status ? FontWeight.w700 : FontWeight.w500))),
          ),
      ],
    );
  }
}

/// Horizontal pipeline progress with clickable steps.
class _PipelineStepper extends StatelessWidget {
  const _PipelineStepper({required this.lead});
  final Lead lead;

  static const _steps = [LeadStatus.newLead, LeadStatus.contacted, LeadStatus.replied, LeadStatus.callScheduled, LeadStatus.proposalSent, LeadStatus.negotiation, LeadStatus.won];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentIdx = _steps.indexOf(lead.status);
    final isLost = lead.status == LeadStatus.lost;
    final isNurture = lead.status == LeadStatus.nurture;
    final phone = context.isPhone;
    final row = Row(
        children: [
          for (var i = 0; i < _steps.length; i++) ...[
            Expanded(
              child: Tooltip(
                message: 'Move to ${_steps[i].label}',
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _steps[i] == lead.status ? null : () => showStatusChangeDialog(context, lead, _steps[i]),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i < currentIdx ? BzColors.success : (i == currentIdx ? StatusStyle.lead(lead.status).color : theme.colorScheme.surfaceContainerHighest),
                          border: Border.all(color: i <= currentIdx ? Colors.transparent : theme.colorScheme.outline),
                        ),
                        alignment: Alignment.center,
                        child: Icon(i < currentIdx ? BootstrapIcons.check2 : StatusStyle.leadIcon(_steps[i]), size: 13, color: i <= currentIdx ? (StatusStyle.lead(_steps[i]).onColor) : theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 6),
                      Text(_steps[i].label, style: theme.textTheme.labelSmall?.copyWith(fontWeight: i == currentIdx ? FontWeight.w700 : FontWeight.w500, color: i == currentIdx ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ),
            if (i < _steps.length - 1)
              Expanded(
                flex: 0,
                child: Container(width: 24, height: 2, margin: const EdgeInsets.only(bottom: 20), color: i < currentIdx ? BzColors.success : theme.colorScheme.outline),
              ),
          ],
          if (isLost || isNurture) ...[
            const SizedBox(width: 12),
            BzBadge(lead.status.label, variant: StatusStyle.lead(lead.status), soft: false, icon: StatusStyle.leadIcon(lead.status)),
          ],
        ],
      );
    final minWidth = (isLost || isNurture) ? 880.0 : 760.0;
    return BzCard(
      padding: EdgeInsets.fromLTRB(phone ? 12 : 18, 16, phone ? 12 : 18, 14),
      child: LayoutBuilder(builder: (context, c) {
        if (c.maxWidth >= minWidth) return row;
        return SingleChildScrollView(scrollDirection: Axis.horizontal, child: SizedBox(width: minWidth, child: row));
      }),
    );
  }
}

class _FollowUpTile extends ConsumerWidget {
  const _FollowUpTile({required this.fu, required this.lead});
  final FollowUp fu;
  final Lead lead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pending = fu.status == FollowUpStatus.pending;
    final v = pending ? DueBadge.variantFor(fu.dueAt) : StatusStyle.followUp(fu.status);
    final compact = context.isPhone;
    final Widget badge = pending ? DueBadge(fu.dueAt, hasTime: fu.hasTime) : FollowUpStatusBadge(fu.status);
    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: v.subtle(theme.brightness), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Icon(StatusStyle.followUpType(fu.type), size: 15, color: v.emphasis(theme.brightness)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fu.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, decoration: fu.status == FollowUpStatus.done ? TextDecoration.lineThrough : null)),
                Wrap(spacing: 8, runSpacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(fu.hasTime ? Fmt.dateTime(fu.dueAt) : Fmt.weekday(fu.dueAt), style: theme.textTheme.bodySmall),
                  if (fu.calendarEventId != null)
                    Row(mainAxisSize: MainAxisSize.min, children: [const Icon(BootstrapIcons.google, size: 10, color: BzColors.success), const SizedBox(width: 3), Text('Calendar', style: theme.textTheme.labelSmall?.copyWith(color: BzColors.success))]),
                  if (fu.meetLink.isNotEmpty) InkWell(onTap: () => launchUrl(Uri.parse(fu.meetLink)), child: Text('Meet link', style: theme.textTheme.labelSmall?.copyWith(color: BzColors.primary))),
                  if (fu.outcome.isNotEmpty) Text('· ${fu.outcome}', style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
                if (compact) ...[
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(child: Align(alignment: Alignment.centerLeft, child: badge)),
                    if (pending) FollowUpQuickActions(fu: fu, compact: true, onEmail: lead.email.isEmpty ? null : () => _compose(context, ref, lead, null)),
                  ]),
                ],
              ],
            ),
          ),
          if (!compact) ...[
            const SizedBox(width: 8),
            badge,
            const SizedBox(width: 6),
            if (pending) FollowUpQuickActions(fu: fu, compact: true, onEmail: lead.email.isEmpty ? null : () => _compose(context, ref, lead, null)),
          ],
        ],
      ),
    );
  }
}

class _NoteComposer extends ConsumerStatefulWidget {
  const _NoteComposer({required this.leadId});
  final String leadId;
  @override
  ConsumerState<_NoteComposer> createState() => _NoteComposerState();
}

class _NoteComposerState extends ConsumerState<_NoteComposer> {
  final _c = TextEditingController();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final t = _c.text.trim();
    if (t.isEmpty) return;
    await ref.read(leadsRepoProvider).addNote(widget.leadId, t);
    _c.clear();
    BzToasts.success('Note added');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: BzTextField(controller: _c, hint: 'Add a note… (Enter to save)', minLines: 1, maxLines: 4, onSubmitted: (_) => _add(), textInputAction: TextInputAction.done)),
        const SizedBox(width: 8),
        BzButton(label: 'Add', icon: BootstrapIcons.journal_text, onPressed: _add),
      ],
    );
  }
}
