import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

Future<Invoice?> showInvoiceFormDialog(BuildContext context, WidgetRef ref, {Invoice? existing, Client? client, Project? project}) {
  return showBzModal<Invoice>(
    context: context,
    title: existing == null ? 'New invoice' : 'Edit invoice',
    subtitle: existing?.id ?? client?.name ?? 'Bill a client for a project or retainer',
    icon: BootstrapIcons.receipt,
    width: 620,
    child: _InvoiceForm(existing: existing, client: client, project: project),
  );
}

class _InvoiceForm extends ConsumerStatefulWidget {
  const _InvoiceForm({this.existing, this.client, this.project});
  final Invoice? existing;
  final Client? client;
  final Project? project;
  @override
  ConsumerState<_InvoiceForm> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends ConsumerState<_InvoiceForm> {
  late final _amount = TextEditingController(text: widget.existing != null ? widget.existing!.amount.toStringAsFixed(0) : (widget.project != null && widget.project!.value > 0 ? widget.project!.value.toStringAsFixed(0) : ''));
  late final _received = TextEditingController(text: (widget.existing?.amountReceived ?? 0) > 0 ? widget.existing!.amountReceived.toStringAsFixed(0) : '');
  late final _desc = TextEditingController(text: widget.existing?.description ?? widget.project?.name ?? '');
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  String? _clientId;
  String? _projectId;
  late DateTime _date = widget.existing?.invoiceDate ?? DateTime.now();
  late DateTime _due = widget.existing?.dueDate ?? DateTime.now().add(const Duration(days: 7));
  late InvoiceStatus _status = widget.existing?.status ?? InvoiceStatus.sent;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _clientId = widget.existing?.clientId ?? widget.client?.id ?? widget.project?.clientId;
    _projectId = widget.existing?.projectId ?? widget.project?.id;
  }

  @override
  void dispose() {
    for (final c in [_amount, _received, _desc, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amount.text) ?? 0;
    if (_clientId == null) {
      BzToasts.warning('Choose a client');
      return;
    }
    if (amount <= 0) {
      BzToasts.warning('Enter an amount');
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(invoicesRepoProvider);
      final received = double.tryParse(_received.text) ?? 0;
      var status = _status;
      if (received >= amount) {
        status = InvoiceStatus.paid;
      } else if (received > 0 && status != InvoiceStatus.cancelled) {
        status = InvoiceStatus.partiallyPaid;
      }
      Invoice inv;
      if (widget.existing == null) {
        inv = await repo.create(
          clientId: _clientId!,
          projectId: _projectId,
          invoiceDate: _date,
          amount: amount,
          amountReceived: received,
          dueDate: _due,
          status: status,
          description: _desc.text.trim(),
          notes: _notes.text.trim(),
          paymentDate: status == InvoiceStatus.paid ? DateTime.now() : null,
        );
      } else {
        inv = widget.existing!.copyWith(
          clientId: _clientId!,
          projectId: drift.Value(_projectId),
          invoiceDate: _date,
          amount: amount,
          amountReceived: received,
          dueDate: _due,
          status: status,
          description: _desc.text.trim(),
          notes: _notes.text.trim(),
        );
        await repo.save(inv);
      }
      BzToasts.success(widget.existing == null ? 'Invoice ${inv.id} created' : 'Invoice updated', message: Fmt.money(inv.amount));
      if (mounted) Navigator.of(context).pop(inv);
    } catch (e) {
      BzToasts.error('Could not save invoice', message: e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider).value ?? const [];
    final projects = (ref.watch(projectsProvider).value ?? const []).where((p) => p.clientId == _clientId).toList();
    final selectedClient = clients.where((c) => c.id == _clientId).firstOrNull;
    final selectedProject = projects.where((p) => p.id == _projectId).firstOrNull;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BzRow([
          BzField(
            label: 'Client',
            required: true,
            child: BzDropdown<Client?>(value: selectedClient, items: clients, labelOf: (c) => c?.name ?? '', hint: 'Select client', onChanged: (c) => setState(() {
                  _clientId = c?.id;
                  _projectId = null;
                })),
          ),
          BzField(
            label: 'Project (optional)',
            child: BzDropdown<Project?>(value: selectedProject, items: [null, ...projects], labelOf: (p) => p?.name ?? '—', onChanged: (p) => setState(() => _projectId = p?.id)),
          ),
        ]),
        const SizedBox(height: 14),
        BzField(label: 'Description', child: BzTextField(controller: _desc, hint: 'October retainer · 4 reels + 10 photos')),
        const SizedBox(height: 14),
        BzRow([
          BzField(label: 'Amount', required: true, child: BzMoneyField(controller: _amount)),
          BzField(label: 'Received so far', child: BzMoneyField(controller: _received)),
          BzField(label: 'Status', child: BzDropdown<InvoiceStatus>(value: _status, items: InvoiceStatus.values, labelOf: (s) => s.label, onChanged: (v) => setState(() => _status = v ?? _status))),
        ]),
        const SizedBox(height: 14),
        BzRow([
          BzField(label: 'Invoice date', child: BzDateField(value: _date, clearable: false, onChanged: (d) => setState(() => _date = d ?? _date))),
          BzField(label: 'Due date', required: true, child: BzDateField(value: _due, clearable: false, onChanged: (d) => setState(() => _due = d ?? _due))),
        ]),
        const SizedBox(height: 8),
        Wrap(spacing: 6, children: [
          for (final (label, days) in const [('Due on receipt', 0), ('Net 7', 7), ('Net 15', 15), ('Net 30', 30)])
            ChoiceChip(label: Text(label, style: const TextStyle(fontSize: 12)), selected: DateUtilsX.isSameDay(_due, _date.add(Duration(days: days))), onSelected: (_) => setState(() => _due = _date.add(Duration(days: days)))),
        ]),
        const SizedBox(height: 14),
        BzField(label: 'Notes', child: BzTextField(controller: _notes, minLines: 2, maxLines: 3, hint: 'Bank details, GST, payment link…')),
        const SizedBox(height: 20),
        BzActionRow([
          BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
          BzButton(label: widget.existing == null ? 'Create invoice' : 'Save changes', icon: BootstrapIcons.check2, loading: _saving, onPressed: _saving ? null : _save),
        ]),
      ],
    );
  }
}

/// Record a (partial) payment against an invoice.
Future<void> showRecordPaymentDialog(BuildContext context, Invoice inv) async {
  final container = ProviderScope.containerOf(context);
  final controller = TextEditingController(text: (inv.amount - inv.amountReceived).toStringAsFixed(0));
  DateTime when = DateTime.now();
  final res = await showBzModal<double>(
    context: context,
    title: 'Record payment',
    subtitle: '${inv.id} · balance ${Fmt.money(inv.amount - inv.amountReceived)}',
    icon: BootstrapIcons.cash_coin,
    variant: BzVariant.success,
    width: 460,
    child: StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzField(label: 'Amount received', required: true, child: BzMoneyField(controller: controller)),
          const SizedBox(height: 14),
          BzField(label: 'Payment date', child: BzDateField(value: when, clearable: false, onChanged: (d) => setState(() => when = d ?? when))),
          const SizedBox(height: 20),
          BzActionRow([
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            BzButton(label: 'Record payment', icon: BootstrapIcons.check2, variant: BzVariant.success, onPressed: () => Navigator.of(context).pop(double.tryParse(controller.text) ?? 0)),
          ]),
        ],
      ),
    ),
  );
  if (res == null || res <= 0) return;
  final updated = await container.read(invoicesRepoProvider).recordPayment(inv, res, when);
  BzToasts.success(updated.status == InvoiceStatus.paid ? 'Invoice ${inv.id} fully paid 🎉' : 'Payment recorded', message: '${Fmt.money(res)} received · balance ${Fmt.money(updated.amount - updated.amountReceived)}');
}
