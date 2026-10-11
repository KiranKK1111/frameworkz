import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
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
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_misc.dart';
import '../email/compose_email_dialog.dart';
import '../leads/leads_page.dart';
import 'followup_actions.dart';
import 'followup_form_dialog.dart';

enum _Tab { overdue, today, upcoming, done }

class FollowUpsPage extends ConsumerStatefulWidget {
  const FollowUpsPage({super.key});
  @override
  ConsumerState<FollowUpsPage> createState() => _FollowUpsPageState();
}

class _FollowUpsPageState extends ConsumerState<FollowUpsPage> {
  _Tab? _tab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final all = ref.watch(allFollowUpsProvider).value ?? const <FollowUp>[];
    final pending = all.where((f) => f.status == FollowUpStatus.pending).toList()..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    final overdue = pending.where((f) => DateUtilsX.isPastDay(f.dueAt)).toList();
    final today = pending.where((f) => DateUtilsX.isToday(f.dueAt)).toList();
    final upcoming = pending.where((f) => f.dueAt.isAfter(DateUtilsX.endOfDay(DateTime.now()))).toList();
    final done = all.where((f) => f.status != FollowUpStatus.pending).toList()..sort((a, b) => (b.completedAt ?? b.dueAt).compareTo(a.completedAt ?? a.dueAt));

    final tab = _tab ?? (overdue.isNotEmpty ? _Tab.overdue : (today.isNotEmpty ? _Tab.today : _Tab.upcoming));
    final list = switch (tab) { _Tab.overdue => overdue, _Tab.today => today, _Tab.upcoming => upcoming, _Tab.done => done };

    return BzPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzPageHeader(
            title: 'Follow-ups',
            subtitle: 'Your daily to-do list. Reminders fire at ${ref.watch(settingsSnapshotProvider).dailyReminderTime} and before every meeting.',
            icon: BootstrapIcons.bell,
            actions: [
              BzButton(label: 'Meeting', icon: BootstrapIcons.camera_video, variant: BzVariant.light, onPressed: () => showFollowUpFormDialog(context, ref, meeting: true)),
              BzButton(label: 'New follow-up', icon: BootstrapIcons.plus_lg, onPressed: () => showFollowUpFormDialog(context, ref)),
            ],
          ),
          BzResponsiveGrid(
            minItemWidth: 150,
            maxColumns: 4,
            gap: context.isPhone ? 10 : 14,
            itemHeight: context.isPhone ? 96 : 116,
            children: [
              BzStatTile(label: 'Overdue', value: '${overdue.length}', numericValue: overdue.length, icon: BootstrapIcons.exclamation_circle, variant: BzVariant.danger, onTap: () => setState(() => _tab = _Tab.overdue)),
              BzStatTile(label: 'Due today', value: '${today.length}', numericValue: today.length, icon: BootstrapIcons.alarm, variant: BzVariant.warning, delay: 60.ms, onTap: () => setState(() => _tab = _Tab.today)),
              BzStatTile(label: 'Upcoming', value: '${upcoming.length}', numericValue: upcoming.length, icon: BootstrapIcons.calendar3, variant: BzVariant.primary, delay: 120.ms, onTap: () => setState(() => _tab = _Tab.upcoming)),
              BzStatTile(label: 'Completed', value: '${done.where((f) => f.status == FollowUpStatus.done).length}', numericValue: done.where((f) => f.status == FollowUpStatus.done).length, icon: BootstrapIcons.check_circle_fill, variant: BzVariant.success, delay: 180.ms, onTap: () => setState(() => _tab = _Tab.done)),
            ],
          ),
          const SizedBox(height: 18),
          BzHScroll(
            gap: 6,
            children: [
              for (final t in _Tab.values)
                ChoiceChip(
                  label: Text(switch (t) { _Tab.overdue => 'Overdue (${overdue.length})', _Tab.today => 'Today (${today.length})', _Tab.upcoming => 'Upcoming (${upcoming.length})', _Tab.done => 'History (${done.length})' }),
                  selected: tab == t,
                  onSelected: (_) => setState(() => _tab = t),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (list.isEmpty)
            BzEmptyState(
              icon: switch (tab) { _Tab.overdue => BootstrapIcons.emoji_smile, _Tab.today => BootstrapIcons.cup_hot, _Tab.upcoming => BootstrapIcons.calendar_check, _Tab.done => BootstrapIcons.clock_history },
              title: switch (tab) { _Tab.overdue => 'Nothing overdue 🎉', _Tab.today => 'Nothing due today', _Tab.upcoming => 'Nothing scheduled', _Tab.done => 'No history yet' },
              message: switch (tab) {
                _Tab.overdue => 'You are on top of your pipeline.',
                _Tab.today => 'Enjoy the quiet, or move a lead forward to create the next touchpoint.',
                _Tab.upcoming => 'Change a lead status or schedule a follow-up manually.',
                _Tab.done => 'Completed and skipped follow-ups will appear here.',
              },
              compact: true,
            )
          else
            ..._grouped(list, tab, theme),
        ],
      ),
    );
  }

  List<Widget> _grouped(List<FollowUp> list, _Tab tab, ThemeData theme) {
    final groups = <String, List<FollowUp>>{};
    for (final f in list) {
      final key = tab == _Tab.done ? Fmt.date(f.completedAt ?? f.dueAt) : Fmt.weekday(f.dueAt);
      groups.putIfAbsent(key, () => []).add(f);
    }
    final widgets = <Widget>[];
    var i = 0;
    for (final e in groups.entries) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 8),
        child: Row(children: [
          Text(e.key.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.8, fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: theme.colorScheme.outlineVariant)),
        ]),
      ));
      widgets.add(BzCard(
        padding: const EdgeInsets.all(6),
        child: Column(children: [
          for (var j = 0; j < e.value.length; j++) ...[
            _FollowUpRow(fu: e.value[j], index: i++),
            if (j < e.value.length - 1) const Divider(),
          ],
        ]),
      ));
      widgets.add(const SizedBox(height: 14));
    }
    return widgets;
  }
}

class _FollowUpRow extends ConsumerWidget {
  const _FollowUpRow({required this.fu, required this.index});
  final FollowUp fu;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final leads = ref.watch(leadsByIdProvider);
    final clients = ref.watch(clientsByIdProvider);
    final lead = fu.leadId != null ? leads[fu.leadId!] : null;
    final client = fu.clientId != null ? clients[fu.clientId!] : null;
    final who = lead?.business ?? client?.name ?? '';
    final contact = lead?.contactPerson ?? client?.contactPerson ?? '';
    final email_ = lead?.email ?? client?.email ?? '';
    final phone = lead?.phone ?? client?.phone ?? '';
    final pending = fu.status == FollowUpStatus.pending;
    final v = pending ? DueBadge.variantFor(fu.dueAt) : StatusStyle.followUp(fu.status);
    final onTap = lead != null ? () => context.go(Routes.lead(lead.id)) : (client != null ? () => context.go(Routes.client(client.id)) : null);

    void email() {
      final s = ref.read(settingsSnapshotProvider);
      showComposeEmailDialog(
        context,
        to: email_,
        vars: lead != null ? TemplateEngine.leadVars(lead, s, meeting: fu.hasTime ? fu : null) : TemplateEngine.clientVars(client!, s),
        entityType: lead != null ? EntityType.lead : EntityType.client,
        entityId: lead?.id ?? client!.id,
      );
    }

    if (context.isCompact) {
      return BzHoverRow(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: v.subtle(theme.brightness), borderRadius: BorderRadius.circular(11)),
                alignment: Alignment.center,
                child: Icon(StatusStyle.followUpType(fu.type), size: 15, color: v.emphasis(theme.brightness)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(fu.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, decoration: fu.status == FollowUpStatus.done ? TextDecoration.lineThrough : null), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text([if (who.isNotEmpty) who, fu.hasTime ? '${Fmt.time(fu.dueAt)} · ${fu.durationMinutes} min' : fu.type.label].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  if (pending) DueBadge(fu.dueAt, hasTime: fu.hasTime) else FollowUpStatusBadge(fu.status),
                  if (lead != null) LeadStatusBadge(lead.status),
                ]),
              ),
              const SizedBox(width: 6),
              if (pending) ...[
                if (phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(phone)),
                if (fu.meetLink.isNotEmpty) BzIconButton(icon: BootstrapIcons.camera_video, tooltip: 'Join Google Meet', variant: BzVariant.primary, onPressed: () => launchUrl(Uri.parse(fu.meetLink))),
                FollowUpQuickActions(fu: fu, compact: true, onEmail: email_.isEmpty ? null : email),
              ],
            ]),
          ],
        ),
      ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
    }

    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: v.subtle(theme.brightness), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(StatusStyle.followUpType(fu.type), size: 17, color: v.emphasis(theme.brightness)),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fu.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, decoration: fu.status == FollowUpStatus.done ? TextDecoration.lineThrough : null)),
                const SizedBox(height: 2),
                Wrap(spacing: 10, runSpacing: 2, crossAxisAlignment: WrapCrossAlignment.center, children: [
                  if (who.isNotEmpty)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(lead != null ? BootstrapIcons.funnel : BootstrapIcons.people, size: 11, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Flexible(child: Text([who, if (contact.isNotEmpty) contact].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                  Text(fu.hasTime ? '${Fmt.time(fu.dueAt)} · ${fu.durationMinutes} min' : fu.type.label, style: theme.textTheme.bodySmall),
                  if (fu.calendarEventId != null) const Icon(BootstrapIcons.google, size: 10, color: BzColors.success),
                  if (fu.outcome.isNotEmpty) Text('→ ${fu.outcome}', style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ],
            ),
          ),
          if (lead != null) Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: LeadStatusBadge(lead.status))),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: pending ? DueBadge(fu.dueAt, hasTime: fu.hasTime) : FollowUpStatusBadge(fu.status))),
          if (pending) ...[
            if (phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(phone)),
            if (phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.telephone, tooltip: 'Call $phone', onPressed: () => launchUrl(Uri.parse('tel:$phone'))),
            if (fu.meetLink.isNotEmpty) BzIconButton(icon: BootstrapIcons.camera_video, tooltip: 'Join Google Meet', variant: BzVariant.primary, onPressed: () => launchUrl(Uri.parse(fu.meetLink))),
            const SizedBox(width: 4),
            FollowUpQuickActions(fu: fu, onEmail: email_.isEmpty ? null : email),
          ] else if (fu.completedAt != null)
            Text('Done ${Fmt.timeAgo(fu.completedAt!)}', style: theme.textTheme.labelSmall),
        ],
      ),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}
