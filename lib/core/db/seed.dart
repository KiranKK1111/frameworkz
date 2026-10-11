import 'package:drift/drift.dart';

import '../email/default_templates.dart';
import '../settings/app_settings.dart';
import 'database.dart';

/// First-run seeding: default email templates and sensible settings.
Future<void> seedDefaults(AppDatabase db) async {
  final existing = await db.select(db.emailTemplates).get();
  if (existing.isEmpty) {
    await db.batch((b) => b.insertAll(db.emailTemplates, defaultEmailTemplates(), mode: InsertMode.insertOrIgnore));
  }

  Future<void> def(String key, String value) async {
    if (await db.getSetting(key) == null) await db.setSetting(key, value);
  }

  await def(Keys.followUpRules, AppSettingsState.encodeRules(AppSettingsState.defaultFollowUpRules));
  await def(Keys.sheetsSpreadsheetId, '1J1wXh1wmWYDSylUFQnc6lUgL5_Jm6UKVVPQo9jETAjI');
  await def(Keys.dailyReminderTime, '09:30');
  await def(Keys.meetingLeadMinutes, '15');
  await def(Keys.themeMode, 'system');
}

/// Re-inserts any built-in template that was deleted (keeps user edits).
Future<int> restoreMissingTemplates(AppDatabase db) async {
  final existing = (await db.select(db.emailTemplates).get()).map((t) => t.id).toSet();
  final missing = defaultEmailTemplates().where((t) => !existing.contains(t.id.value)).toList();
  if (missing.isEmpty) return 0;
  await db.batch((b) => b.insertAll(db.emailTemplates, missing, mode: InsertMode.insertOrIgnore));
  return missing.length;
}
