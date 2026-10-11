import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../email/compose_email_dialog.dart';
import '../leads/leads_page.dart';
import 'client_form_dialog.dart';

class ClientsPage extends ConsumerStatefulWidget {
  const ClientsPage({super.key});
  @override
  ConsumerState<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends ConsumerState<ClientsPage> {
  String _q = '';
  ClientStatus? _status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(clientsProvider);
    final all = async.value ?? const <Client>[];
    final invoices = ref.watch(invoicesProvider).value ?? const <Invoice>[];
    final projects = ref.watch(projectsProvider).value ?? const <Project>[];
    final q = _q.trim().toLowerCase();
    final list = all.where((c) => (_status == null || c.status == _status) && (q.isEmpty || c.name.toLowerCase().contains(q) || c.contactPerson.toLowerCase().contains(q) || c.email.toLowerCase().contains(q) || c.id.toLowerCase().contains(q))).toList();
    final active = all.where((c) => c.status == ClientStatus.active || c.status == ClientStatus.onboarding).toList();
    final mrr = active.fold<double>(0, (s, c) => s + c.monthlyValue);
    final outstanding = invoices.where((i) => i.status.isOutstanding).fold<double>(0, (s, i) => s + i.amount - i.amountReceived);

    return BzPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzPageHeader(
            title: 'Clients',
            subtitle: '${active.length} active · ${all.length} total',
            icon: BootstrapIcons.people,
            actions: [BzButton(label: 'New client', icon: BootstrapIcons.person_plus, onPressed: () => showClientFormDialog(context, ref))],
          ),
          BzResponsiveGrid(minItemWidth: 150, maxColumns: 4, gap: context.isPhone ? 10 : 14, itemHeight: context.isPhone ? 96 : 116, children: [
            BzStatTile(label: 'Active clients', value: '${active.length}', numericValue: active.length, icon: BootstrapIcons.people_fill, variant: BzVariant.success),
            BzStatTile(label: 'Monthly recurring', value: Fmt.moneyCompact(mrr), numericValue: mrr, formatter: Fmt.moneyCompact, icon: BootstrapIcons.arrow_repeat, variant: BzVariant.primary, hint: 'Sum of active retainers', delay: 60.ms),
            BzStatTile(label: 'Open projects', value: '${projects.where((p) => p.status.isOpen).length}', numericValue: projects.where((p) => p.status.isOpen).length, icon: BootstrapIcons.camera_reels, variant: BzVariant.info, delay: 120.ms, onTap: () => context.go(Routes.projects)),
            BzStatTile(label: 'Outstanding', value: Fmt.moneyCompact(outstanding), numericValue: outstanding, formatter: Fmt.moneyCompact, icon: BootstrapIcons.receipt, variant: outstanding > 0 ? BzVariant.warning : BzVariant.secondary, delay: 180.ms, onTap: () => context.go(Routes.finance)),
          ]),
          const SizedBox(height: 18),
          if (context.isPhone) ...[
            BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search clients…', width: double.infinity),
            const SizedBox(height: 10),
          ],
          BzHScrollOrWrap(scroll: context.isPhone, children: [
            if (!context.isPhone) BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search clients…'),
            ChoiceChip(label: Text('All (${all.length})'), selected: _status == null, onSelected: (_) => setState(() => _status = null)),
            for (final s in ClientStatus.values)
              if (all.any((c) => c.status == s)) ChoiceChip(label: Text('${s.label} (${all.where((c) => c.status == s).length})'), selected: _status == s, onSelected: (_) => setState(() => _status = _status == s ? null : s)),
          ]),
          const SizedBox(height: 18),
          if (async.isLoading)
            const SizedBox(height: 240, child: BzLoading())
          else if (all.isEmpty)
            BzEmptyState(icon: BootstrapIcons.people, title: 'No clients yet', message: 'Clients are created automatically when a lead is marked Won, or add one directly.', actionLabel: 'New client', onAction: () => showClientFormDialog(context, ref))
          else if (list.isEmpty)
            const BzEmptyState(icon: BootstrapIcons.search, title: 'Nothing matches', message: 'Try a different search or filter.', compact: true)
          else if (context.isCompact)
            Column(children: [for (var i = 0; i < list.length; i++) _ClientCard(client: list[i], index: i, invoices: invoices.where((inv) => inv.clientId == list[i].id).toList())])
          else
            BzCard(
              padding: EdgeInsets.zero,
              clip: true,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: Row(children: [
                    _h(theme, 'Client', 4),
                    _h(theme, 'Service', 2),
                    _h(theme, 'Monthly', 2),
                    _h(theme, 'Project value', 2),
                    _h(theme, 'Since', 2),
                    _h(theme, 'Status', 2),
                    const SizedBox(width: 150),
                  ]),
                ),
                for (var i = 0; i < list.length; i++) ...[
                  _Row(client: list[i], index: i, invoices: invoices.where((inv) => inv.clientId == list[i].id).toList()),
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

class _ClientCard extends ConsumerWidget {
  const _ClientCard({required this.client, required this.index, required this.invoices});
  final Client client;
  final int index;
  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final due = invoices.where((i) => i.status.isOutstanding).fold<double>(0, (s, i) => s + i.amount - i.amountReceived);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: BzCard(
        onTap: () => context.go(Routes.client(client.id)),
        hoverLift: true,
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            BzAvatar(client.name, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(client.name, style: theme.textTheme.titleSmall?.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text([if (client.contactPerson.isNotEmpty) client.contactPerson, client.service.label].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            if (client.monthlyValue > 0) Text('${Fmt.moneyCompact(client.monthlyValue)}/mo', style: theme.textTheme.titleSmall),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            ClientStatusBadge(client.status),
            if (due > 0) ...[const SizedBox(width: 6), BzBadge('${Fmt.moneyCompact(due)} due', variant: BzVariant.danger, icon: BootstrapIcons.receipt)],
            const Spacer(),
            if (client.phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(client.phone)),
            if (client.email.isNotEmpty) BzIconButton(icon: BootstrapIcons.envelope, tooltip: 'Email', onPressed: () => showComposeEmailDialog(context, to: client.email, vars: TemplateEngine.clientVars(client, ref.read(settingsSnapshotProvider)), entityType: EntityType.client, entityId: client.id, category: 'client')),
            Icon(BootstrapIcons.chevron_right, size: 13, color: theme.colorScheme.onSurfaceVariant),
          ]),
        ]),
      ),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}

class _Row extends ConsumerWidget {
  const _Row({required this.client, required this.index, required this.invoices});
  final Client client;
  final int index;
  final List<Invoice> invoices;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final due = invoices.where((i) => i.status.isOutstanding).fold<double>(0, (s, i) => s + i.amount - i.amountReceived);
    return BzHoverRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      onTap: () => context.go(Routes.client(client.id)),
      child: Row(children: [
        Expanded(
          flex: 4,
          child: Row(children: [
            BzAvatar(client.name, size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(client.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text([if (client.contactPerson.isNotEmpty) client.contactPerson, client.id, if (due > 0) '${Fmt.moneyCompact(due)} due'].join(' · '), style: theme.textTheme.bodySmall?.copyWith(color: due > 0 ? BzColors.danger : null), overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: BzMetaChip(icon: StatusStyle.service(client.service), text: client.service.label))),
        Expanded(flex: 2, child: Text(client.monthlyValue > 0 ? Fmt.money(client.monthlyValue) : '—', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Text(client.projectValue > 0 ? Fmt.money(client.projectValue) : '—', style: theme.textTheme.bodyMedium)),
        Expanded(flex: 2, child: Text(Fmt.date(client.startDate), style: theme.textTheme.bodySmall)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: ClientStatusBadge(client.status))),
        SizedBox(
          width: 150,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (client.phone.isNotEmpty) BzIconButton(icon: BootstrapIcons.whatsapp, tooltip: 'WhatsApp', variant: BzVariant.success, onPressed: () => openWhatsApp(client.phone)),
            if (client.email.isNotEmpty) BzIconButton(icon: BootstrapIcons.envelope, tooltip: 'Email', onPressed: () => showComposeEmailDialog(context, to: client.email, vars: TemplateEngine.clientVars(client, ref.read(settingsSnapshotProvider)), entityType: EntityType.client, entityId: client.id, category: 'client')),
            BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showClientFormDialog(context, ref, existing: client)),
            BzIconButton(icon: BootstrapIcons.chevron_right, tooltip: 'Open', onPressed: () => context.go(Routes.client(client.id))),
          ]),
        ),
      ]),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}
