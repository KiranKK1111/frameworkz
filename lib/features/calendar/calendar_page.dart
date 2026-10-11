import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/responsive.dart';
import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_misc.dart';
import '../followups/followup_actions.dart';
import '../followups/followup_form_dialog.dart';

enum _Kind { followUp, meeting, shoot, deadline, invoice }

Color _kindColor(_Kind k) => switch (k) {
      _Kind.followUp => BzColors.warning,
      _Kind.meeting => BzColors.primary,
      _Kind.shoot => BzColors.info,
      _Kind.deadline => BzColors.danger,
      _Kind.invoice => BzColors.success,
    };

String _kindLabel(_Kind k) => switch (k) {
      _Kind.followUp => 'Follow-up',
      _Kind.meeting => 'Meeting',
      _Kind.shoot => 'Shoot',
      _Kind.deadline => 'Deadline',
      _Kind.invoice => 'Invoice due',
    };

class _CalItem {
  _CalItem({required this.at, required this.kind, required this.title, required this.subtitle, this.followUp, this.route, this.allDay = true, this.done = false});
  final DateTime at;
  final _Kind kind;
  final String title;
  final String subtitle;
  final FollowUp? followUp;
  final String? route;
  final bool allDay;
  final bool done;

  Color get color => _kindColor(kind);
  IconData get icon => switch (kind) {
        _Kind.followUp => BootstrapIcons.bell,
        _Kind.meeting => BootstrapIcons.camera_video,
        _Kind.shoot => BootstrapIcons.camera_reels,
        _Kind.deadline => BootstrapIcons.hourglass_split,
        _Kind.invoice => BootstrapIcons.receipt,
      };
}

/// Month view of everything time-bound: follow-ups, meetings, shoots,
/// deadlines and invoice due dates. Mirrors what Google Calendar receives.
///
/// Desktop: month grid + day panel side by side. Phone: compact grid with
/// dots, day list below (scrolls).
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});
  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _month = DateUtilsX.startOfMonth(DateTime.now());
  DateTime _selected = DateUtilsX.startOfDay(DateTime.now());

  Map<DateTime, List<_CalItem>> _collect() {
    final followUps = ref.watch(allFollowUpsProvider).value ?? const <FollowUp>[];
    final projects = ref.watch(projectsProvider).value ?? const <Project>[];
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final leads = ref.watch(leadsByIdProvider);
    final clients = ref.watch(clientsByIdProvider);
    final map = <DateTime, List<_CalItem>>{};
    void add(_CalItem it) => map.putIfAbsent(DateUtilsX.startOfDay(it.at), () => []).add(it);

    for (final f in followUps) {
      if (f.status == FollowUpStatus.superseded) continue;
      final who = leads[f.leadId]?.business ?? clients[f.clientId]?.name ?? '';
      add(_CalItem(
        at: f.dueAt,
        kind: f.type == FollowUpType.meeting ? _Kind.meeting : _Kind.followUp,
        title: f.title,
        subtitle: [who, f.type.label, if (f.hasTime) '${Fmt.time(f.dueAt)} · ${f.durationMinutes} min'].where((s) => s.isNotEmpty).join(' · '),
        followUp: f,
        allDay: !f.hasTime,
        done: f.status != FollowUpStatus.pending,
        route: f.leadId != null ? Routes.lead(f.leadId!) : (f.clientId != null ? Routes.client(f.clientId!) : null),
      ));
    }
    for (final p in projects) {
      final c = clients[p.clientId]?.name ?? '';
      if (p.shootDate != null) add(_CalItem(at: p.shootDate!, kind: _Kind.shoot, title: 'Shoot · ${p.name}', subtitle: c, route: Routes.projects, allDay: p.shootDate!.hour == 0 && p.shootDate!.minute == 0, done: !p.status.isOpen));
      if (p.deadline != null) add(_CalItem(at: p.deadline!, kind: _Kind.deadline, title: 'Deadline · ${p.name}', subtitle: c, route: Routes.projects, done: !p.status.isOpen));
    }
    for (final i in invoices) {
      if (i.status == InvoiceStatus.cancelled || i.status == InvoiceStatus.draft) continue;
      add(_CalItem(at: i.dueDate, kind: _Kind.invoice, title: 'Invoice ${i.id} due', subtitle: '${clients[i.clientId]?.name ?? ''} · ${Fmt.money(i.amount - i.amountReceived)}', route: Routes.finance, done: i.status == InvoiceStatus.paid));
    }
    for (final l in map.values) {
      l.sort((a, b) => a.allDay != b.allDay ? (a.allDay ? 1 : -1) : a.at.compareTo(b.at));
    }
    return map;
  }

  void _prev() => setState(() => _month = DateTime(_month.year, _month.month - 1));
  void _next() => setState(() => _month = DateTime(_month.year, _month.month + 1));
  void _today() => setState(() {
        _month = DateUtilsX.startOfMonth(DateTime.now());
        _selected = DateUtilsX.startOfDay(DateTime.now());
      });

  @override
  Widget build(BuildContext context) {
    final items = _collect();
    final selectedItems = items[_selected] ?? const <_CalItem>[];
    final phone = context.isPhone;

    final navActions = <Widget>[
      BzIconButton(icon: BootstrapIcons.chevron_left, tooltip: 'Previous month', onPressed: _prev),
      BzButton(label: 'Today', variant: BzVariant.light, size: BzSize.sm, onPressed: _today),
      BzIconButton(icon: BootstrapIcons.chevron_right, tooltip: 'Next month', onPressed: _next),
      const SizedBox(width: 8),
      BzButton(label: 'Schedule', icon: BootstrapIcons.calendar_plus, onPressed: () => showFollowUpFormDialog(context, ref)),
    ];

    final dayCard = BzCard(
      fill: !phone,
      title: Fmt.weekday(_selected),
      subtitle: selectedItems.isEmpty ? 'Nothing scheduled' : '${selectedItems.length} items',
      actions: [BzIconButton(icon: BootstrapIcons.plus_lg, tooltip: 'Schedule on this day', onPressed: () => showFollowUpFormDialog(context, ref))],
      padding: const EdgeInsets.all(8),
      child: selectedItems.isEmpty
          ? const BzEmptyState(icon: BootstrapIcons.calendar_check, title: 'Free day', message: 'Pick another day or schedule something here.', compact: true)
          : phone
              ? Column(children: [for (var i = 0; i < selectedItems.length; i++) _ItemRow(item: selectedItems[i], index: i)])
              : ListView(children: [for (var i = 0; i < selectedItems.length; i++) _ItemRow(item: selectedItems[i], index: i)]),
    );

    if (phone) {
      return BzPage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BzPageHeader(title: Fmt.monthYear(_month), phoneTitle: true, subtitle: 'Follow-ups, meetings, shoots, deadlines and invoices', actions: navActions),
            _MonthGrid(month: _month, items: items, selected: _selected, compact: true, onSelect: (d) => setState(() => _selected = d)),
            const SizedBox(height: 14),
            dayCard,
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
          BzPageHeader(
            title: 'Calendar',
            subtitle: 'Follow-ups, meetings, shoots, deadlines and invoice due dates — the same events you see in Google Calendar.',
            icon: BootstrapIcons.calendar3,
            actions: navActions,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _MonthGrid(month: _month, items: items, selected: _selected, compact: context.isTablet, onSelect: (d) => setState(() => _selected = d))),
                const SizedBox(width: 16),
                SizedBox(width: context.isTablet ? 300 : 360, child: dayCard),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.month, required this.items, required this.selected, required this.onSelect, this.compact = false});
  final DateTime month;
  final Map<DateTime, List<_CalItem>> items;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leading = (month.weekday + 6) % 7; // Monday first
    final days = DateUtilsX.endOfMonth(month).day;
    final rows = ((leading + days) / 7).ceil();
    final phone = context.isPhone;

    Widget cell(int r, int c) {
      final idx = r * 7 + c - leading;
      if (idx < 0 || idx >= days) {
        return Container(decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5), border: Border(right: BorderSide(color: theme.colorScheme.outlineVariant), bottom: BorderSide(color: theme.colorScheme.outlineVariant))));
      }
      final day = DateTime(month.year, month.month, idx + 1);
      return _DayCell(day: day, items: items[day] ?? const [], selected: DateUtilsX.isSameDay(day, selected), compact: compact, onTap: () => onSelect(day));
    }

    final grid = Column(
      children: [
        for (var r = 0; r < rows; r++)
          phone
              ? SizedBox(height: 54, child: Row(children: [for (var c = 0; c < 7; c++) Expanded(child: cell(r, c))]))
              : Expanded(child: Row(children: [for (var c = 0; c < 7; c++) Expanded(child: cell(r, c))])),
      ],
    );

    return BzCard(
      padding: EdgeInsets.zero,
      clip: true,
      fill: !phone,
      child: Column(
        mainAxisSize: phone ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!phone) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Row(children: [
                Text(Fmt.monthYear(month), style: theme.textTheme.titleMedium),
                const SizedBox(width: 12),
                Expanded(
                  child: Wrap(alignment: WrapAlignment.end, spacing: 12, runSpacing: 4, children: [
                    for (final k in _Kind.values)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: _kindColor(k), shape: BoxShape.circle)),
                        const SizedBox(width: 5),
                        Text(_kindLabel(k), style: theme.textTheme.labelSmall),
                      ]),
                  ]),
                ),
              ]),
            ),
            const Divider(),
          ],
          Row(children: [
            for (final d in const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'])
              Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(d.toUpperCase(), textAlign: TextAlign.center, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6, color: theme.colorScheme.onSurfaceVariant)))),
          ]),
          const Divider(),
          if (phone) grid else Expanded(child: grid),
          if (phone)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Wrap(spacing: 12, runSpacing: 4, children: [
                for (final k in _Kind.values)
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(width: 7, height: 7, decoration: BoxDecoration(color: _kindColor(k), shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text(_kindLabel(k), style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.5)),
                  ]),
              ]),
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.items, required this.selected, required this.onTap, this.compact = false});
  final DateTime day;
  final List<_CalItem> items;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateUtilsX.isToday(day);
    final past = DateUtilsX.isPastDay(day);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? 4 : 6),
        decoration: BoxDecoration(
          color: selected ? BzColors.primary.withValues(alpha: 0.07) : (past ? theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.4) : Colors.transparent),
          border: Border(right: BorderSide(color: theme.colorScheme.outlineVariant), bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
        ),
        child: Column(
          crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: compact ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: today ? BzColors.primary : (selected ? BzColors.primary.withValues(alpha: 0.18) : Colors.transparent), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('${day.day}', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: today ? Colors.white : (past ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface))),
              ),
              if (!compact) const Spacer(),
              if (!compact && items.length > 3) Text('+${items.length - 3}', style: theme.textTheme.labelSmall),
            ]),
            const SizedBox(height: 4),
            if (compact)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final it in items.take(4))
                    Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1.5), decoration: BoxDecoration(color: it.color.withValues(alpha: it.done ? 0.35 : 1), shape: BoxShape.circle)),
                ],
              )
            else
              for (final it in items.take(3))
                Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: it.color.withValues(alpha: it.done ? 0.10 : 0.18), borderRadius: BorderRadius.circular(4), border: Border(left: BorderSide(color: it.color, width: 3))),
                  child: Row(children: [
                    if (!it.allDay) Text(Fmt.time(it.at).replaceAll(' ', ''), style: theme.textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w700)),
                    if (!it.allDay) const SizedBox(width: 4),
                    Expanded(child: Text(it.title, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.5, decoration: it.done ? TextDecoration.lineThrough : null), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                ),
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item, required this.index});
  final _CalItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fu = item.followUp;
    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      onTap: item.route != null ? () => context.go(item.route!) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(BzTheme.radius)), alignment: Alignment.center, child: Icon(item.icon, size: 14, color: item.color)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, decoration: item.done ? TextDecoration.lineThrough : null)),
                Text(item.subtitle.isEmpty ? (item.allDay ? 'All day' : Fmt.time(item.at)) : item.subtitle, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
              ]),
            ),
            if (fu != null && fu.calendarEventId != null) const Tooltip(message: 'In Google Calendar', child: Icon(BootstrapIcons.google, size: 11, color: BzColors.success)),
          ]),
          if (fu != null && fu.status == FollowUpStatus.pending)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 42),
              child: Row(children: [
                if (fu.meetLink.isNotEmpty) BzButton(label: 'Join Meet', icon: BootstrapIcons.camera_video, size: BzSize.sm, variant: BzVariant.primary, soft: true, onPressed: () => launchUrl(Uri.parse(fu.meetLink))),
                if (fu.meetLink.isNotEmpty) const SizedBox(width: 6),
                FollowUpQuickActions(fu: fu),
              ]),
            ),
          if (fu != null && fu.status != FollowUpStatus.pending) Padding(padding: const EdgeInsets.only(top: 4, left: 42), child: FollowUpStatusBadge(fu.status)),
        ],
      ),
    ).animate(delay: (index * 30).ms).fadeIn(duration: 200.ms);
  }
}
