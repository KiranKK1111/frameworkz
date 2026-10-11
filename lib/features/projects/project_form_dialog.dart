import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

Future<Project?> showProjectFormDialog(BuildContext context, WidgetRef ref, {Project? existing, Client? client}) {
  return showBzModal<Project>(
    context: context,
    title: existing == null ? 'New project' : 'Edit project',
    subtitle: existing?.id ?? client?.name ?? 'Shoot, edit or retainer deliverable',
    icon: BootstrapIcons.camera_reels,
    width: 660,
    child: _ProjectForm(existing: existing, client: client),
  );
}

class _ProjectForm extends ConsumerStatefulWidget {
  const _ProjectForm({this.existing, this.client});
  final Project? existing;
  final Client? client;
  @override
  ConsumerState<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<_ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _deliverables = TextEditingController(text: widget.existing?.deliverables ?? '');
  late final _value = TextEditingController(text: (widget.existing?.value ?? 0) > 0 ? widget.existing!.value.toStringAsFixed(0) : '');
  late final _drive = TextEditingController(text: widget.existing?.driveFolder ?? '');
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  String? _clientId;
  late ServiceType _service = widget.existing?.service ?? widget.client?.service ?? ServiceType.reels;
  late ProjectStatus _status = widget.existing?.status ?? ProjectStatus.planned;
  late PaymentStatus _payment = widget.existing?.paymentStatus ?? PaymentStatus.unpaid;
  late DateTime? _shoot = widget.existing?.shootDate;
  late TimeOfDay? _shootTime = widget.existing?.shootDate != null && (widget.existing!.shootDate!.hour != 0 || widget.existing!.shootDate!.minute != 0) ? TimeOfDay.fromDateTime(widget.existing!.shootDate!) : null;
  late DateTime? _deadline = widget.existing?.deadline;
  bool _calendar = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _clientId = widget.existing?.clientId ?? widget.client?.id;
  }

  @override
  void dispose() {
    for (final c in [_name, _deliverables, _value, _drive, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clientId == null) {
      BzToasts.warning('Choose a client');
      return;
    }
    setState(() => _saving = true);
    try {
      final repo = ref.read(projectsRepoProvider);
      DateTime? shoot = _shoot;
      if (shoot != null && _shootTime != null) shoot = DateTime(shoot.year, shoot.month, shoot.day, _shootTime!.hour, _shootTime!.minute);
      Project p;
      if (widget.existing == null) {
        p = await repo.create(
          clientId: _clientId!,
          name: _name.text,
          service: _service,
          shootDate: shoot,
          deadline: _deadline,
          status: _status,
          deliverables: _deliverables.text.trim(),
          paymentStatus: _payment,
          value: double.tryParse(_value.text) ?? 0,
          driveFolder: _drive.text.trim(),
          notes: _notes.text.trim(),
        );
      } else {
        p = widget.existing!.copyWith(
          clientId: _clientId!,
          name: _name.text.trim(),
          service: _service,
          shootDate: drift.Value(shoot),
          deadline: drift.Value(_deadline),
          status: _status,
          deliverables: _deliverables.text.trim(),
          paymentStatus: _payment,
          value: double.tryParse(_value.text) ?? 0,
          driveFolder: _drive.text.trim(),
          notes: _notes.text.trim(),
        );
        await repo.save(p);
      }
      // Calendar: shoot date + deadline as all-day events (best effort).
      final cal = ref.read(calendarServiceProvider);
      if (_calendar && cal.available && widget.existing == null) {
        final client = await ref.read(clientsRepoProvider).byId(_clientId!);
        if (client != null) {
          try {
            if (p.shootDate != null) await cal.upsertProjectEvent(p, client, deadline: false);
            if (p.deadline != null) await cal.upsertProjectEvent(p, client, deadline: true);
          } catch (e) {
            BzToasts.warning('Calendar not updated', message: e.toString());
          }
        }
      }
      BzToasts.success(widget.existing == null ? 'Project ${p.id} created' : 'Project updated', message: p.name);
      if (mounted) Navigator.of(context).pop(p);
    } catch (e) {
      BzToasts.error('Could not save project', message: e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider).value ?? const [];
    final google = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final selectedClient = clients.where((c) => c.id == _clientId).firstOrNull;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzRow([
            BzField(
              label: 'Client',
              required: true,
              child: BzDropdown<Client?>(
                value: selectedClient,
                items: clients,
                labelOf: (c) => c?.name ?? '',
                onChanged: (c) => setState(() {
                  _clientId = c?.id;
                  if (c != null && widget.existing == null) _service = c.service;
                }),
                hint: clients.isEmpty ? 'Create a client first' : 'Select client',
              ),
            ),
            BzField(label: 'Project name', required: true, flex: 2, child: BzTextField(controller: _name, autofocus: true, hint: 'Launch reel series — October', validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null)),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Service', child: BzDropdown<ServiceType>(value: _service, items: ServiceType.values, labelOf: (s) => s.label, iconOf: StatusStyle.service, onChanged: (v) => setState(() => _service = v ?? _service))),
            BzField(label: 'Status', child: BzDropdown<ProjectStatus>(value: _status, items: ProjectStatus.values, labelOf: (s) => s.label, onChanged: (v) => setState(() => _status = v ?? _status))),
            BzField(label: 'Payment', child: BzDropdown<PaymentStatus>(value: _payment, items: PaymentStatus.values, labelOf: (s) => s.label, onChanged: (v) => setState(() => _payment = v ?? _payment))),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Shoot date', child: BzDateField(value: _shoot, onChanged: (d) => setState(() => _shoot = d))),
            BzField(label: 'Shoot time', child: BzTimeField(value: _shootTime, onChanged: (t) => setState(() => _shootTime = t))),
            BzField(label: 'Deadline', child: BzDateField(value: _deadline, onChanged: (d) => setState(() => _deadline = d))),
            BzField(label: 'Value', child: BzMoneyField(controller: _value)),
          ]),
          const SizedBox(height: 14),
          BzField(label: 'Deliverables', child: BzTextField(controller: _deliverables, minLines: 2, maxLines: 4, hint: '4 reels (30s), 10 edited photos, 1 BTS video…')),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Drive folder', child: BzTextField(controller: _drive, prefixIcon: BootstrapIcons.folder, hint: 'https://drive.google.com/…')),
            BzField(label: 'Notes', child: BzTextField(controller: _notes)),
          ]),
          if (widget.existing == null) ...[
            const SizedBox(height: 10),
            BzSwitchTile(
              title: 'Add shoot date & deadline to Google Calendar',
              subtitle: google.connected ? 'All-day events with a reminder the day before' : 'Connect Google in Settings to enable',
              icon: BootstrapIcons.google,
              value: _calendar && google.connected,
              onChanged: google.connected ? (v) => setState(() => _calendar = v) : (_) {},
            ),
          ],
          const SizedBox(height: 20),
          BzActionRow([
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            BzButton(label: widget.existing == null ? 'Create project' : 'Save changes', icon: BootstrapIcons.check2, loading: _saving, onPressed: _saving ? null : _save),
          ]),
        ],
      ),
    );
  }
}
