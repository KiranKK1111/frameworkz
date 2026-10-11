import 'dart:convert';

import '../domain/enums.dart';

/// Typed, immutable view over the key/value settings table.
///
/// All keys are centralised here so the UI, automation and services agree on
/// names and defaults. Secrets (OAuth tokens) are NOT settings — they live in
/// the OS keychain via flutter_secure_storage.
class AppSettingsState {
  const AppSettingsState(this._raw);

  final Map<String, String> _raw;

  String _s(String key, String def) => _raw[key] ?? def;
  bool _b(String key, bool def) => _raw.containsKey(key) ? _raw[key] == 'true' : def;
  int _i(String key, int def) => int.tryParse(_raw[key] ?? '') ?? def;

  // ----------------------------------------------------------------- profile
  String get myName => _s(Keys.profileName, '');
  String get businessName => _s(Keys.profileBusiness, 'FrameWorkz');
  String get myPhone => _s(Keys.profilePhone, '');
  String get myEmail => _s(Keys.profileEmail, '');
  String get myWebsite => _s(Keys.profileWebsite, '');
  String get myInstagram => _s(Keys.profileInstagram, '');
  String get signature => _s(Keys.profileSignature, '');
  bool get onboardingDone => _b(Keys.onboardingDone, false);

  // ------------------------------------------------------------------- rules
  /// Days until the next follow-up after a status change. `null` = no follow-up.
  Map<LeadStatus, int?> get followUpRules {
    final raw = _raw[Keys.followUpRules];
    final result = Map<LeadStatus, int?>.from(defaultFollowUpRules);
    if (raw == null) return result;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      for (final s in LeadStatus.values) {
        if (decoded.containsKey(s.name)) {
          final v = decoded[s.name];
          result[s] = v == null ? null : (v as num).toInt();
        }
      }
    } catch (_) {}
    return result;
  }

  static const Map<LeadStatus, int?> defaultFollowUpRules = {
    LeadStatus.newLead: 0,
    LeadStatus.contacted: 2,
    LeadStatus.replied: 1,
    LeadStatus.callScheduled: null,
    LeadStatus.proposalSent: 3,
    LeadStatus.negotiation: 2,
    LeadStatus.nurture: 14,
    LeadStatus.won: null,
    LeadStatus.lost: null,
  };

  static String encodeRules(Map<LeadStatus, int?> rules) => jsonEncode({for (final e in rules.entries) e.key.name: e.value});

  /// Hour of day used for all-day follow-up reminders and calendar blocks.
  int get followUpHour => _i(Keys.followUpHour, 10);

  // --------------------------------------------------------------- reminders
  /// "HH:mm" when the daily follow-up digest fires.
  String get dailyReminderTime => _s(Keys.dailyReminderTime, '09:30');
  int get meetingLeadMinutes => _i(Keys.meetingLeadMinutes, 15);
  bool get osNotifications => _b(Keys.osNotifications, true);
  bool get overdueDigest => _b(Keys.overdueDigest, true);

  // ------------------------------------------------------------------ google
  String get googleClientId => _s(Keys.googleClientId, '');
  String get googleClientSecret => _s(Keys.googleClientSecret, '');
  String get googleEmail => _s(Keys.googleEmail, '');
  String get googleMobileClientId => _s(Keys.googleMobileClientId, '');
  bool get googleConfigured => googleClientId.isNotEmpty;
  String get calendarId => _s(Keys.calendarId, 'primary');
  bool get calendarSync => _b(Keys.calendarSync, true);
  bool get calendarInviteContacts => _b(Keys.calendarInviteContacts, false);
  bool get calendarCreateMeet => _b(Keys.calendarCreateMeet, true);
  bool get gmailEnabled => _b(Keys.gmailEnabled, true);
  String get timeZone => _s(Keys.timeZone, 'Asia/Kolkata');

  // ------------------------------------------------------------------ sheets
  String get sheetsSpreadsheetId => _s(Keys.sheetsSpreadsheetId, '');
  bool get sheetsAutoImport => _b(Keys.sheetsAutoImport, false);
  int get sheetsIntervalMinutes => _i(Keys.sheetsIntervalMinutes, 10);
  DateTime? get sheetsLastImportAt => DateTime.tryParse(_raw[Keys.sheetsLastImportAt] ?? '');

  // --------------------------------------------------------------------- app
  String get themeMode => _s(Keys.themeMode, 'system');
  bool get minimizeToTray => _b(Keys.minimizeToTray, true);
  bool get launchAtStartup => _b(Keys.launchAtStartup, false);
  bool get sidebarCollapsed => _b(Keys.sidebarCollapsed, false);
  String get currency => _s(Keys.currency, 'INR');

  String? raw(String key) => _raw[key];
}

/// Setting key constants.
class Keys {
  Keys._();
  static const profileName = 'profile.name';
  static const profileBusiness = 'profile.business';
  static const profilePhone = 'profile.phone';
  static const profileEmail = 'profile.email';
  static const profileWebsite = 'profile.website';
  static const profileInstagram = 'profile.instagram';
  static const profileSignature = 'profile.signature';
  static const onboardingDone = 'app.onboardingDone';

  static const followUpRules = 'rules.followUpDays';
  static const followUpHour = 'rules.followUpHour';

  static const dailyReminderTime = 'reminders.dailyTime';
  static const meetingLeadMinutes = 'reminders.meetingLeadMinutes';
  static const osNotifications = 'reminders.osNotifications';
  static const overdueDigest = 'reminders.overdueDigest';
  static const lastDigestDate = 'reminders.lastDigestDate';

  static const googleClientId = 'google.clientId';
  static const googleClientSecret = 'google.clientSecret';
  static const googleEmail = 'google.connectedEmail';
  static const googleMobileClientId = 'google.mobileClientId';
  static const calendarId = 'google.calendarId';
  static const calendarSync = 'google.calendarSync';
  static const calendarInviteContacts = 'google.calendarInviteContacts';
  static const calendarCreateMeet = 'google.calendarCreateMeet';
  static const gmailEnabled = 'google.gmailEnabled';
  static const timeZone = 'google.timeZone';

  static const sheetsSpreadsheetId = 'sheets.spreadsheetId';
  static const sheetsAutoImport = 'sheets.autoImport';
  static const sheetsIntervalMinutes = 'sheets.intervalMinutes';
  static const sheetsLastImportAt = 'sheets.lastImportAt';

  static const themeMode = 'app.theme';
  static const minimizeToTray = 'app.minimizeToTray';
  static const launchAtStartup = 'app.launchAtStartup';
  static const sidebarCollapsed = 'app.sidebarCollapsed';
  static const currency = 'app.currency';
}
