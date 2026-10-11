import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../db/database.dart';
import '../db/repos.dart';
import '../google/calendar_service.dart';
import '../settings/app_settings.dart';
import '../utils/format.dart';

/// Returned by [LeadAutomation.changeStatus] so the UI can react (open the
/// email composer, start the convert-to-client wizard, show toasts…).
class StatusChangeResult {
  const StatusChangeResult({
    required this.lead,
    this.followUp,
    this.suggestedTemplate,
    this.calendarSynced = false,
    this.calendarError,
  });

  final Lead lead;
  final FollowUp? followUp;
  final EmailTemplate? suggestedTemplate;
  final bool calendarSynced;
  final String? calendarError;
}

/// The heart of FrameWorkz: a status change drives everything else.
///
/// ```
/// status changes ─► lastContact = today
///                ─► nextFollowUp = today + rule(status)
///                ─► previous pending follow-ups superseded
///                ─► new follow-up / meeting created
///                ─► Google Calendar event created (best effort)
///                ─► matching email template suggested
/// ```
class LeadAutomation {
  LeadAutomation({
    required this.db,
    required this.leads,
    required this.followUps,
    required this.clients,
    required this.projects,
    required this.templates,
    required this.calendar,
    required this.settings,
  });

  final AppDatabase db;
  final LeadsRepo leads;
  final FollowUpsRepo followUps;
  final ClientsRepo clients;
  final ProjectsRepo projects;
  final TemplatesRepo templates;
  final CalendarService calendar;
  final AppSettingsState Function() settings;

  // ------------------------------------------------------------- helpers
  static FollowUpType defaultTypeFor(LeadStatus s) => switch (s) {
        LeadStatus.newLead => FollowUpType.call,
        LeadStatus.contacted => FollowUpType.whatsapp,
        LeadStatus.replied => FollowUpType.call,
        LeadStatus.callScheduled => FollowUpType.meeting,
        LeadStatus.proposalSent => FollowUpType.email,
        LeadStatus.negotiation => FollowUpType.call,
        LeadStatus.nurture => FollowUpType.email,
        LeadStatus.won => FollowUpType.task,
        LeadStatus.lost => FollowUpType.task,
      };

  static String titleFor(Lead lead, LeadStatus s) {
    final who = lead.contactPerson.isNotEmpty ? lead.contactPerson : lead.business;
    return switch (s) {
      LeadStatus.newLead => 'Reach out to $who',
      LeadStatus.contacted => 'Check if $who has seen your message',
      LeadStatus.replied => 'Continue conversation with $who',
      LeadStatus.callScheduled => 'Discovery call with $who',
      LeadStatus.proposalSent => 'Follow up on proposal with $who',
      LeadStatus.negotiation => 'Close the deal with $who',
      LeadStatus.nurture => 'Stay in touch with $who',
      LeadStatus.won => 'Onboard ${lead.business}',
      LeadStatus.lost => 'Follow up with $who',
    };
  }

  // ------------------------------------------------------- status change
  Future<StatusChangeResult> changeStatus(
    Lead lead,
    LeadStatus to, {
    String note = '',
    DateTime? meetingAt,
    int meetingDurationMinutes = 45,
    String lostReason = '',
  }) async {
    final s = settings();
    final now = DateTime.now();
    final from = lead.status;

    final isMeeting = to == LeadStatus.callScheduled && meetingAt != null;
    DateTime? next;
    if (isMeeting) {
      next = meetingAt;
    } else {
      final days = s.followUpRules[to];
      if (days != null) next = DateUtilsX.startOfDay(now).add(Duration(days: days));
    }

    // Supersede older pending follow-ups (and their calendar events).
    final old = await followUps.supersedePendingForLead(lead.id);
    for (final o in old) {
      if (o.calendarEventId != null && o.calendarEventId!.isNotEmpty && calendar.available) {
        await calendar.deleteEvent(o.calendarEventId!);
      }
    }

    final updated = lead.copyWith(
      status: to,
      lastContact: Value(now),
      nextFollowUp: Value(next),
      lostReason: lostReason.isNotEmpty ? lostReason : lead.lostReason,
      updatedAt: now,
    );
    await leads.save(updated);
    await db.logActivity(
      entityType: EntityType.lead,
      entityId: lead.id,
      kind: ActivityKind.statusChanged,
      title: 'Status changed: ${from.label} → ${to.label}',
      detail: [if (note.isNotEmpty) note, if (lostReason.isNotEmpty) 'Reason: $lostReason'].join('\n'),
    );

    FollowUp? fu;
    bool synced = false;
    String? calError;
    if (next != null) {
      fu = await followUps.create(
        leadId: lead.id,
        title: isMeeting ? 'Discovery call' : titleFor(updated, to),
        dueAt: next,
        hasTime: isMeeting,
        durationMinutes: meetingDurationMinutes,
        type: isMeeting ? FollowUpType.meeting : defaultTypeFor(to),
        notes: note,
      );
      if (isMeeting) {
        await db.logActivity(
          entityType: EntityType.lead,
          entityId: lead.id,
          kind: ActivityKind.meetingScheduled,
          title: 'Meeting scheduled for ${Fmt.dateTime(meetingAt)}',
        );
      }
      final r = await syncCalendar(fu, lead: updated);
      fu = r.$1;
      synced = r.$2 == null && fu.calendarEventId != null;
      calError = r.$2;
    }

    final tpl = await templates.forStatus(to);
    return StatusChangeResult(lead: updated, followUp: fu, suggestedTemplate: tpl, calendarSynced: synced, calendarError: calError);
  }

  /// For brand new leads: schedules the first "reach out" follow-up.
  Future<FollowUp?> ensureInitialFollowUp(Lead lead) async {
    if (lead.status != LeadStatus.newLead) return null;
    final existing = await followUps.pending();
    if (existing.any((f) => f.leadId == lead.id)) return null;
    final days = settings().followUpRules[LeadStatus.newLead] ?? 0;
    final due = DateUtilsX.startOfDay(DateTime.now()).add(Duration(days: days));
    final fu = await followUps.create(leadId: lead.id, title: titleFor(lead, LeadStatus.newLead), dueAt: due, type: FollowUpType.call);
    await leads.patch(lead.id, LeadsCompanion(nextFollowUp: Value(due)));
    final r = await syncCalendar(fu, lead: lead);
    return r.$1;
  }

  // ----------------------------------------------------------- calendar
  /// Best-effort calendar sync. Returns the (possibly updated) follow-up and
  /// an error message when the sync failed.
  Future<(FollowUp, String?)> syncCalendar(FollowUp fu, {Lead? lead, Client? client}) async {
    if (!calendar.available) return (fu, null);
    try {
      final res = await calendar.upsertFollowUp(
        fu,
        business: lead?.business ?? client?.name,
        contactName: lead?.contactPerson ?? client?.contactPerson,
        contactEmail: lead?.email ?? client?.email,
      );
      final updated = fu.copyWith(calendarEventId: Value(res.eventId), meetLink: res.meetLink ?? fu.meetLink);
      await followUps.save(updated);
      if (fu.calendarEventId == null) {
        await db.logActivity(
          entityType: lead != null ? EntityType.lead : EntityType.client,
          entityId: lead?.id ?? client?.id ?? fu.id,
          kind: ActivityKind.calendarSynced,
          title: 'Added to Google Calendar',
          detail: CalendarService.describe(updated),
        );
      }
      return (updated, null);
    } catch (e) {
      debugPrint('Calendar sync failed: $e');
      return (fu, 'Google Calendar sync failed: ${_short(e)}');
    }
  }

  static String _short(Object e) {
    final s = e.toString();
    return s.length > 140 ? '${s.substring(0, 140)}…' : s;
  }

  // ---------------------------------------------------------- follow-ups
  Future<FollowUp> scheduleFollowUp({
    Lead? lead,
    Client? client,
    required DateTime dueAt,
    bool hasTime = false,
    int durationMinutes = 30,
    FollowUpType type = FollowUpType.call,
    String? title,
    String notes = '',
  }) async {
    final who = lead?.contactPerson.isNotEmpty == true ? lead!.contactPerson : (lead?.business ?? client?.contactPerson ?? client?.name ?? '');
    var fu = await followUps.create(
      leadId: lead?.id,
      clientId: client?.id,
      title: title == null || title.isEmpty ? (type == FollowUpType.meeting ? 'Meeting with $who' : 'Follow up with $who') : title,
      dueAt: dueAt,
      hasTime: hasTime,
      durationMinutes: durationMinutes,
      type: type,
      notes: notes,
    );
    if (lead != null && (lead.nextFollowUp == null || dueAt.isBefore(lead.nextFollowUp!))) {
      await leads.patch(lead.id, LeadsCompanion(nextFollowUp: Value(dueAt)));
    }
    await db.logActivity(
      entityType: lead != null ? EntityType.lead : EntityType.client,
      entityId: lead?.id ?? client?.id ?? fu.id,
      kind: type == FollowUpType.meeting ? ActivityKind.meetingScheduled : ActivityKind.followUpSnoozed,
      title: type == FollowUpType.meeting ? 'Meeting scheduled for ${Fmt.dateTime(dueAt)}' : 'Follow-up scheduled for ${Fmt.date(dueAt)}',
      detail: notes,
    );
    final r = await syncCalendar(fu, lead: lead, client: client);
    fu = r.$1;
    return fu;
  }

  Future<void> completeFollowUp(FollowUp fu, {String outcome = ''}) async {
    final now = DateTime.now();
    await followUps.patch(
      fu.id,
      FollowUpsCompanion(status: const Value(FollowUpStatus.done), completedAt: Value(now), outcome: Value(outcome)),
    );
    final entityType = fu.leadId != null ? EntityType.lead : EntityType.client;
    final entityId = fu.leadId ?? fu.clientId;
    if (entityId != null) {
      await db.logActivity(entityType: entityType, entityId: entityId, kind: ActivityKind.followUpDone, title: 'Completed: ${fu.title}', detail: outcome);
    }
    if (fu.leadId != null) {
      final lead = await leads.byId(fu.leadId!);
      if (lead != null) {
        final remaining = (await followUps.pending()).where((f) => f.leadId == lead.id).toList()..sort((a, b) => a.dueAt.compareTo(b.dueAt));
        await leads.patch(lead.id, LeadsCompanion(lastContact: Value(now), nextFollowUp: Value(remaining.isEmpty ? null : remaining.first.dueAt)));
      }
    }
    // Remove the reminder from the calendar when completing ahead of time.
    if (fu.calendarEventId != null && fu.calendarEventId!.isNotEmpty && fu.dueAt.isAfter(now) && calendar.available) {
      await calendar.deleteEvent(fu.calendarEventId!);
    }
  }

  Future<void> skipFollowUp(FollowUp fu) async {
    await followUps.patch(fu.id, const FollowUpsCompanion(status: Value(FollowUpStatus.skipped)));
    if (fu.calendarEventId != null && fu.calendarEventId!.isNotEmpty && calendar.available) {
      await calendar.deleteEvent(fu.calendarEventId!);
    }
    if (fu.leadId != null) {
      final remaining = (await followUps.pending()).where((f) => f.leadId == fu.leadId).toList()..sort((a, b) => a.dueAt.compareTo(b.dueAt));
      await leads.patch(fu.leadId!, LeadsCompanion(nextFollowUp: Value(remaining.isEmpty ? null : remaining.first.dueAt)));
    }
  }

  Future<FollowUp> reschedule(FollowUp fu, DateTime newDue, {bool? hasTime}) async {
    var updated = fu.copyWith(dueAt: newDue, hasTime: hasTime ?? fu.hasTime, notifiedAt: const Value(null));
    await followUps.save(updated);
    Lead? lead;
    if (fu.leadId != null) {
      lead = await leads.byId(fu.leadId!);
      if (lead != null) await leads.patch(lead.id, LeadsCompanion(nextFollowUp: Value(newDue)));
      await db.logActivity(entityType: EntityType.lead, entityId: fu.leadId!, kind: ActivityKind.followUpSnoozed, title: 'Rescheduled to ${updated.hasTime ? Fmt.dateTime(newDue) : Fmt.date(newDue)}', detail: fu.title);
    }
    final r = await syncCalendar(updated, lead: lead);
    updated = r.$1;
    return updated;
  }

  Future<void> deleteFollowUp(FollowUp fu) async {
    if (fu.calendarEventId != null && fu.calendarEventId!.isNotEmpty && calendar.available) {
      await calendar.deleteEvent(fu.calendarEventId!);
    }
    await followUps.delete(fu.id);
  }

  // ---------------------------------------------------------- conversion
  Future<Client> convertToClient(
    Lead lead, {
    required String name,
    double monthlyValue = 0,
    double projectValue = 0,
    ClientStatus status = ClientStatus.onboarding,
    String notes = '',
    bool createProject = false,
    String projectName = '',
    DateTime? shootDate,
    DateTime? deadline,
  }) async {
    final client = await clients.create(
      name: name,
      contactPerson: lead.contactPerson,
      phone: lead.phone,
      email: lead.email,
      instagram: lead.instagram,
      service: lead.service,
      monthlyValue: monthlyValue,
      projectValue: projectValue,
      status: status,
      driveFolder: lead.driveFolder,
      notes: notes,
      leadId: lead.id,
    );
    await leads.patch(lead.id, LeadsCompanion(clientId: Value(client.id), status: const Value(LeadStatus.won)));
    await db.logActivity(entityType: EntityType.lead, entityId: lead.id, kind: ActivityKind.converted, title: 'Converted to client ${client.id}', detail: client.name);
    await db.logActivity(entityType: EntityType.client, entityId: client.id, kind: ActivityKind.converted, title: 'Converted from lead ${lead.id}', detail: 'Source: ${lead.source.label}');
    if (createProject && projectName.trim().isNotEmpty) {
      await projects.create(
        clientId: client.id,
        name: projectName.trim(),
        service: lead.service,
        shootDate: shootDate,
        deadline: deadline,
        value: projectValue,
      );
    }
    return client;
  }
}
