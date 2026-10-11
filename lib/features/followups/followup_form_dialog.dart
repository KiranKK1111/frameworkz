import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/bz_colors.dart';
import '../../core/providers.dart';
import '../../core/utils/format.dart';
import '../../ui/widgets/bz_badge.dart';
import '../../ui/widgets/bz_button.dart';
import '../../ui/widgets/bz_form.dart';
import '../../ui/widgets/bz_modal.dart';
import '../../ui/widgets/bz_toast.dart';

/// Schedule a follow-up or a meeting for a lead or client.
Future<FollowUp?> showFollowUpFormDialog(BuildContext context, WidgetRef ref, {Lead? lead, Client? client, bool meeting = false}) {
  return showBzModal<FollowUp>(
    context: context,
    title: meeting ? 'Schedule meeting' : 'Schedule follow-up',
    subtitle: lead?.business ?? client?.name ?? 'Pick who this is for',
    icon: meeting ? BootstrapIcons.camera_video : BootstrapIcons.bell,
    width: 600,
    child: _FollowUpForm(lead: lead, client: client, meeting: meeting),
  );
}

class _FollowUpForm extends ConsumerStatefulWidget {
  const _FollowUpForm({this.lead, this.client, required this.meeting});
  final Lead? lead;
  final Client? client;
  final bool meeting;
  @override
  ConsumerState<_FollowUpForm> createState() => _FollowUpFormState();
}

class _FollowUpFormState extends ConsumerState<_FollowUpForm> {
  Lead? _lead;
  Client? _client;
  late FollowUpType _type = widget.meeting ? FollowUpType.meeting : FollowUpType.call;
  DateTime _date = DateUtilsX.startOfDay(DateTime.now()).add(const Duration(days: 1));
  TimeOfDay _time = const TimeOfDay(hour: 11, minute: 0);
  int _duration = 45;
  final _title = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;

  bool get _hasTime => _type == FollowUpType.meeting;

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
    _client = widget.client;
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_lead == null && _client == null) {
      BzToasts.warning('Choose a lead or client');
      return;
    }
    setState(() => _saving = true);
    try {
      final due = _hasTime ? DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute) : DateUtilsX.startOfDay(_date);
      final fu = await ref.read(automationProvider).scheduleFollowUp(
            lead: _lead,
            client: _client,
            dueAt: due,
            hasTime: _hasTime,
            durationMinutes: _duration,
            type: _type,
            title: _title.text.trim(),
            notes: _notes.text.trim(),
          );
      BzToasts.success(
        _hasTime ? 'Meeting scheduled' : 'Follow-up scheduled',
        message: '${fu.title} · ${_hasTime ? Fmt.dateTime(fu.dueAt) : Fmt.weekday(fu.dueAt)}${fu.calendarEventId != null ? ' · in Google Calendar' : ''}',
      );
      if (mounted) Navigator.of(context).pop(fu);
    } catch (e) {
      BzToasts.error('Could not schedule', message: e.toString());
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final leads = ref.watch(leadsProvider).value ?? const [];
    final clients = ref.watch(clientsProvider).value ?? const [];
    final google = ref.watch(googleAuthStateProvider).value ?? const GoogleAuthState();
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.lead == null && widget.client == null)
          BzRow([
            BzField(
              label: 'Lead',
              child: BzDropdown<Lead?>(
                value: _lead,
                items: [null, ...leads.where((l) => l.status.isOpen)],
                labelOf: (l) => l == null ? '—' : '${l.business}${l.contactPerson.isNotEmpty ? ' · ${l.contactPerson}' : ''}',
                onChanged: (v) => setState(() {
                  _lead = v;
                  if (v != null) _client = null;
                }),
              ),
            ),
            BzField(
              label: 'Client',
              child: BzDropdown<Client?>(
                value: _client,
                items: [null, ...clients],
                labelOf: (c) => c == null ? '—' : c.name,
                onChanged: (v) => setState(() {
                  _client = v;
                  if (v != null) _lead = null;
                }),
              ),
            ),
          ]),
        if (widget.lead == null && widget.client == null) const SizedBox(height: 14),
        BzRow([
          BzField(
            label: 'Type',
            child: BzDropdown<FollowUpType>(value: _type, items: FollowUpType.values, labelOf: (t) => t.label, iconOf: StatusStyle.followUpType, onChanged: (v) => setState(() => _type = v ?? _type)),
          ),
          BzField(label: _hasTime ? 'Date' : 'Due date', required: true, child: BzDateField(value: _date, clearable: false, onChanged: (d) => setState(() => _date = d ?? _date))),
          if (_hasTime) BzField(label: 'Time', required: true, child: BzTimeField(value: _time, onChanged: (t) => setState(() => _time = t ?? _time))),
          if (_hasTime) BzField(label: 'Duration', child: BzDropdown<int>(value: _duration, items: const [15, 30, 45, 60, 90], labelOf: (d) => '$d min', onChanged: (d) => setState(() => _duration = d ?? 45))),
        ]),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          children: [
            for (final (label, days) in const [('Today', 0), ('Tomorrow', 1), ('In 2 days', 2), ('In 3 days', 3), ('Next week', 7), ('In 2 weeks', 14)])
              ChoiceChip(
                label: Text(label, style: const TextStyle(fontSize: 12)),
                selected: DateUtilsX.isSameDay(_date, DateUtilsX.startOfDay(DateTime.now()).add(Duration(days: days))),
                onSelected: (_) => setState(() => _date = DateUtilsX.startOfDay(DateTime.now()).add(Duration(days: days))),
              ),
          ],
        ),
        const SizedBox(height: 14),
        BzField(label: 'Title', help: 'Leave empty for an automatic title', child: BzTextField(controller: _title, hint: _hasTime ? 'Discovery call' : 'Follow up on proposal')),
        const SizedBox(height: 14),
        BzField(label: 'Notes', child: BzTextField(controller: _notes, minLines: 2, maxLines: 4, hint: 'Agenda, talking points…')),
        const SizedBox(height: 12),
        Row(children: [
          Icon(BootstrapIcons.google, size: 13, color: google.connected ? BzColors.success : theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              google.connected
                  ? (_hasTime ? 'A Google Calendar event (with Meet link) and reminder will be created.' : 'A Google Calendar reminder will be created.')
                  : 'Connect Google in Settings to mirror this to your calendar.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ]),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BzButton(label: 'Cancel', variant: BzVariant.light, onPressed: () => Navigator.of(context).pop()),
            const SizedBox(width: 8),
            BzButton(label: _hasTime ? 'Schedule meeting' : 'Schedule', icon: BootstrapIcons.calendar_plus, loading: _saving, onPressed: _saving ? null : _save),
          ],
        ),
      ],
    );
  }
}
