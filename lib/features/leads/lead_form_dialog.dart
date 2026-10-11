import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

/// Create or edit a lead. Mirrors the Google Form fields one-to-one.
Future<Lead?> showLeadFormDialog(BuildContext context, WidgetRef ref, {Lead? existing}) {
  return showBzModal<Lead>(
    context: context,
    title: existing == null ? 'New lead' : 'Edit lead',
    subtitle: existing == null ? 'Same fields as your Google Form — the first follow-up is scheduled automatically.' : existing.id,
    icon: existing == null ? BootstrapIcons.person_plus : BootstrapIcons.pencil_square,
    width: 640,
    child: _LeadForm(existing: existing),
  );
}

class _LeadForm extends ConsumerStatefulWidget {
  const _LeadForm({this.existing});
  final Lead? existing;
  @override
  ConsumerState<_LeadForm> createState() => _LeadFormState();
}

class _LeadFormState extends ConsumerState<_LeadForm> {
  final _formKey = GlobalKey<FormState>();
  late final _business = TextEditingController(text: widget.existing?.business ?? '');
  late final _contact = TextEditingController(text: widget.existing?.contactPerson ?? '');
  late final _phone = TextEditingController(text: widget.existing?.phone ?? '');
  late final _email = TextEditingController(text: widget.existing?.email ?? '');
  late final _instagram = TextEditingController(text: widget.existing?.instagram ?? '');
  late final _value = TextEditingController(text: widget.existing != null && widget.existing!.potentialValue > 0 ? widget.existing!.potentialValue.toStringAsFixed(0) : '');
  late final _notes = TextEditingController(text: widget.existing?.notes ?? '');
  late final _proposal = TextEditingController(text: widget.existing?.proposalLink ?? '');
  late final _drive = TextEditingController(text: widget.existing?.driveFolder ?? '');
  late LeadSource _source = widget.existing?.source ?? LeadSource.instagram;
  late ServiceType _service = widget.existing?.service ?? ServiceType.reels;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_business, _contact, _phone, _email, _instagram, _value, _notes, _proposal, _drive]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(leadsRepoProvider);
    try {
      final value = double.tryParse(_value.text.replaceAll(',', '')) ?? 0;
      if (widget.existing == null) {
        final lead = await repo.create(
          business: _business.text,
          contactPerson: _contact.text,
          phone: _phone.text,
          email: _email.text,
          instagram: _instagram.text,
          source: _source,
          service: _service,
          potentialValue: value,
          notes: _notes.text,
        );
        final fu = await ref.read(automationProvider).ensureInitialFollowUp(lead);
        BzToasts.success(
          'Lead ${lead.id} created',
          message: fu != null ? 'First follow-up ${Fmt.relativeDay(fu.dueAt).toLowerCase()}: ${fu.title}' : lead.business,
          actionLabel: 'Open',
          onAction: () => rootNavigatorKey.currentContext?.go(Routes.lead(lead.id)),
        );
        if (mounted) Navigator.of(context).pop(lead);
      } else {
        final updated = widget.existing!.copyWith(
          business: _business.text.trim(),
          contactPerson: _contact.text.trim(),
          phone: _phone.text.trim(),
          email: _email.text.trim(),
          instagram: _instagram.text.trim(),
          source: _source,
          service: _service,
          potentialValue: value,
          notes: _notes.text.trim(),
          proposalLink: _proposal.text.trim(),
          driveFolder: _drive.text.trim(),
        );
        await repo.save(updated);
        BzToasts.success('Lead updated', message: updated.business);
        if (mounted) Navigator.of(context).pop(updated);
      }
    } catch (e) {
      BzToasts.error('Could not save lead', message: e.toString());
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
            BzField(label: 'Business name', required: true, flex: 3, child: BzTextField(controller: _business, autofocus: true, prefixIcon: BootstrapIcons.building, hint: 'Chennai Fitness Lab', validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null)),
            BzField(label: 'Contact person', flex: 2, child: BzTextField(controller: _contact, prefixIcon: BootstrapIcons.person, hint: 'Who you talk to')),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Phone', child: BzTextField(controller: _phone, prefixIcon: BootstrapIcons.telephone, hint: '98765 43210', keyboardType: TextInputType.phone)),
            BzField(label: 'Email', child: BzTextField(controller: _email, prefixIcon: BootstrapIcons.at, hint: 'name@company.com', keyboardType: TextInputType.emailAddress, validator: (v) => (v ?? '').trim().isNotEmpty && !(v ?? '').contains('@') ? 'Invalid email' : null)),
            BzField(label: 'Instagram', child: BzTextField(controller: _instagram, prefixIcon: BootstrapIcons.instagram, hint: '@handle')),
          ]),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Source', child: BzDropdown<LeadSource>(value: _source, items: LeadSource.values, labelOf: (s) => s.label, iconOf: StatusStyle.source, onChanged: (v) => setState(() => _source = v ?? _source))),
            BzField(label: 'Service', child: BzDropdown<ServiceType>(value: _service, items: ServiceType.values, labelOf: (s) => s.label, iconOf: StatusStyle.service, onChanged: (v) => setState(() => _service = v ?? _service))),
            BzField(label: 'Potential value', child: BzMoneyField(controller: _value)),
          ]),
          const SizedBox(height: 14),
          BzField(label: 'Notes', child: BzTextField(controller: _notes, minLines: 2, maxLines: 4, hint: 'Where they found you, what they need, timeline…')),
          if (widget.existing != null) ...[
            const SizedBox(height: 14),
            BzRow([
              BzField(label: 'Proposal link', child: BzTextField(controller: _proposal, prefixIcon: BootstrapIcons.link_45deg, hint: 'https://')),
              BzField(label: 'Drive folder', child: BzTextField(controller: _drive, prefixIcon: BootstrapIcons.folder, hint: 'https://drive.google.com/…')),
            ]),
          ],
          const SizedBox(height: 20),
          BzActionRow([
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            BzButton(label: widget.existing == null ? 'Create lead' : 'Save changes', icon: BootstrapIcons.check2, loading: _saving, onPressed: _saving ? null : _save),
          ]),
        ],
      ),
    );
  }
}
