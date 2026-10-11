import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

Future<Client?> showClientFormDialog(BuildContext context, WidgetRef ref, {Client? existing}) {
  return showBzModal<Client>(
    context: context,
    title: existing == null ? 'New client' : 'Edit client',
    subtitle: existing?.id ?? 'Add a client directly (skipping the lead pipeline)',
    icon: existing == null ? BootstrapIcons.person_plus : BootstrapIcons.pencil_square,
    width: 640,
    child: _ClientForm(existing: existing),
  );
}

class _ClientForm extends ConsumerStatefulWidget {
  const _ClientForm({this.existing});
  final Client? existing;
  @override
  ConsumerState<_ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends ConsumerState<_ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _contact = TextEditingController(text: widget.existing?.contactPerson ?? '');
  late final _phone = TextEditingController(text: widget.existing?.phone ?? '');
  late final _email = TextEditingController(text: widget.existing?.email ?? '');
  late final _instagram = TextEditingController(text: widget.existing?.instagram ?? '');
  late final _monthly = TextEditingController(text: (widget.existing?.monthlyValue ?? 0) > 0 ? widget.existing!.monthlyValue.toStringAsFixed(0) : '');
  late final _project = TextEditingController(text: (widget.existing?.projectValue ?? 0) > 0 ? widget.existing!.projectValue.toStringAsFixed(0) : '');
  late final _drive = TextEditingController(text: widget.existing?.driveFolder ?? '');
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  late ServiceType _service = widget.existing?.service ?? ServiceType.monthlyRetainer;
  late ClientStatus _status = widget.existing?.status ?? ClientStatus.onboarding;
  late DateTime _start = widget.existing?.startDate ?? DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _contact, _phone, _email, _instagram, _monthly, _project, _drive, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final repo = ref.read(clientsRepoProvider);
      if (widget.existing == null) {
        final c = await repo.create(
          name: _name.text,
          contactPerson: _contact.text,
          phone: _phone.text,
          email: _email.text,
          instagram: _instagram.text,
          service: _service,
          monthlyValue: double.tryParse(_monthly.text) ?? 0,
          projectValue: double.tryParse(_project.text) ?? 0,
          startDate: _start,
          status: _status,
          driveFolder: _drive.text,
          notes: _notes.text,
        );
        BzToasts.success('Client ${c.id} created', message: c.name);
        if (mounted) Navigator.of(context).pop(c);
      } else {
        final c = widget.existing!.copyWith(
          name: _name.text.trim(),
          contactPerson: _contact.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          instagram: _instagram.text.trim(),
          service: _service,
          monthlyValue: double.tryParse(_monthly.text) ?? 0,
          projectValue: double.tryParse(_project.text) ?? 0,
          startDate: _start,
          status: _status,
          driveFolder: _drive.text.trim(),
          notes: _notes.text.trim(),
        );
        await repo.save(c);
        BzToasts.success('Client updated', message: c.name);
        if (mounted) Navigator.of(context).pop(c);
      }
    } catch (e) {
      BzToasts.error('Could not save client', message: e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BzRow([
            BzField(label: 'Client name', required: true, flex: 3, child: BzTextField(controller: _name, autofocus: true, prefixIcon: BootstrapIcons.building, validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null)),
            BzField(label: 'Contact person', flex: 2, child: BzTextField(controller: _contact, prefixIcon: BootstrapIcons.person)),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Phone', child: BzTextField(controller: _phone, prefixIcon: BootstrapIcons.telephone)),
            BzField(label: 'Email', child: BzTextField(controller: _email, prefixIcon: BootstrapIcons.at)),
            BzField(label: 'Instagram', child: BzTextField(controller: _instagram, prefixIcon: BootstrapIcons.instagram)),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Service', child: BzDropdown<ServiceType>(value: _service, items: ServiceType.values, labelOf: (s) => s.label, iconOf: StatusStyle.service, onChanged: (v) => setState(() => _service = v ?? _service))),
            BzField(label: 'Status', child: BzDropdown<ClientStatus>(value: _status, items: ClientStatus.values, labelOf: (s) => s.label, onChanged: (v) => setState(() => _status = v ?? _status))),
            BzField(label: 'Start date', child: BzDateField(value: _start, clearable: false, onChanged: (d) => setState(() => _start = d ?? _start))),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Monthly value', child: BzMoneyField(controller: _monthly)),
            BzField(label: 'Project value', child: BzMoneyField(controller: _project)),
            BzField(label: 'Drive folder', child: BzTextField(controller: _drive, prefixIcon: BootstrapIcons.folder, hint: 'https://drive.google.com/…')),
          ]),
          const SizedBox(height: 14),
          BzField(label: 'Notes', child: BzTextField(controller: _notes, minLines: 2, maxLines: 4)),
          const SizedBox(height: 20),
          BzActionRow([
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            BzButton(label: widget.existing == null ? 'Create client' : 'Save changes', icon: BootstrapIcons.check2, loading: _saving, onPressed: _saving ? null : _save),
          ]),
        ],
      ),
    );
  }
}
