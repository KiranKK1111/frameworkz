import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;

import '../db/database.dart';
import '../settings/app_settings.dart';
import '../utils/format.dart';
import 'google_auth_service.dart';

/// Result of a calendar sync.
class CalendarSyncResult {
  const CalendarSyncResult({required this.eventId, this.meetLink, this.htmlLink});
  final String eventId;
  final String? meetLink;
  final String? htmlLink;
}

/// Creates, updates and removes Google Calendar events for follow-ups,
/// meetings, shoot dates and deadlines.
class CalendarService {
  CalendarService(this.auth, this.settings);

  final GoogleAuthService auth;
  final AppSettingsState Function() settings;

  bool get available => auth.isConnected && settings().calendarSync;

  /// Creates or updates the event backing a follow-up.
  ///
  /// * Timed follow-ups (meetings) become timed events with a popup reminder
  ///   [AppSettingsState.meetingLeadMinutes] before and, optionally, a Google
  ///   Meet link and an invitation to the contact.
  /// * All-day follow-ups become a 30-minute block at [followUpHour] so they
  ///   show up with a reminder instead of silently sitting in the all-day bar.
  Future<CalendarSyncResult> upsertFollowUp(
    FollowUp fu, {
    String? business,
    String? contactName,
    String? contactEmail,
    String? extraDescription,
  }) async {
    final s = settings();
    await auth.ensureFresh();
    final api = auth.calendar;
    final calId = s.calendarId.isEmpty ? 'primary' : s.calendarId;

    final isMeeting = fu.type == FollowUpType.meeting && fu.hasTime;
    final who = [if (contactName != null && contactName.isNotEmpty) contactName, if (business != null && business.isNotEmpty) business].join(' · ');
    final summary = isMeeting
        ? '📞 ${fu.title.isNotEmpty ? fu.title : 'Meeting'}${who.isNotEmpty ? ' — $who' : ''}'
        : '🔔 ${fu.title.isNotEmpty ? fu.title : 'Follow-up'}${who.isNotEmpty ? ' — $who' : ''}';

    final start = fu.hasTime ? fu.dueAt : DateTime(fu.dueAt.year, fu.dueAt.month, fu.dueAt.day, s.followUpHour);
    final end = start.add(Duration(minutes: fu.hasTime ? fu.durationMinutes : 30));

    final description = [
      'FrameWorkz ${fu.type.label} · ${fu.id}',
      if (fu.leadId != null) 'Lead: ${fu.leadId}',
      if (fu.clientId != null) 'Client: ${fu.clientId}',
      if (fu.notes.isNotEmpty) '\n${fu.notes}',
      if (extraDescription != null && extraDescription.isNotEmpty) '\n$extraDescription',
    ].join('\n');

    final event = gcal.Event()
      ..summary = summary
      ..description = description
      ..start = gcal.EventDateTime(dateTime: start.toUtc(), timeZone: s.timeZone)
      ..end = gcal.EventDateTime(dateTime: end.toUtc(), timeZone: s.timeZone)
      ..reminders = gcal.EventReminders(
        useDefault: false,
        overrides: [
          gcal.EventReminder(method: 'popup', minutes: isMeeting ? s.meetingLeadMinutes : 0),
          if (isMeeting) gcal.EventReminder(method: 'popup', minutes: 60),
        ],
      )
      ..colorId = isMeeting ? '9' : '5' // blueberry / banana
      ..extendedProperties = gcal.EventExtendedProperties(private: {'frameworkz': fu.id});

    final invite = isMeeting && s.calendarInviteContacts && (contactEmail ?? '').isNotEmpty;
    if (invite) {
      event.attendees = [gcal.EventAttendee(email: contactEmail, displayName: contactName)];
    }
    final wantMeet = isMeeting && s.calendarCreateMeet && fu.meetLink.isEmpty;
    if (wantMeet) {
      event.conferenceData = gcal.ConferenceData(
        createRequest: gcal.CreateConferenceRequest(
          requestId: 'bz-${fu.id}-${DateTime.now().millisecondsSinceEpoch}',
          conferenceSolutionKey: gcal.ConferenceSolutionKey(type: 'hangoutsMeet'),
        ),
      );
    }

    gcal.Event saved;
    if (fu.calendarEventId != null && fu.calendarEventId!.isNotEmpty) {
      try {
        saved = await api.events.patch(
          event,
          calId,
          fu.calendarEventId!,
          conferenceDataVersion: 1,
          sendUpdates: invite ? 'all' : 'none',
        );
      } catch (e) {
        debugPrint('Calendar patch failed (${fu.calendarEventId}), inserting instead: $e');
        saved = await api.events.insert(event, calId, conferenceDataVersion: 1, sendUpdates: invite ? 'all' : 'none');
      }
    } else {
      saved = await api.events.insert(event, calId, conferenceDataVersion: 1, sendUpdates: invite ? 'all' : 'none');
    }

    return CalendarSyncResult(
      eventId: saved.id!,
      meetLink: saved.hangoutLink ?? fu.meetLink,
      htmlLink: saved.htmlLink,
    );
  }

  /// Shoot dates and deadlines for projects.
  Future<String> upsertProjectEvent(Project p, Client client, {required bool deadline}) async {
    final s = settings();
    await auth.ensureFresh();
    final api = auth.calendar;
    final calId = s.calendarId.isEmpty ? 'primary' : s.calendarId;
    final date = deadline ? p.deadline! : p.shootDate!;
    final event = gcal.Event()
      ..summary = deadline ? '⏳ Deadline: ${p.name} — ${client.name}' : '🎬 Shoot: ${p.name} — ${client.name}'
      ..description = 'FrameWorkz project ${p.id}\n${p.deliverables}'
      ..start = gcal.EventDateTime(date: DateTime(date.year, date.month, date.day))
      ..end = gcal.EventDateTime(date: DateTime(date.year, date.month, date.day + 1))
      ..reminders = gcal.EventReminders(useDefault: false, overrides: [gcal.EventReminder(method: 'popup', minutes: 24 * 60)])
      ..colorId = deadline ? '11' : '3';
    final saved = await api.events.insert(event, calId);
    return saved.id!;
  }

  Future<void> deleteEvent(String eventId) async {
    final s = settings();
    try {
      await auth.ensureFresh();
      await auth.calendar.events.delete(s.calendarId.isEmpty ? 'primary' : s.calendarId, eventId);
    } catch (e) {
      debugPrint('Calendar delete failed: $e');
    }
  }

  /// Human summary for toasts.
  static String describe(FollowUp fu) => fu.hasTime ? '${Fmt.weekday(fu.dueAt)} at ${Fmt.time(fu.dueAt)}' : Fmt.weekday(fu.dueAt);
}
