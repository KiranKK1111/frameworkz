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
import '../../core/email/template_engine.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_card.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_misc.dart';
import '../email/compose_email_dialog.dart';
import 'lead_form_dialog.dart';
import 'status_change_dialog.dart';

enum _View { table, kanban }

class LeadsPage extends ConsumerStatefulWidget {
  const LeadsPage({super.key});
  @override
  ConsumerState<LeadsPage> createState() => _LeadsPageState();
}

class _LeadsPageState extends ConsumerState<LeadsPage> {
  _View _view = _View.table;
  String _query = '';
  LeadStatus? _status;
  bool _openOnly = true;
  LeadSource? _source;
  ServiceType? _service;
  bool _handledQuery = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_handledQuery) return;
    _handledQuery = true;
    final uri = GoRouterState.of(context).uri;
    if (uri.queryParameters['new'] == '1') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showLeadFormDialog(context, ref);
      });
    }
  }

  List<Lead> _filter(List<Lead> all) {
    final q = _query.trim().toLowerCase();
    return all.where((l) {
      if (_status != null && l.status != _status) return false;
      if (_status == null && _openOnly && !l.status.isOpen) return false;
      if (_source != null && l.source != _source) return false;
      if (_service != null && l.service != _service) return false;
      if (q.isNotEmpty && !(l.business.toLowerCase().contains(q) || l.contactPerson.toLowerCase().contains(q) || l.email.toLowerCase().contains(q) || l.phone.contains(q) || l.id.toLowerCase().contains(q))) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        // overdue first, then by next follow-up, then newest
        final an = a.nextFollowUp, bn = b.nextFollowUp;
        if (an != null && bn != null) return an.compareTo(bn);
        if (an != null) return -1;
        if (bn != null) return 1;
        return b.dateAdded.compareTo(a.dateAdded);
      });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leadsAsync = ref.watch(leadsProvider);
    final all = leadsAsync.value ?? const <Lead>[];
    final filtered = _filter(all);
    final counts = {for (final s in LeadStatus.values) s: all.where((l) => l.status == s).length};
    final openCount = all.where((l) => l.status.isOpen).length;

    return BzPage(
      scroll: _view == _View.table,
      maxWidth: 1600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: _view == _View.table ? MainAxisSize.min : MainAxisSize.max,
        children: [
          BzPageHeader(
            title: 'Leads',
            subtitle: '$openCount open · ${all.length} total · pipeline ${Fmt.moneyCompact(all.where((l) => l.status.isOpen).fold<double>(0, (s, l) => s + l.potentialValue))}',
            icon: BootstrapIcons.funnel,
            actions: [
              BzSegmented<_View>(value: _view, options: const [(_View.table, 'Table', BootstrapIcons.table), (_View.kanban, 'Pipeline', BootstrapIcons.kanban)], onChanged: (v) => setState(() => _view = v)),
              BzButton(label: 'New lead', icon: BootstrapIcons.person_plus, onPressed: () => showLeadFormDialog(context, ref)),
            ],
          ),
          // Filters
          if (context.isPhone) ...[
            BzSearchField(onChanged: (v) => setState(() => _query = v), hint: 'Search leads…', width: double.infinity),
            const SizedBox(height: 10),
          ],
          BzHScrollOrWrap(
            scroll: context.isPhone,
            children: [
              if (!context.isPhone) BzSearchField(onChanged: (v) => setState(() => _query = v), hint: 'Search business, contact, email, phone…'),
              _FilterChip(label: 'Open ($openCount)', selected: _status == null && _openOnly, onTap: () => setState(() {
                    _status = null;
                    _openOnly = true;
                  })),
              _FilterChip(label: 'All (${all.length})', selected: _status == null && !_openOnly, onTap: () => setState(() {
                    _status = null;
                    _openOnly = false;
                  })),
              for (final s in LeadStatus.values)
                if ((counts[s] ?? 0) > 0)
                  _FilterChip(label: '${s.label} (${counts[s]})', selected: _status == s, color: StatusStyle.lead(s).color, onTap: () => setState(() => _status = _status == s ? null : s)),
              SizedBox(
                width: 170,
                child: BzDropdown<LeadSource?>(value: _source, items: [null, ...LeadSource.values], labelOf: (s) => s?.label ?? 'All sources', iconOf: (s) => s == null ? BootstrapIcons.funnel : StatusStyle.source(s), onChanged: (v) => setState(() => _source = v)),
              ),
              SizedBox(
                width: 190,
                child: BzDropdown<ServiceType?>(value: _service, items: [null, ...ServiceType.values], labelOf: (s) => s?.label ?? 'All services', iconOf: (s) => s == null ? BootstrapIcons.tag : StatusStyle.service(s), onChanged: (v) => setState(() => _service = v)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (leadsAsync.isLoading)
            const SizedBox(height: 300, child: BzLoading())
          else if (all.isEmpty)
            BzEmptyState(
              icon: BootstrapIcons.funnel,
              title: 'No leads yet',
              message: 'Add your first lead, or import your existing Google Sheet from Settings → Google Sheets.',
              actionLabel: 'New lead',
              onAction: () => showLeadFormDialog(context, ref),
            )
          else if (filtered.isEmpty)
            BzEmptyState(icon: BootstrapIcons.search, title: 'Nothing matches', message: 'Try a different search or clear the filters.', compact: true)
          else if (_view == _View.table)
            _LeadsTable(leads: filtered)
          else
            Expanded(child: _Kanban(leads: filtered, theme: theme)),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap, this.color});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? BzColors.primary;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? c : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: selected ? c : theme.colorScheme.outline),
          ),
          child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: selected ? (c.computeLuminance() > 0.5 ? BzColors.gray900 : Colors.white) : theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------- table
class _LeadsTable extends ConsumerWidget {
  const _LeadsTable({required this.leads});
  final List<Lead> leads;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (context.isCompact) {
      return Column(children: [for (var i = 0; i < leads.length; i++) _LeadCard(lead: leads[i], index: i)]);
    }
    return BzCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: theme.colorScheme.surfaceContainerHigh,
            child: Row(
              children: [
                _h(theme, 'Business / contact', flex: 4),
                _h(theme, 'Source · Service', flex: 3),
                _h(theme, 'Value', flex: 2),
                _h(theme, 'Status', flex: 2),
                _h(theme, 'Last contact', flex: 2),
                _h(theme, 'Next follow-up', flex: 2),
                const SizedBox(width: 150),
              ],
            ),
          ),
          for (var i = 0; i < leads.length; i++) ...[
            _LeadRow(lead: leads[i], index: i),
            if (i < leads.length - 1) const Divider(),
          ],
        ],
      ),
    );
  }

  Widget _h(ThemeData theme, String text, {int flex = 1}) => Expanded(
        flex: flex,
        child: Text(text.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.7, color: theme.colorScheme.onSurfaceVariant)),
      );
}

class _LeadRow extends ConsumerWidget {
  const _LeadRow({required this.lead, required this.index});
  final Lead lead;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      onTap: () => context.go(Routes.lead(lead.id)),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                BzAvatar(lead.business, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.business, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                      Text([if (lead.contactPerson.isNotEmpty) lead.contactPerson, lead.id].join(' · '), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Wrap(spacing: 6, runSpacing: 4, children: [
              BzMetaChip(icon: StatusStyle.source(lead.source), text: lead.source.label),
              BzMetaChip(icon: StatusStyle.service(lead.service), text: lead.service.label),
            ]),
          ),
          Expanded(flex: 2, child: Text(lead.potentialValue > 0 ? Fmt.money(lead.potentialValue) : '—', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: _StatusMenu(lead: lead))),
          Expanded(flex: 2, child: Text(lead.lastContact == null ? '—' : Fmt.relativeDay(lead.lastContact), style: theme.textTheme.bodySmall)),
          Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: lead.status.isOpen ? DueBadge(lead.nextFollowUp) : const SizedBox.shrink())),
          SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (lead.phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp ${lead.phone}', variant: BzVariant.success, onPressed: () => openWhatsApp(lead.phone)),
                if (lead.email.isNotEmpty)
                  BzIconButton(
                    icon: BootstrapIcons.envelope,
                    tooltip: 'Email ${lead.email}',
                    onPressed: () => showComposeEmailDialog(context, to: lead.email, vars: TemplateEngine.leadVars(lead, ref.read(settingsSnapshotProvider)), entityType: EntityType.lead, entityId: lead.id),
                  ),
                BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showLeadFormDialog(context, ref, existing: lead)),
                BzIconButton(icon: BootstrapIcons.chevron_right, tooltip: 'Open', onPressed: () => context.go(Routes.lead(lead.id))),
              ],
            ),
          ),
        ],
      ),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}

/// Card layout used on phones and tablets instead of the table row.
class _LeadCard extends ConsumerWidget {
  const _LeadCard({required this.lead, required this.index});
  final Lead lead;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BzCard(
        onTap: () => context.go(Routes.lead(lead.id)),
        hoverLift: true,
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              BzAvatar(lead.business, size: 42),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(lead.business, style: theme.textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text([if (lead.contactPerson.isNotEmpty) lead.contactPerson, lead.service.label].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                ]),
              ),
              if (lead.potentialValue > 0) Text(Fmt.moneyCompact(lead.potentialValue), style: theme.textTheme.titleSmall),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              _StatusMenu(lead: lead),
              const SizedBox(width: 8),
              if (lead.status.isOpen) DueBadge(lead.nextFollowUp),
              const Spacer(),
              if (lead.phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(lead.phone)),
              if (lead.email.isNotEmpty)
                BzIconButton(
                  icon: BootstrapIcons.envelope,
                  tooltip: 'Email',
                  onPressed: () => showComposeEmailDialog(context, to: lead.email, vars: TemplateEngine.leadVars(lead, ref.read(settingsSnapshotProvider)), entityType: EntityType.lead, entityId: lead.id),
                ),
              Icon(BootstrapIcons.chevron_right, size: 13, color: theme.colorScheme.onSurfaceVariant),
            ]),
          ],
        ),
      ),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}

/// Status badge that opens a menu to move the lead.
class _StatusMenu extends StatelessWidget {
  const _StatusMenu({required this.lead});
  final Lead lead;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: const Offset(0, 4),
      builder: (context, controller, _) => Tooltip(
        message: 'Change status',
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            LeadStatusBadge(lead.status),
            const SizedBox(width: 3),
            Icon(BootstrapIcons.chevron_down, size: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ]),
        ),
      ),
      menuChildren: [
        for (final s in LeadStatus.values)
          MenuItemButton(
            onPressed: s == lead.status ? null : () => showStatusChangeDialog(context, lead, s),
            leadingIcon: Icon(StatusStyle.leadIcon(s), size: 14, color: StatusStyle.lead(s).color),
            child: SizedBox(width: 160, child: Text(s.label, style: TextStyle(fontWeight: s == lead.status ? FontWeight.w700 : FontWeight.w500))),
          ),
      ],
    );
  }
}

Future<void> openWhatsApp(String phone) async {
  var digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length == 10) digits = '91$digits';
  await launchUrl(Uri.parse('https://wa.me/$digits'), mode: LaunchMode.externalApplication);
}

Future<void> openInstagram(String handle) async {
  final h = handle.replaceAll('@', '').trim();
  if (h.isEmpty) return;
  await launchUrl(Uri.parse('https://instagram.com/$h'), mode: LaunchMode.externalApplication);
}

// ------------------------------------------------------------------- kanban
class _Kanban extends ConsumerWidget {
  const _Kanban({required this.leads, required this.theme});
  final List<Lead> leads;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final columns = LeadStatus.values;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: true),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in columns) _KanbanColumn(status: s, leads: leads.where((l) => l.status == s).toList()),
          ],
        ),
      ),
    );
  }
}

class _KanbanColumn extends ConsumerWidget {
  const _KanbanColumn({required this.status, required this.leads});
  final LeadStatus status;
  final List<Lead> leads;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final v = StatusStyle.lead(status);
    final total = leads.fold<double>(0, (s, l) => s + l.potentialValue);
    return DragTarget<Lead>(
      onWillAcceptWithDetails: (d) => d.data.status != status,
      onAcceptWithDetails: (d) => showStatusChangeDialog(context, d.data, status),
      builder: (context, candidate, rejected) {
        final hot = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: context.isPhone ? MediaQuery.sizeOf(context).width - 72 : 262,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: hot ? v.color.withValues(alpha: 0.08) : theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(BzTheme.radiusLg),
            border: Border.all(color: hot ? v.color : theme.colorScheme.outline, width: hot ? 1.5 : 1),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: v.color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(status.label, style: theme.textTheme.titleSmall)),
                    BzBadge('${leads.length}', variant: v),
                  ],
                ),
              ),
              if (total > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 8),
                  child: Align(alignment: Alignment.centerLeft, child: Text(Fmt.moneyCompact(total), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                ),
              Expanded(
                child: leads.isEmpty
                    ? Center(child: Text(hot ? 'Drop to move here' : 'Drag leads here', style: theme.textTheme.bodySmall))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        itemCount: leads.length,
                        itemBuilder: (context, i) => _KanbanCard(lead: leads[i], index: i),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard({required this.lead, required this.index});
  final Lead lead;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final card = Container(
      width: context.isPhone ? MediaQuery.sizeOf(context).width - 90 : 244,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: BzShadows.sm(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            BzAvatar(lead.business, size: 28),
            const SizedBox(width: 8),
            Expanded(child: Text(lead.business, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ]),
          if (lead.contactPerson.isNotEmpty) ...[const SizedBox(height: 6), Text(lead.contactPerson, style: theme.textTheme.bodySmall)],
          const SizedBox(height: 8),
          Row(children: [
            Icon(StatusStyle.service(lead.service), size: 12, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 5),
            Expanded(child: Text(lead.service.label, style: theme.textTheme.labelSmall, overflow: TextOverflow.ellipsis)),
            if (lead.potentialValue > 0) Text(Fmt.moneyCompact(lead.potentialValue), style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
          ]),
          if (lead.status.isOpen) ...[const SizedBox(height: 8), DueBadge(lead.nextFollowUp)],
        ],
      ),
    );
    return Draggable<Lead>(
      data: lead,
      feedback: Material(color: Colors.transparent, child: Transform.rotate(angle: 0.02, child: Opacity(opacity: 0.95, child: card))),
      childWhenDragging: Opacity(opacity: 0.35, child: card),
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: GestureDetector(onTap: () => context.go(Routes.lead(lead.id)), child: card),
      ),
    ).animate(delay: (index.clamp(0, 10) * 30).ms).fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0);
  }
}
