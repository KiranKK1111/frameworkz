import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'automation/lead_automation.dart';
import 'automation/scheduler.dart';
import 'db/database.dart';
import 'db/repos.dart';
import 'google/calendar_service.dart';
import 'google/gmail_service.dart';
import 'google/google_auth_service.dart';
import 'google/sheets_import_service.dart';
import 'notifications/notification_service.dart';
import 'settings/app_settings.dart';
import 'utils/format.dart';

export 'automation/lead_automation.dart';
export 'automation/scheduler.dart';
export 'db/database.dart';
export 'db/repos.dart';
export 'google/calendar_service.dart';
export 'google/gmail_service.dart';
export 'google/google_auth_service.dart';
export 'google/sheets_import_service.dart';
export 'notifications/notification_service.dart';
export 'settings/app_settings.dart';

// ----------------------------------------------------------------- database
final databaseProvider = Provider<AppDatabase>((ref) => throw UnimplementedError('databaseProvider must be overridden in main()'));

final leadsRepoProvider = Provider((ref) => LeadsRepo(ref.watch(databaseProvider)));
final clientsRepoProvider = Provider((ref) => ClientsRepo(ref.watch(databaseProvider)));
final projectsRepoProvider = Provider((ref) => ProjectsRepo(ref.watch(databaseProvider)));
final followUpsRepoProvider = Provider((ref) => FollowUpsRepo(ref.watch(databaseProvider)));
final invoicesRepoProvider = Provider((ref) => InvoicesRepo(ref.watch(databaseProvider)));
final templatesRepoProvider = Provider((ref) => TemplatesRepo(ref.watch(databaseProvider)));
final emailLogsRepoProvider = Provider((ref) => EmailLogsRepo(ref.watch(databaseProvider)));

// ----------------------------------------------------------------- settings
/// Holds the latest settings independently of widget listeners.
///
/// Riverpod 3 pauses stream providers that nobody listens to, so background
/// services (scheduler, Google auth) read from this store instead of a provider.
class SettingsStore {
  SettingsStore(AppDatabase db) {
    _sub = db.watchSettings().listen((map) {
      _current = AppSettingsState(map);
      if (!_ready.isCompleted) _ready.complete();
      _ctrl.add(_current);
    });
  }

  AppSettingsState _current = const AppSettingsState({});
  final _ctrl = StreamController<AppSettingsState>.broadcast();
  final _ready = Completer<void>();
  StreamSubscription<Map<String, String>>? _sub;

  AppSettingsState get current => _current;
  Stream<AppSettingsState> get stream => _ctrl.stream;

  /// Completes once the first snapshot has been loaded from the database.
  Future<void> get ready => _ready.future;

  void dispose() {
    _sub?.cancel();
    _ctrl.close();
  }
}

final settingsStoreProvider = Provider<SettingsStore>((ref) {
  final store = SettingsStore(ref.watch(databaseProvider));
  ref.onDispose(store.dispose);
  return store;
});

final settingsProvider = StreamProvider<AppSettingsState>((ref) async* {
  final store = ref.watch(settingsStoreProvider);
  await store.ready;
  yield store.current;
  yield* store.stream;
});

/// Synchronous snapshot (always populated once the store is ready).
final settingsSnapshotProvider = Provider<AppSettingsState>((ref) {
  return ref.watch(settingsProvider).value ?? ref.watch(settingsStoreProvider).current;
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  return switch (ref.watch(settingsSnapshotProvider).themeMode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});

// ----------------------------------------------------------------- services
final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());

final googleAuthProvider = Provider<GoogleAuthService>((ref) {
  final db = ref.watch(databaseProvider);
  final svc = GoogleAuthService(
    readClientId: () => ref.read(settingsStoreProvider).current.googleClientId,
    readClientSecret: () => ref.read(settingsStoreProvider).current.googleClientSecret,
    readMobileClientId: () => ref.read(settingsStoreProvider).current.googleMobileClientId,
    onEmailResolved: (email) => db.setSetting(Keys.googleEmail, email),
  );
  ref.onDispose(svc.dispose);
  return svc;
});

/// Reactive view of the Google connection.
final googleAuthStateProvider = StreamProvider<GoogleAuthState>((ref) {
  final svc = ref.watch(googleAuthProvider);
  final ctrl = StreamController<GoogleAuthState>();
  void push() => ctrl.add(svc.state.value);
  svc.state.addListener(push);
  ref.onDispose(() {
    svc.state.removeListener(push);
    ctrl.close();
  });
  push();
  return ctrl.stream;
});

final calendarServiceProvider = Provider<CalendarService>((ref) {
  return CalendarService(ref.watch(googleAuthProvider), () => ref.read(settingsStoreProvider).current);
});

final gmailServiceProvider = Provider<GmailService>((ref) => GmailService(ref.watch(googleAuthProvider)));

final automationProvider = Provider<LeadAutomation>((ref) {
  return LeadAutomation(
    db: ref.watch(databaseProvider),
    leads: ref.watch(leadsRepoProvider),
    followUps: ref.watch(followUpsRepoProvider),
    clients: ref.watch(clientsRepoProvider),
    projects: ref.watch(projectsRepoProvider),
    templates: ref.watch(templatesRepoProvider),
    calendar: ref.watch(calendarServiceProvider),
    settings: () => ref.read(settingsStoreProvider).current,
  );
});

final sheetsImportProvider = Provider<SheetsImportService>((ref) {
  final automation = ref.watch(automationProvider);
  return SheetsImportService(
    auth: ref.watch(googleAuthProvider),
    db: ref.watch(databaseProvider),
    leads: ref.watch(leadsRepoProvider),
    clients: ref.watch(clientsRepoProvider),
    projects: ref.watch(projectsRepoProvider),
    followUps: ref.watch(followUpsRepoProvider),
    invoices: ref.watch(invoicesRepoProvider),
    onNewLead: (lead) async => automation.ensureInitialFollowUp(lead),
  );
});

final schedulerProvider = Provider<AutomationScheduler>((ref) {
  final s = AutomationScheduler(
    db: ref.watch(databaseProvider),
    followUps: ref.watch(followUpsRepoProvider),
    leads: ref.watch(leadsRepoProvider),
    clients: ref.watch(clientsRepoProvider),
    invoices: ref.watch(invoicesRepoProvider),
    settings: () => ref.read(settingsStoreProvider).current,
    notifications: ref.watch(notificationServiceProvider),
    sheetsImport: ref.watch(sheetsImportProvider),
    googleAuth: ref.watch(googleAuthProvider),
  );
  ref.onDispose(s.dispose);
  return s;
});

// -------------------------------------------------------------- data streams
final leadsProvider = StreamProvider<List<Lead>>((ref) => ref.watch(leadsRepoProvider).watchAll());
final leadProvider = StreamProvider.family<Lead?, String>((ref, id) => ref.watch(leadsRepoProvider).watchById(id));
final clientsProvider = StreamProvider<List<Client>>((ref) => ref.watch(clientsRepoProvider).watchAll());
final clientProvider = StreamProvider.family<Client?, String>((ref, id) => ref.watch(clientsRepoProvider).watchById(id));
final projectsProvider = StreamProvider<List<Project>>((ref) => ref.watch(projectsRepoProvider).watchAll());
final clientProjectsProvider = StreamProvider.family<List<Project>, String>((ref, id) => ref.watch(projectsRepoProvider).watchForClient(id));
final invoicesProvider = StreamProvider<List<Invoice>>((ref) => ref.watch(invoicesRepoProvider).watchAll());
final clientInvoicesProvider = StreamProvider.family<List<Invoice>, String>((ref, id) => ref.watch(invoicesRepoProvider).watchForClient(id));
final pendingFollowUpsProvider = StreamProvider<List<FollowUp>>((ref) => ref.watch(followUpsRepoProvider).watchPending());
final allFollowUpsProvider = StreamProvider<List<FollowUp>>((ref) => ref.watch(followUpsRepoProvider).watchAll());
final leadFollowUpsProvider = StreamProvider.family<List<FollowUp>, String>((ref, id) => ref.watch(followUpsRepoProvider).watchForLead(id));
final clientFollowUpsProvider = StreamProvider.family<List<FollowUp>, String>((ref, id) => ref.watch(followUpsRepoProvider).watchForClient(id));
final templatesProvider = StreamProvider<List<EmailTemplate>>((ref) => ref.watch(templatesRepoProvider).watchAll());
final notificationsProvider = StreamProvider<List<AppNotification>>((ref) => ref.watch(databaseProvider).watchNotifications());
final unreadCountProvider = StreamProvider<int>((ref) => ref.watch(databaseProvider).watchUnreadCount());
final recentActivityProvider = StreamProvider<List<Activity>>((ref) => ref.watch(databaseProvider).watchRecentActivities());

final activitiesProvider = StreamProvider.family<List<Activity>, (EntityType, String)>(
  (ref, key) => ref.watch(databaseProvider).watchActivities(key.$1, key.$2),
);
final emailLogsProvider = StreamProvider.family<List<EmailLog>, (EntityType, String)>(
  (ref, key) => ref.watch(emailLogsRepoProvider).watchFor(key.$1, key.$2),
);

// ------------------------------------------------------------------ derived
/// Quick lookups by id for list rendering.
final clientsByIdProvider = Provider<Map<String, Client>>((ref) {
  final list = ref.watch(clientsProvider).value ?? const [];
  return {for (final c in list) c.id: c};
});

final leadsByIdProvider = Provider<Map<String, Lead>>((ref) {
  final list = ref.watch(leadsProvider).value ?? const [];
  return {for (final l in list) l.id: l};
});

final projectsByIdProvider = Provider<Map<String, Project>>((ref) {
  final list = ref.watch(projectsProvider).value ?? const [];
  return {for (final p in list) p.id: p};
});

/// Counts shown in the sidebar badges.
class AgendaCounts {
  const AgendaCounts({this.overdue = 0, this.today = 0, this.meetingsToday = 0});
  final int overdue;
  final int today;
  final int meetingsToday;
  int get attention => overdue + today;
}

final agendaCountsProvider = Provider<AgendaCounts>((ref) {
  final pending = ref.watch(pendingFollowUpsProvider).value ?? const [];
  var overdue = 0, today = 0, meetings = 0;
  for (final f in pending) {
    if (DateUtilsX.isPastDay(f.dueAt)) {
      overdue++;
    } else if (DateUtilsX.isToday(f.dueAt)) {
      today++;
      if (f.hasTime) meetings++;
    }
  }
  return AgendaCounts(overdue: overdue, today: today, meetingsToday: meetings);
});

class DashboardStats {
  const DashboardStats({
    required this.openLeads,
    required this.newThisWeek,
    required this.pipelineValue,
    required this.wonThisMonth,
    required this.activeClients,
    required this.outstanding,
    required this.overdueInvoices,
    required this.collectedThisMonth,
    required this.openProjects,
    required this.byStatus,
  });
  final int openLeads;
  final int newThisWeek;
  final double pipelineValue;
  final int wonThisMonth;
  final int activeClients;
  final double outstanding;
  final int overdueInvoices;
  final double collectedThisMonth;
  final int openProjects;
  final Map<LeadStatus, int> byStatus;
}

final dashboardStatsProvider = Provider<DashboardStats>((ref) {
  final leads = ref.watch(leadsProvider).value ?? const [];
  final clients = ref.watch(clientsProvider).value ?? const [];
  final invoices = ref.watch(invoicesProvider).value ?? const [];
  final projects = ref.watch(projectsProvider).value ?? const [];
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  final monthStart = DateUtilsX.startOfMonth(now);

  final byStatus = {for (final s in LeadStatus.values) s: 0};
  double pipeline = 0;
  int open = 0, newWeek = 0, won = 0;
  for (final l in leads) {
    byStatus[l.status] = (byStatus[l.status] ?? 0) + 1;
    if (l.status.isOpen) {
      open++;
      pipeline += l.potentialValue;
    }
    if (l.dateAdded.isAfter(weekAgo)) newWeek++;
    if (l.status == LeadStatus.won && l.updatedAt.isAfter(monthStart)) won++;
  }
  double outstanding = 0, collected = 0;
  int overdue = 0;
  for (final i in invoices) {
    if (i.status.isOutstanding) outstanding += i.amount - i.amountReceived;
    if (i.status == InvoiceStatus.overdue) overdue++;
    if (i.paymentDate != null && i.paymentDate!.isAfter(monthStart)) collected += i.amountReceived;
  }
  return DashboardStats(
    openLeads: open,
    newThisWeek: newWeek,
    pipelineValue: pipeline,
    wonThisMonth: won,
    activeClients: clients.where((c) => c.status == ClientStatus.active || c.status == ClientStatus.onboarding).length,
    outstanding: outstanding,
    overdueInvoices: overdue,
    collectedThisMonth: collected,
    openProjects: projects.where((p) => p.status.isOpen).length,
    byStatus: byStatus,
  );
});

/// Convenience for writing settings.
extension SettingsWriter on WidgetRef {
  Future<void> setSetting(String key, String value) => read(databaseProvider).setSetting(key, value);
}
