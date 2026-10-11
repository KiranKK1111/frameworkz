import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../db/database.dart';
import '../db/repos.dart';
import '../google/google_auth_service.dart';
import '../google/sheets_import_service.dart';
import '../notifications/notification_service.dart';
import '../platform.dart';
import '../settings/app_settings.dart';
import '../utils/format.dart';

/// A reminder surfaced to the UI layer (toast) in addition to the OS
/// notification and the in-app inbox.
class ReminderEvent {
  const ReminderEvent({required this.kind, required this.title, this.body = '', this.entityType, this.entityId});
  final NotificationKind kind;
  final String title;
  final String body;
  final EntityType? entityType;
  final String? entityId;
}

/// Runs every minute while the app (or its tray icon) is alive.
///
/// * Meeting reminders N minutes before start.
/// * Daily follow-up reminders at the configured time (grouped when many).
/// * Overdue invoices flagged and announced once.
/// * Morning digest with today's agenda.
/// * Optional polling of the Google Form responses sheet for new leads.
class AutomationScheduler {
  AutomationScheduler({
    required this.db,
    required this.followUps,
    required this.leads,
    required this.clients,
    required this.invoices,
    required this.settings,
    required this.notifications,
    required this.sheetsImport,
    required this.googleAuth,
  });

  final AppDatabase db;
  final FollowUpsRepo followUps;
  final LeadsRepo leads;
  final ClientsRepo clients;
  final InvoicesRepo invoices;
  final AppSettingsState Function() settings;
  final NotificationService notifications;
  final SheetsImportService sheetsImport;
  final GoogleAuthService googleAuth;

  final StreamController<ReminderEvent> _events = StreamController.broadcast();
  Stream<ReminderEvent> get events => _events.stream;

  Timer? _timer;
  DateTime? _lastSheetsPoll;
  bool _running = false;
  String _lastPlanSignature = '';

  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => tick());
    Future.delayed(const Duration(seconds: 3), tick);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> tick() async {
    if (_running) return;
    _running = true;
    try {
      await _checkFollowUps();
      await _checkInvoices();
      await _dailyDigest();
      await _pollSheets();
      await planMobileNotifications();
    } catch (e, st) {
      debugPrint('Scheduler tick failed: $e\n$st');
    } finally {
      _running = false;
    }
  }

  DateTime _dailyAt(DateTime now, AppSettingsState s) {
    final parts = s.dailyReminderTime.split(':');
    final h = int.tryParse(parts.first) ?? 9;
    final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 30 : 30;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  Future<String> _who(FollowUp fu) async {
    if (fu.leadId != null) {
      final l = await leads.byId(fu.leadId!);
      if (l != null) return l.contactPerson.isNotEmpty ? '${l.contactPerson} · ${l.business}' : l.business;
    }
    if (fu.clientId != null) {
      final c = await clients.byId(fu.clientId!);
      if (c != null) return c.contactPerson.isNotEmpty ? '${c.contactPerson} · ${c.name}' : c.name;
    }
    return '';
  }

  Future<void> _emit(ReminderEvent ev, {bool os = true}) async {
    await db.pushNotification(kind: ev.kind, title: ev.title, body: ev.body, entityType: ev.entityType, entityId: ev.entityId);
    if (os && settings().osNotifications) {
      await notifications.show(title: ev.title, body: ev.body);
    }
    _events.add(ev);
  }

  // ------------------------------------------------------------ follow-ups
  Future<void> _checkFollowUps() async {
    final s = settings();
    final now = DateTime.now();
    final todayStart = DateUtilsX.startOfDay(now);
    final dailyAt = _dailyAt(now, s);
    final pending = await followUps.pending();

    final dueToday = <FollowUp>[];
    for (final fu in pending) {
      if (fu.hasTime) {
        final fireAt = fu.dueAt.subtract(Duration(minutes: s.meetingLeadMinutes));
        final tooOld = fu.dueAt.isBefore(now.subtract(const Duration(hours: 2)));
        if (!now.isBefore(fireAt) && fu.notifiedAt == null && !tooOld) {
          final who = await _who(fu);
          final mins = fu.dueAt.difference(now).inMinutes;
          await _emit(ReminderEvent(
            kind: NotificationKind.meeting,
            title: mins > 0 ? 'Meeting in $mins min · ${fu.title}' : 'Meeting now · ${fu.title}',
            body: [who, Fmt.time(fu.dueAt), if (fu.meetLink.isNotEmpty) fu.meetLink].where((e) => e.isNotEmpty).join(' · '),
            entityType: fu.leadId != null ? EntityType.lead : EntityType.followUp,
            entityId: fu.leadId ?? fu.id,
          ));
          await followUps.patch(fu.id, FollowUpsCompanion(notifiedAt: Value(now)));
        }
      } else {
        final isDue = !fu.dueAt.isAfter(DateUtilsX.endOfDay(now));
        final notYetToday = fu.notifiedAt == null || fu.notifiedAt!.isBefore(todayStart);
        if (isDue && notYetToday && !now.isBefore(dailyAt)) dueToday.add(fu);
      }
    }

    if (dueToday.isEmpty) return;
    if (dueToday.length <= 3) {
      for (final fu in dueToday) {
        final overdue = DateUtilsX.isPastDay(fu.dueAt);
        final who = await _who(fu);
        await _emit(ReminderEvent(
          kind: overdue ? NotificationKind.followUpOverdue : NotificationKind.followUpDue,
          title: overdue ? 'Overdue · ${fu.title}' : 'Follow-up today · ${fu.title}',
          body: [who, '${fu.type.label} · ${Fmt.relativeDay(fu.dueAt)}'].where((e) => e.isNotEmpty).join(' · '),
          entityType: fu.leadId != null ? EntityType.lead : EntityType.followUp,
          entityId: fu.leadId ?? fu.id,
        ));
      }
    } else {
      final overdue = dueToday.where((f) => DateUtilsX.isPastDay(f.dueAt)).length;
      await _emit(ReminderEvent(
        kind: NotificationKind.followUpDue,
        title: '${dueToday.length} follow-ups need attention',
        body: overdue > 0 ? '$overdue overdue · ${dueToday.length - overdue} due today' : 'All due today — open FrameWorkz to work through them',
        entityType: EntityType.followUp,
      ));
    }
    for (final fu in dueToday) {
      await followUps.patch(fu.id, FollowUpsCompanion(notifiedAt: Value(now)));
    }
  }

  // -------------------------------------------------------------- invoices
  Future<void> _checkInvoices() async {
    final now = DateTime.now();
    final todayStart = DateUtilsX.startOfDay(now);
    final all = await invoices.all();
    for (final inv in all) {
      final outstanding = inv.status == InvoiceStatus.sent || inv.status == InvoiceStatus.partiallyPaid || inv.status == InvoiceStatus.overdue;
      if (!outstanding) continue;
      if (inv.dueDate.isBefore(todayStart)) {
        if (inv.status != InvoiceStatus.overdue) {
          await invoices.save(inv.copyWith(status: InvoiceStatus.overdue));
        }
        if (inv.notifiedAt == null) {
          final client = await clients.byId(inv.clientId);
          await _emit(ReminderEvent(
            kind: NotificationKind.invoiceOverdue,
            title: 'Invoice ${inv.id} is overdue',
            body: '${client?.name ?? inv.clientId} · ${Fmt.money(inv.amount - inv.amountReceived)} outstanding · due ${Fmt.date(inv.dueDate)}',
            entityType: EntityType.invoice,
            entityId: inv.id,
          ));
          await invoices.save(inv.copyWith(status: InvoiceStatus.overdue, notifiedAt: Value(now)));
        }
      }
    }
  }

  // ---------------------------------------------------------------- digest
  Future<void> _dailyDigest() async {
    final s = settings();
    if (!s.overdueDigest) return;
    final now = DateTime.now();
    if (now.isBefore(_dailyAt(now, s))) return;
    final todayKey = DateUtilsX.startOfDay(now).toIso8601String();
    if (await db.getSetting(Keys.lastDigestDate) == todayKey) return;
    await db.setSetting(Keys.lastDigestDate, todayKey);

    final pending = await followUps.pending();
    final today = pending.where((f) => DateUtilsX.isToday(f.dueAt)).length;
    final overdue = pending.where((f) => DateUtilsX.isPastDay(f.dueAt)).length;
    final meetings = pending.where((f) => f.hasTime && DateUtilsX.isToday(f.dueAt)).length;
    if (today + overdue == 0) return;
    final parts = <String>[
      if (meetings > 0) Fmt.plural(meetings, 'meeting'),
      if (today - meetings > 0) '${today - meetings} follow-ups due today',
      if (overdue > 0) '$overdue overdue',
    ];
    await _emit(ReminderEvent(
      kind: NotificationKind.info,
      title: 'Good morning${s.myName.isNotEmpty ? ', ${s.myName.split(' ').first}' : ''} ☀️ Your day at a glance',
      body: parts.join(' · '),
      entityType: EntityType.followUp,
    ));
  }

  // ---------------------------------------------------------------- sheets
  Future<void> _pollSheets() async {
    final s = settings();
    if (!s.sheetsAutoImport || s.sheetsSpreadsheetId.isEmpty || !googleAuth.isConnected) return;
    final now = DateTime.now();
    if (_lastSheetsPoll != null && now.difference(_lastSheetsPoll!).inMinutes < s.sheetsIntervalMinutes) return;
    _lastSheetsPoll = now;
    try {
      final result = await sheetsImport.importAll(s.sheetsSpreadsheetId, formResponsesOnly: true);
      await db.setSetting(Keys.sheetsLastImportAt, now.toIso8601String());
      if (result.formLeads > 0) {
        await _emit(ReminderEvent(
          kind: NotificationKind.success,
          title: '${Fmt.plural(result.formLeads, 'new lead')} from your Google Form',
          body: 'Imported automatically — first follow-up already scheduled.',
          entityType: EntityType.lead,
        ));
      }
    } catch (e) {
      debugPrint('Sheets poll failed: $e');
    }
  }

  /// Mobile cannot run this scheduler in the background, so upcoming reminders
  /// are pre-registered as local notifications (next 30 days). Re-planned
  /// whenever the set of pending follow-ups changes.
  Future<void> planMobileNotifications() async {
    if (!AppPlatform.schedulesNotifications) return;
    final s = settings();
    final now = DateTime.now();
    final horizon = now.add(const Duration(days: 30));
    final pending = (await followUps.pending()).where((f) => f.dueAt.isAfter(now.subtract(const Duration(days: 1))) && f.dueAt.isBefore(horizon)).toList();
    final signature = '${s.dailyReminderTime}|${s.meetingLeadMinutes}|${pending.map((f) => '${f.id}:${f.dueAt.millisecondsSinceEpoch}:${f.hasTime}').join(',')}';
    if (signature == _lastPlanSignature) return;
    _lastPlanSignature = signature;

    await notifications.cancelScheduled();
    final byDay = <DateTime, List<FollowUp>>{};
    for (final fu in pending) {
      if (fu.hasTime) {
        final who = await _who(fu);
        await notifications.schedule(
          id: NotificationService.idFor('meeting:${fu.id}'),
          when: fu.dueAt.subtract(Duration(minutes: s.meetingLeadMinutes)),
          title: 'Meeting in ${s.meetingLeadMinutes} min · ${fu.title}',
          body: [who, Fmt.time(fu.dueAt)].where((e) => e.isNotEmpty).join(' · '),
          payload: fu.leadId != null ? 'lead:${fu.leadId}' : 'followup:${fu.id}',
        );
      } else {
        byDay.putIfAbsent(DateUtilsX.startOfDay(fu.dueAt), () => []).add(fu);
      }
    }
    for (final entry in byDay.entries) {
      final at = _dailyAt(entry.key, s);
      final list = entry.value;
      if (list.length == 1) {
        final who = await _who(list.first);
        await notifications.schedule(
          id: NotificationService.idFor('day:${entry.key.toIso8601String()}'),
          when: at,
          title: 'Follow-up today · ${list.first.title}',
          body: who,
          payload: list.first.leadId != null ? 'lead:${list.first.leadId}' : 'followup:${list.first.id}',
        );
      } else {
        await notifications.schedule(
          id: NotificationService.idFor('day:${entry.key.toIso8601String()}'),
          when: at,
          title: '${list.length} follow-ups due today',
          body: list.take(3).map((f) => f.title).join(' · '),
          payload: 'followups',
        );
      }
    }
  }

  /// Runs an import on demand (Settings → Import). Returns the result.
  Future<ImportResult> importNow(String spreadsheetId, {bool formResponsesOnly = false}) async {
    final r = await sheetsImport.importAll(spreadsheetId, formResponsesOnly: formResponsesOnly);
    await db.setSetting(Keys.sheetsLastImportAt, DateTime.now().toIso8601String());
    _lastSheetsPoll = DateTime.now();
    return r;
  }

  void dispose() {
    stop();
    _events.close();
  }
}
