import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../domain/enums.dart';
import 'tables.dart';

export '../domain/enums.dart';
export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  Leads,
  Clients,
  Projects,
  FollowUps,
  Invoices,
  Activities,
  EmailTemplates,
  EmailLogs,
  AppSettings,
  AppNotifications,
  Counters,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Allocates the next sequential id for a prefix, e.g. `LD-0001`.
  Future<String> nextId(String prefix) async {
    return transaction(() async {
      final row = await (select(counters)..where((c) => c.name.equals(prefix))).getSingleOrNull();
      final next = (row?.value ?? 0) + 1;
      await into(counters).insertOnConflictUpdate(CountersCompanion(name: Value(prefix), value: Value(next)));
      return '$prefix-${next.toString().padLeft(4, '0')}';
    });
  }

  /// Keeps a counter at least as high as an imported id (`LD-0042` -> 42).
  Future<void> bumpCounter(String prefix, String id) async {
    final match = RegExp(r'(\d+)$').firstMatch(id);
    if (match == null) return;
    final n = int.tryParse(match.group(1)!) ?? 0;
    final row = await (select(counters)..where((c) => c.name.equals(prefix))).getSingleOrNull();
    if ((row?.value ?? 0) < n) {
      await into(counters).insertOnConflictUpdate(CountersCompanion(name: Value(prefix), value: Value(n)));
    }
  }

  // ---------------------------------------------------------------- settings
  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(AppSettingsCompanion(key: Value(key), value: Value(value)));

  Stream<Map<String, String>> watchSettings() =>
      select(appSettings).watch().map((rows) => {for (final r in rows) r.key: r.value});

  // --------------------------------------------------------------- activity
  Future<void> logActivity({
    required EntityType entityType,
    required String entityId,
    required ActivityKind kind,
    required String title,
    String detail = '',
  }) =>
      into(activities).insert(ActivitiesCompanion.insert(
        entityType: entityType,
        entityId: entityId,
        kind: kind,
        title: title,
        detail: Value(detail),
        createdAt: DateTime.now(),
      ));

  Stream<List<Activity>> watchActivities(EntityType type, String id, {int limit = 100}) =>
      (select(activities)
            ..where((a) => a.entityType.equalsValue(type) & a.entityId.equals(id))
            ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
            ..limit(limit))
          .watch();

  Stream<List<Activity>> watchRecentActivities({int limit = 20}) =>
      (select(activities)
            ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
            ..limit(limit))
          .watch();

  // ---------------------------------------------------------- notifications
  Future<int> pushNotification({
    required NotificationKind kind,
    required String title,
    String body = '',
    EntityType? entityType,
    String? entityId,
  }) =>
      into(appNotifications).insert(AppNotificationsCompanion.insert(
        kind: kind,
        title: title,
        body: Value(body),
        entityType: Value(entityType),
        entityId: Value(entityId),
        createdAt: DateTime.now(),
      ));

  Stream<List<AppNotification>> watchNotifications({int limit = 50}) =>
      (select(appNotifications)
            ..orderBy([(n) => OrderingTerm.desc(n.createdAt)])
            ..limit(limit))
          .watch();

  Stream<int> watchUnreadCount() {
    final q = selectOnly(appNotifications)..addColumns([appNotifications.id.count()])..where(appNotifications.readAt.isNull());
    return q.watchSingle().map((r) => r.read(appNotifications.id.count()) ?? 0);
  }

  Future<void> markAllNotificationsRead() =>
      (update(appNotifications)..where((n) => n.readAt.isNull())).write(AppNotificationsCompanion(readAt: Value(DateTime.now())));

  Future<void> clearNotifications() => delete(appNotifications).go();
}

/// Database file lives in the per-user application support directory:
///  * Windows: %APPDATA%\com.frameworkz\frameworkz\frameworkz.sqlite
///  * macOS:   ~/Library/Application Support/com.frameworkz.frameworkz/frameworkz.sqlite
QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'frameworkz',
    native: DriftNativeOptions(
      databasePath: () async {
        final dir = await getApplicationSupportDirectory();
        final folder = Directory(p.join(dir.path, 'FrameWorkz'));
        if (!folder.existsSync()) folder.createSync(recursive: true);
        return p.join(folder.path, 'frameworkz.sqlite');
      },
    ),
  );
}
