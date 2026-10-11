import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
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
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_misc.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../email/compose_email_dialog.dart';
import '../finance/invoice_form_dialog.dart';
import 'project_form_dialog.dart';

class ProjectsPage extends ConsumerStatefulWidget {
  const ProjectsPage({super.key});
  @override
  ConsumerState<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends ConsumerState<ProjectsPage> {
  String _q = '';
  ProjectStatus? _status;
  bool _openOnly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(projectsProvider);
    final all = async.value ?? const <Project>[];
    final clients = ref.watch(clientsByIdProvider);
    final q = _q.trim().toLowerCase();
    final list = all.where((p) {
      if (_status != null && p.status != _status) return false;
      if (_status == null && _openOnly && !p.status.isOpen) return false;
      if (q.isNotEmpty && !(p.name.toLowerCase().contains(q) || p.id.toLowerCase().contains(q) || (clients[p.clientId]?.name.toLowerCase().contains(q) ?? false))) return false;
      return true;
    }).toList()
      ..sort((a, b) {
        final ad = a.deadline ?? a.shootDate, bd = b.deadline ?? b.shootDate;
        if (ad != null && bd != null) return ad.compareTo(bd);
        if (ad != null) return -1;
        if (bd != null) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    final open = all.where((p) => p.status.isOpen).toList();
    final shootsThisWeek = open.where((p) => p.shootDate != null && p.shootDate!.isAfter(DateTime.now().subtract(const Duration(days: 1))) && p.shootDate!.isBefore(DateTime.now().add(const Duration(days: 7)))).length;
    final inReview = open.where((p) => p.status == ProjectStatus.clientReview || p.status == ProjectStatus.revisions).length;
    final unpaid = open.where((p) => p.paymentStatus != PaymentStatus.paid).fold<double>(0, (s, p) => s + p.value);

    return BzPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzPageHeader(
            title: 'Projects',
            subtitle: '${open.length} open · ${all.length} total',
            icon: BootstrapIcons.camera_reels,
            actions: [BzButton(label: 'New project', icon: BootstrapIcons.plus_lg, onPressed: () => showProjectFormDialog(context, ref))],
          ),
          BzResponsiveGrid(minItemWidth: 150, maxColumns: 4, gap: context.isPhone ? 10 : 14, itemHeight: context.isPhone ? 96 : 116, children: [
            BzStatTile(label: 'Open projects', value: '${open.length}', numericValue: open.length, icon: BootstrapIcons.camera_reels, variant: BzVariant.primary),
            BzStatTile(label: 'Shoots this week', value: '$shootsThisWeek', numericValue: shootsThisWeek, icon: BootstrapIcons.camera_video, variant: BzVariant.info, delay: 60.ms),
            BzStatTile(label: 'In client review', value: '$inReview', numericValue: inReview, icon: BootstrapIcons.eye, variant: BzVariant.warning, delay: 120.ms),
            BzStatTile(label: 'Unpaid value', value: Fmt.moneyCompact(unpaid), numericValue: unpaid, formatter: Fmt.moneyCompact, icon: BootstrapIcons.cash_coin, variant: BzVariant.success, delay: 180.ms),
          ]),
          const SizedBox(height: 18),
          if (context.isPhone) ...[
            BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search projects…', width: double.infinity),
            const SizedBox(height: 10),
          ],
          BzHScrollOrWrap(scroll: context.isPhone, children: [
            if (!context.isPhone) BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search projects or clients…'),
            ChoiceChip(label: Text('Open (${open.length})'), selected: _status == null && _openOnly, onSelected: (_) => setState(() {
                  _status = null;
                  _openOnly = true;
                })),
            ChoiceChip(label: Text('All (${all.length})'), selected: _status == null && !_openOnly, onSelected: (_) => setState(() {
                  _status = null;
                  _openOnly = false;
                })),
            for (final s in ProjectStatus.values)
              if (all.any((p) => p.status == s)) ChoiceChip(label: Text('${s.label} (${all.where((p) => p.status == s).length})'), selected: _status == s, onSelected: (_) => setState(() => _status = _status == s ? null : s)),
          ]),
          const SizedBox(height: 18),
          if (async.isLoading)
            const SizedBox(height: 240, child: BzLoading())
          else if (all.isEmpty)
            BzEmptyState(icon: BootstrapIcons.camera_reels, title: 'No projects yet', message: 'Projects are created when you convert a won lead, or add one for an existing client.', actionLabel: 'New project', onAction: () => showProjectFormDialog(context, ref))
          else if (list.isEmpty)
            const BzEmptyState(icon: BootstrapIcons.search, title: 'Nothing matches', message: 'Try a different search or filter.', compact: true)
          else if (context.isCompact)
            BzCard(padding: const EdgeInsets.all(6), child: Column(children: [for (var i = 0; i < list.length; i++) ...[ProjectRow(project: list[i], index: i), if (i < list.length - 1) const Divider()]]))
          else
            BzCard(
              padding: EdgeInsets.zero,
              clip: true,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: Row(children: [
                    _h(theme, 'Project', 4),
                    _h(theme, 'Shoot', 2),
                    _h(theme, 'Deadline', 2),
                    _h(theme, 'Status', 2),
                    _h(theme, 'Payment', 2),
                    _h(theme, 'Value', 1),
                    const SizedBox(width: 120),
                  ]),
                ),
                for (var i = 0; i < list.length; i++) ...[
                  ProjectRow(project: list[i], index: i),
                  if (i < list.length - 1) const Divider(),
                ],
              ]),
            ),
        ],
      ),
    );
  }

  Widget _h(ThemeData theme, String t, int flex) => Expanded(flex: flex, child: Text(t.toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.7, color: theme.colorScheme.onSurfaceVariant)));
}

/// Row shared by the Projects page and the client detail page.
class ProjectRow extends ConsumerWidget {
  const ProjectRow({super.key, required this.project, this.index = 0, this.showClient = true});
  final Project project;
  final int index;
  final bool showClient;

  Future<void> _setStatus(BuildContext context, WidgetRef ref, ProjectStatus s) async {
    final p = project;
    var updated = p.copyWith(status: s);
    if (s == ProjectStatus.clientReview && p.clientReviewDate == null) updated = updated.copyWith(clientReviewDate: drift.Value(DateTime.now()));
    if (s == ProjectStatus.delivered && p.finalDeliveryDate == null) updated = updated.copyWith(finalDeliveryDate: drift.Value(DateTime.now()));
    await ref.read(projectsRepoProvider).save(updated);
    await ref.read(databaseProvider).logActivity(entityType: EntityType.client, entityId: p.clientId, kind: ActivityKind.project, title: '${p.name}: ${p.status.label} → ${s.label}');
    BzToasts.success('${p.name} → ${s.label}');
    if (s == ProjectStatus.clientReview && context.mounted) {
      final client = ref.read(clientsByIdProvider)[p.clientId];
      final tpl = await ref.read(templatesRepoProvider).byId('tpl_project_review');
      if (client != null && client.email.isNotEmpty && tpl != null && context.mounted) {
        await showComposeEmailDialog(context, to: client.email, vars: TemplateEngine.clientVars(client, ref.read(settingsSnapshotProvider), project: updated), template: tpl, entityType: EntityType.client, entityId: client.id, category: 'project');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final client = ref.watch(clientsByIdProvider)[project.clientId];
    final deadlineVariant = project.deadline == null || !project.status.isOpen ? BzVariant.secondary : DueBadge.variantFor(project.deadline);
    final statusMenu = MenuAnchor(
      builder: (context, controller, _) => InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: Row(mainAxisSize: MainAxisSize.min, children: [ProjectStatusBadge(project.status), const SizedBox(width: 3), Icon(BootstrapIcons.chevron_down, size: 10, color: theme.colorScheme.onSurfaceVariant)]),
      ),
      menuChildren: [
        for (final s in ProjectStatus.values) MenuItemButton(onPressed: s == project.status ? null : () => _setStatus(context, ref, s), child: SizedBox(width: 150, child: Text(s.label))),
      ],
    );
    if (context.isCompact) {
      return BzHoverRow(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        onTap: showClient && client != null ? () => context.go(Routes.client(client.id)) : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: StatusStyle.project(project.status).subtle(theme.brightness), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Icon(StatusStyle.service(project.service), size: 16, color: StatusStyle.project(project.status).emphasis(theme.brightness))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(project.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text([if (showClient && client != null) client.name, if (project.shootDate != null) 'Shoot ${Fmt.dateShort(project.shootDate)}', if (project.deadline != null) 'Due ${Fmt.dateShort(project.deadline)}'].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            if (project.value > 0) Text(Fmt.moneyCompact(project.value), style: theme.textTheme.titleSmall),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            statusMenu,
            const SizedBox(width: 6),
            PaymentStatusBadge(project.paymentStatus),
            const Spacer(),
            BzIconButton(icon: BootstrapIcons.receipt, tooltip: 'Create invoice', onPressed: () => showInvoiceFormDialog(context, ref, client: client, project: project)),
            BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showProjectFormDialog(context, ref, existing: project)),
          ]),
        ]),
      ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
    }
    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      onTap: showClient && client != null ? () => context.go(Routes.client(client.id)) : null,
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: StatusStyle.project(project.status).subtle(theme.brightness), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Icon(StatusStyle.service(project.service), size: 16, color: StatusStyle.project(project.status).emphasis(theme.brightness))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(project.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text([if (showClient && client != null) client.name, project.service.label, project.id].join(' · '), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
        Expanded(flex: 2, child: Text(project.shootDate == null ? '—' : (project.shootDate!.hour != 0 ? Fmt.dateTime(project.shootDate) : Fmt.date(project.shootDate)), style: theme.textTheme.bodySmall)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: project.deadline == null ? Text('—', style: theme.textTheme.bodySmall) : BzBadge(Fmt.relativeDay(project.deadline), variant: deadlineVariant, icon: BootstrapIcons.hourglass_split))),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: statusMenu)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: PaymentStatusBadge(project.paymentStatus))),
        Expanded(flex: 1, child: Text(project.value > 0 ? Fmt.moneyCompact(project.value) : '—', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        SizedBox(
          width: 120,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (project.driveFolder.isNotEmpty) BzIconButton(icon: BootstrapIcons.folder, tooltip: 'Open Drive folder', onPressed: () => launchUrl(Uri.parse(project.driveFolder))),
            BzIconButton(icon: BootstrapIcons.receipt, tooltip: 'Create invoice', onPressed: () => showInvoiceFormDialog(context, ref, client: client, project: project)),
            BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showProjectFormDialog(context, ref, existing: project)),
            BzIconButton(
              icon: BootstrapIcons.trash3,
              tooltip: 'Delete',
              variant: BzVariant.danger,
              onPressed: () async {
                final ok = await showBzConfirm(context, title: 'Delete project?', message: '"${project.name}" will be removed permanently.', confirmLabel: 'Delete');
                if (ok) {
                  await ref.read(projectsRepoProvider).delete(project.id);
                  BzToasts.info('Project deleted');
                }
              },
            ),
          ]),
        ),
      ]),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}
