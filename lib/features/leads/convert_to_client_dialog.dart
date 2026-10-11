import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../ui/widgets/bz_alert.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

/// Won lead → client (+ optional first project). Returns the created client.
Future<Client?> showConvertToClientDialog(BuildContext context, Lead lead) async {
  if (lead.clientId != null) return null;
  return showBzModal<Client>(
    context: context,
    title: 'Convert to client',
    subtitle: '${lead.business} just became a customer 🎉',
    icon: BootstrapIcons.trophy,
    variant: BzVariant.success,
    width: 620,
    child: _ConvertBody(lead: lead),
  );
}

class _ConvertBody extends ConsumerStatefulWidget {
  const _ConvertBody({required this.lead});
  final Lead lead;
  @override
  ConsumerState<_ConvertBody> createState() => _ConvertBodyState();
}

class _ConvertBodyState extends ConsumerState<_ConvertBody> {
  late final _name = TextEditingController(text: widget.lead.business);
  late final _monthly = TextEditingController(text: widget.lead.service == ServiceType.monthlyRetainer && widget.lead.potentialValue > 0 ? widget.lead.potentialValue.toStringAsFixed(0) : '');
  late final _project = TextEditingController(text: widget.lead.service != ServiceType.monthlyRetainer && widget.lead.potentialValue > 0 ? widget.lead.potentialValue.toStringAsFixed(0) : '');
  late final _projectName = TextEditingController(text: '${widget.lead.service.label} for ${widget.lead.business}');
  final _notes = TextEditingController();
  ClientStatus _status = ClientStatus.onboarding;
  bool _createProject = true;
  DateTime? _shoot;
  DateTime? _deadline;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _monthly, _project, _projectName, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      BzToasts.warning('Client name is required');
      return;
    }
    setState(() => _saving = true);
    try {
      final client = await ref.read(automationProvider).convertToClient(
            widget.lead,
            name: _name.text.trim(),
            monthlyValue: double.tryParse(_monthly.text) ?? 0,
            projectValue: double.tryParse(_project.text) ?? 0,
            status: _status,
            notes: _notes.text.trim(),
            createProject: _createProject,
            projectName: _projectName.text.trim(),
            shootDate: _shoot,
            deadline: _deadline,
          );
      BzToasts.success('${client.name} is now a client', message: client.id, actionLabel: 'Open', onAction: () => rootNavigatorKey.currentContext?.go(Routes.client(client.id)));
      if (mounted) Navigator.of(context).pop(client);
    } catch (e) {
      BzToasts.error('Conversion failed', message: e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BzAlert(
          variant: BzVariant.success,
          message: 'Contact details, service and Drive folder are copied over. The lead stays in your pipeline history as Won.',
          dense: true,
        ),
        const SizedBox(height: 16),
        BzRow([
          BzField(label: 'Client name', required: true, flex: 2, child: BzTextField(controller: _name, prefixIcon: BootstrapIcons.building)),
          BzField(label: 'Status', child: BzDropdown<ClientStatus>(value: _status, items: ClientStatus.values, labelOf: (s) => s.label, onChanged: (v) => setState(() => _status = v ?? _status))),
        ]),
        const SizedBox(height: 14),
        BzRow([
          BzField(label: 'Monthly value', help: 'For retainers', child: BzMoneyField(controller: _monthly)),
          BzField(label: 'Project value', help: 'For one-off work', child: BzMoneyField(controller: _project)),
        ]),
        const SizedBox(height: 14),
        BzField(label: 'Notes', child: BzTextField(controller: _notes, minLines: 2, maxLines: 3, hint: 'Agreed scope, payment terms…')),
        const SizedBox(height: 10),
        BzSwitchTile(title: 'Create the first project now', subtitle: 'Track shoot date, deadline and deliverables', icon: BootstrapIcons.camera_reels, value: _createProject, onChanged: (v) => setState(() => _createProject = v)),
        if (_createProject) ...[
          const SizedBox(height: 6),
          BzField(label: 'Project name', child: BzTextField(controller: _projectName)),
          const SizedBox(height: 14),
          BzRow([
            BzField(label: 'Shoot date', child: BzDateField(value: _shoot, onChanged: (d) => setState(() => _shoot = d))),
            BzField(label: 'Deadline', child: BzDateField(value: _deadline, onChanged: (d) => setState(() => _deadline = d))),
          ]),
        ],
        const SizedBox(height: 20),
        BzActionRow([
          BzButton(label: 'Later', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
          BzButton(label: 'Create client', icon: BootstrapIcons.person_check, variant: BzVariant.success, loading: _saving, onPressed: _saving ? null : _save),
        ]),
      ],
    );
  }
}
