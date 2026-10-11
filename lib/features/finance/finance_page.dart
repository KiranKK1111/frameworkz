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
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';
import '../email/compose_email_dialog.dart';
import 'invoice_form_dialog.dart';

class FinancePage extends ConsumerStatefulWidget {
  const FinancePage({super.key});
  @override
  ConsumerState<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends ConsumerState<FinancePage> {
  String _q = '';
  InvoiceStatus? _status;
  bool _outstandingOnly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final async = ref.watch(invoicesProvider);
    final all = async.value ?? const <Invoice>[];
    final clients = ref.watch(clientsByIdProvider);
    final q = _q.trim().toLowerCase();
    final list = all.where((i) {
      if (_status != null && i.status != _status) return false;
      if (_status == null && _outstandingOnly && !i.status.isOutstanding) return false;
      if (q.isNotEmpty && !(i.id.toLowerCase().contains(q) || i.description.toLowerCase().contains(q) || (clients[i.clientId]?.name.toLowerCase().contains(q) ?? false))) return false;
      return true;
    }).toList();
    final now = DateTime.now();
    final monthStart = DateUtilsX.startOfMonth(now);
    final outstanding = all.where((i) => i.status.isOutstanding).fold<double>(0, (s, i) => s + i.amount - i.amountReceived);
    final overdue = all.where((i) => i.status == InvoiceStatus.overdue).toList();
    final overdueAmt = overdue.fold<double>(0, (s, i) => s + i.amount - i.amountReceived);
    final collected = all.where((i) => i.paymentDate != null && i.paymentDate!.isAfter(monthStart)).fold<double>(0, (s, i) => s + i.amountReceived);
    final invoiced = all.where((i) => i.invoiceDate.isAfter(monthStart) && i.status != InvoiceStatus.cancelled).fold<double>(0, (s, i) => s + i.amount);

    return BzPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzPageHeader(
            title: 'Finance',
            subtitle: 'Invoices, payments and reminders. Overdue invoices are flagged automatically.',
            icon: BootstrapIcons.wallet2,
            actions: [BzButton(label: 'New invoice', icon: BootstrapIcons.plus_lg, onPressed: () => showInvoiceFormDialog(context, ref))],
          ),
          BzResponsiveGrid(minItemWidth: 150, maxColumns: 4, gap: context.isPhone ? 10 : 14, itemHeight: context.isPhone ? 96 : 116, children: [
            BzStatTile(label: 'Outstanding', value: Fmt.moneyCompact(outstanding), numericValue: outstanding, formatter: Fmt.moneyCompact, icon: BootstrapIcons.hourglass_split, variant: BzVariant.warning, hint: '${all.where((i) => i.status.isOutstanding).length} invoices', onTap: () => setState(() {
                  _status = null;
                  _outstandingOnly = true;
                })),
            BzStatTile(label: 'Overdue', value: Fmt.moneyCompact(overdueAmt), numericValue: overdueAmt, formatter: Fmt.moneyCompact, icon: BootstrapIcons.exclamation_circle, variant: overdue.isEmpty ? BzVariant.secondary : BzVariant.danger, hint: '${overdue.length} invoices', delay: 60.ms, onTap: () => setState(() => _status = InvoiceStatus.overdue)),
            BzStatTile(label: 'Collected this month', value: Fmt.moneyCompact(collected), numericValue: collected, formatter: Fmt.moneyCompact, icon: BootstrapIcons.cash_coin, variant: BzVariant.success, delay: 120.ms),
            BzStatTile(label: 'Invoiced this month', value: Fmt.moneyCompact(invoiced), numericValue: invoiced, formatter: Fmt.moneyCompact, icon: BootstrapIcons.receipt, variant: BzVariant.primary, delay: 180.ms),
          ]),
          const SizedBox(height: 18),
          if (context.isPhone) ...[
            BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search invoices…', width: double.infinity),
            const SizedBox(height: 10),
          ],
          BzHScrollOrWrap(scroll: context.isPhone, children: [
            if (!context.isPhone) BzSearchField(onChanged: (v) => setState(() => _q = v), hint: 'Search invoice, client, description…'),
            ChoiceChip(label: Text('All (${all.length})'), selected: _status == null && !_outstandingOnly, onSelected: (_) => setState(() {
                  _status = null;
                  _outstandingOnly = false;
                })),
            ChoiceChip(label: Text('Outstanding (${all.where((i) => i.status.isOutstanding).length})'), selected: _status == null && _outstandingOnly, onSelected: (_) => setState(() {
                  _status = null;
                  _outstandingOnly = true;
                })),
            for (final s in InvoiceStatus.values)
              if (all.any((i) => i.status == s)) ChoiceChip(label: Text('${s.label} (${all.where((i) => i.status == s).length})'), selected: _status == s, onSelected: (_) => setState(() => _status = _status == s ? null : s)),
          ]),
          const SizedBox(height: 18),
          if (async.isLoading)
            const SizedBox(height: 240, child: BzLoading())
          else if (all.isEmpty)
            BzEmptyState(icon: BootstrapIcons.wallet2, title: 'No invoices yet', message: 'Create an invoice for a client or project. FrameWorkz tracks payments and nudges you when something is overdue.', actionLabel: 'New invoice', onAction: () => showInvoiceFormDialog(context, ref))
          else if (list.isEmpty)
            const BzEmptyState(icon: BootstrapIcons.search, title: 'Nothing matches', message: 'Try a different search or filter.', compact: true)
          else if (context.isCompact)
            BzCard(padding: const EdgeInsets.all(6), child: Column(children: [for (var i = 0; i < list.length; i++) ...[InvoiceRow(invoice: list[i], index: i), if (i < list.length - 1) const Divider()]]))
          else
            BzCard(
              padding: EdgeInsets.zero,
              clip: true,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: theme.colorScheme.surfaceContainerHigh,
                  child: Row(children: [
                    _h(theme, 'Invoice', 4),
                    _h(theme, 'Issued', 2),
                    _h(theme, 'Due', 2),
                    _h(theme, 'Amount', 2),
                    _h(theme, 'Balance', 2),
                    _h(theme, 'Status', 2),
                    const SizedBox(width: 150),
                  ]),
                ),
                for (var i = 0; i < list.length; i++) ...[
                  InvoiceRow(invoice: list[i], index: i),
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

/// Invoice row shared by Finance and client detail.
class InvoiceRow extends ConsumerWidget {
  const InvoiceRow({super.key, required this.invoice, this.index = 0, this.showClient = true});
  final Invoice invoice;
  final int index;
  final bool showClient;

  Future<void> _email(BuildContext context, WidgetRef ref, Client client, String templateId) async {
    final tpl = await ref.read(templatesRepoProvider).byId(templateId);
    if (!context.mounted) return;
    final sent = await showComposeEmailDialog(context, to: client.email, vars: TemplateEngine.clientVars(client, ref.read(settingsSnapshotProvider), invoice: invoice), template: tpl, entityType: EntityType.client, entityId: client.id, category: 'invoice');
    if (sent && invoice.status == InvoiceStatus.draft) {
      await ref.read(invoicesRepoProvider).save(invoice.copyWith(status: InvoiceStatus.sent));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final client = ref.watch(clientsByIdProvider)[invoice.clientId];
    final project = invoice.projectId != null ? ref.watch(projectsByIdProvider)[invoice.projectId!] : null;
    final balance = invoice.amount - invoice.amountReceived;
    final dueVariant = invoice.status.isOutstanding ? DueBadge.variantFor(invoice.dueDate) : BzVariant.secondary;
    if (context.isCompact) {
      return BzHoverRow(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        onTap: showClient && client != null ? () => context.go(Routes.client(client.id)) : null,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: StatusStyle.invoice(invoice.status).subtle(theme.brightness), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Icon(BootstrapIcons.receipt, size: 16, color: StatusStyle.invoice(invoice.status).emphasis(theme.brightness))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text([invoice.id, if (showClient && client != null) client.name].join(' · '), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text([if (invoice.description.isNotEmpty) invoice.description, 'Due ${Fmt.dateShort(invoice.dueDate)}'].join(' · '), style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(Fmt.money(invoice.amount), style: theme.textTheme.titleSmall),
              if (balance > 0 && balance != invoice.amount) Text('${Fmt.money(balance)} due', style: theme.textTheme.labelSmall?.copyWith(color: BzColors.danger)),
            ]),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                InvoiceStatusBadge(invoice.status),
                if (invoice.status.isOutstanding) BzBadge(Fmt.relativeDay(invoice.dueDate), variant: dueVariant, icon: BootstrapIcons.calendar3),
              ]),
            ),
            const SizedBox(width: 6),
            if (invoice.status.isOutstanding || invoice.status == InvoiceStatus.draft) BzIconButton(icon: BootstrapIcons.cash_coin, tooltip: 'Record payment', variant: BzVariant.success, onPressed: () => showRecordPaymentDialog(context, invoice)),
            if (client != null && client.email.isNotEmpty)
              PopupMenuButton<String>(
                tooltip: 'Email client',
                icon: const Icon(BootstrapIcons.envelope, size: 15),
                onSelected: (v) => _email(context, ref, client, v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'tpl_invoice_sent', child: Text('Send invoice details')),
                  PopupMenuItem(value: 'tpl_payment_reminder', child: Text('Send payment reminder')),
                ],
              ),
            BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showInvoiceFormDialog(context, ref, existing: invoice)),
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
            Container(width: 36, height: 36, decoration: BoxDecoration(color: StatusStyle.invoice(invoice.status).subtle(theme.brightness), borderRadius: BorderRadius.circular(10)), alignment: Alignment.center, child: Icon(BootstrapIcons.receipt, size: 16, color: StatusStyle.invoice(invoice.status).emphasis(theme.brightness))),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text([invoice.id, if (showClient && client != null) client.name].join(' · '), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                Text([if (invoice.description.isNotEmpty) invoice.description, if (project != null) project.name].join(' · '), style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
        Expanded(flex: 2, child: Text(Fmt.date(invoice.invoiceDate), style: theme.textTheme.bodySmall)),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: invoice.status.isOutstanding ? BzBadge(Fmt.relativeDay(invoice.dueDate), variant: dueVariant, icon: BootstrapIcons.calendar3) : Text(Fmt.date(invoice.dueDate), style: theme.textTheme.bodySmall))),
        Expanded(flex: 2, child: Text(Fmt.money(invoice.amount), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
        Expanded(flex: 2, child: Text(balance <= 0 ? '—' : Fmt.money(balance), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: balance > 0 && invoice.status == InvoiceStatus.overdue ? BzColors.danger : null))),
        Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: InvoiceStatusBadge(invoice.status))),
        SizedBox(
          width: 150,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (invoice.status.isOutstanding || invoice.status == InvoiceStatus.draft) BzIconButton(icon: BootstrapIcons.cash_coin, tooltip: 'Record payment', variant: BzVariant.success, onPressed: () => showRecordPaymentDialog(context, invoice)),
            if (client != null && client.email.isNotEmpty)
              PopupMenuButton<String>(
                tooltip: 'Email client',
                icon: const Icon(BootstrapIcons.envelope, size: 15),
                onSelected: (v) => _email(context, ref, client, v),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'tpl_invoice_sent', child: Text('Send invoice details')),
                  PopupMenuItem(value: 'tpl_payment_reminder', child: Text('Send payment reminder')),
                ],
              ),
            BzIconButton(icon: BootstrapIcons.pencil, tooltip: 'Edit', onPressed: () => showInvoiceFormDialog(context, ref, existing: invoice)),
            BzIconButton(
              icon: BootstrapIcons.trash3,
              tooltip: 'Delete',
              variant: BzVariant.danger,
              onPressed: () async {
                final ok = await showBzConfirm(context, title: 'Delete invoice?', message: '${invoice.id} will be removed permanently.', confirmLabel: 'Delete');
                if (ok) {
                  await ref.read(invoicesRepoProvider).delete(invoice.id);
                  BzToasts.info('Invoice deleted');
                }
              },
            ),
          ]),
        ),
      ]),
    ).animate(delay: (index.clamp(0, 12) * 25).ms).fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0);
  }
}
