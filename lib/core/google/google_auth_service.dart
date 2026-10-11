import 'dart:async';
import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:googleapis/drive/v3.dart' as gdrive;
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis/sheets/v4.dart' as gsheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../platform.dart';

/// Connection state surfaced to the UI.
@immutable
class GoogleAuthState {
  const GoogleAuthState({this.connected = false, this.busy = false, this.email, this.error});

  final bool connected;
  final bool busy;
  final String? email;
  final String? error;

  GoogleAuthState copyWith({bool? connected, bool? busy, String? email, String? error, bool clearError = false}) => GoogleAuthState(
        connected: connected ?? this.connected,
        busy: busy ?? this.busy,
        email: email ?? this.email,
        error: clearError ? null : (error ?? this.error),
      );
}

/// Google OAuth on every platform.
///
/// * Desktop (Windows/macOS/Linux): loopback flow with a "Desktop app" OAuth
///   client; refresh token kept in the OS keychain / DPAPI.
/// * Mobile (Android/iOS): native Google Sign-In; tokens are managed by the
///   Google SDK and re-authorised silently when they expire.
class GoogleAuthService {
  GoogleAuthService({
    required this.readClientId,
    required this.readClientSecret,
    required this.readMobileClientId,
    required this.readServerClientId,
    required this.onEmailResolved,
  });

  final String Function() readClientId;
  final String Function() readClientSecret;

  /// iOS client id (Android resolves its client from the SHA-1 fingerprint).
  final String Function() readMobileClientId;

  /// "Web application" client id from the same Google Cloud project; Android
  /// requires it as serverClientId.
  final String Function() readServerClientId;
  final Future<void> Function(String email) onEmailResolved;

  static const _credsKey = 'google.credentials';
  // macOS: the data-protection keychain needs a Developer-ID-signed app and
  // fails with -34018 on ad-hoc signed builds, so use the classic login
  // keychain there. Windows (DPAPI), Android and iOS are unaffected.
  static const _storage = FlutterSecureStorage(mOptions: MacOsOptions(usesDataProtectionKeychain: false));

  /// Everything FrameWorkz may touch. Requested once at sign-in so later
  /// features (Slides proposals, YouTube uploads, Sheets mirroring) never
  /// need a second consent. Register exactly this list on the OAuth consent
  /// screen ("Data access") in Google Cloud.
  static const List<String> scopes = [
    gcal.CalendarApi.calendarEventsScope, // events + Meet links (conferenceData)
    gmail.GmailApi.gmailSendScope, // send templated emails
    gsheets.SheetsApi.spreadsheetsScope, // read the form sheet, write sheets
    'https://www.googleapis.com/auth/presentations', // Slides: proposal decks
    gdrive.DriveApi.driveFileScope, // files/folders FrameWorkz creates
    'https://www.googleapis.com/auth/youtube.readonly', // channel & video stats
    'https://www.googleapis.com/auth/youtube.upload', // publish deliverables
    'https://www.googleapis.com/auth/userinfo.email',
    'openid',
  ];

  /// Human-readable list for the settings screen.
  static const List<(String, String)> scopeSummary = [
    ('Calendar', 'create and update events, add Google Meet links'),
    ('Gmail', 'send emails from your address'),
    ('Sheets', 'read your form responses, write sheets'),
    ('Slides', 'create presentations (proposals)'),
    ('Drive', 'create and manage files and folders made by FrameWorkz'),
    ('YouTube', 'read channel statistics, upload videos'),
  ];

  final ValueNotifier<GoogleAuthState> state = ValueNotifier(const GoogleAuthState());

  AuthClient? _client;
  http.Client? _base;
  StreamSubscription<AccessCredentials>? _updates;
  DateTime? _mobileAuthorizedAt;
  bool _mobileInitialized = false;

  bool get isConnected => state.value.connected && _client != null;

  /// Whether sign-in can be attempted.
  bool get isConfigured => AppPlatform.isAndroid
      ? readServerClientId().isNotEmpty
      : (AppPlatform.isIOS ? true : readClientId().isNotEmpty);

  // ------------------------------------------------------------------ restore
  Future<void> restore({String? knownEmail}) async {
    if (AppPlatform.usesGoogleSignIn) return _restoreMobile(knownEmail);
    final id = readClientId();
    final secret = readClientSecret();
    if (id.isEmpty) return;
    try {
      final raw = await _storage.read(key: _credsKey);
      if (raw == null) return;
      final creds = AccessCredentials.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (creds.refreshToken == null) return;
      _base = http.Client();
      final client = autoRefreshingClient(ClientId(id, secret.isEmpty ? null : secret), creds, _base!);
      _client = client;
      _updates?.cancel();
      _updates = client.credentialUpdates.listen((c) => _persist(c).catchError((_) {}));
      state.value = GoogleAuthState(connected: true, email: knownEmail);
      if (knownEmail == null || knownEmail.isEmpty) unawaited(_resolveEmail());
    } catch (e) {
      debugPrint('Google restore failed: $e');
      state.value = const GoogleAuthState(connected: false, error: 'Stored Google session could not be restored.');
    }
  }

  Future<void> _initMobile() async {
    if (_mobileInitialized) return;
    final iosClient = readMobileClientId();
    final serverClient = readServerClientId();
    if (AppPlatform.isAndroid && serverClient.isEmpty) {
      throw StateError('Add the Web client ID (serverClientId) in Settings → Google account first.');
    }
    await GoogleSignIn.instance.initialize(
      clientId: AppPlatform.isIOS && iosClient.isNotEmpty ? iosClient : null,
      serverClientId: serverClient.isNotEmpty ? serverClient : null,
    );
    _mobileInitialized = true;
  }

  Future<void> _restoreMobile(String? knownEmail) async {
    if (!isConfigured) return;
    try {
      await _initMobile();
      final account = await GoogleSignIn.instance.attemptLightweightAuthentication();
      if (account == null) return;
      final authz = await account.authorizationClient.authorizationForScopes(scopes);
      if (authz == null) return;
      _client = authz.authClient(scopes: scopes);
      _mobileAuthorizedAt = DateTime.now();
      state.value = GoogleAuthState(connected: true, email: account.email);
      await onEmailResolved(account.email);
    } catch (e) {
      debugPrint('Google mobile restore failed: $e');
    }
  }

  // ------------------------------------------------------------------ connect
  Future<bool> connect() async {
    if (AppPlatform.usesGoogleSignIn) return _connectMobile();
    final id = readClientId();
    final secret = readClientSecret();
    if (id.isEmpty) {
      state.value = state.value.copyWith(error: 'Add your Google OAuth Client ID in Settings first.');
      return false;
    }
    state.value = state.value.copyWith(busy: true, clearError: true);
    try {
      await disconnect(silent: true);
      _base = http.Client();
      final client = await clientViaUserConsent(
        ClientId(id, secret.isEmpty ? null : secret),
        scopes,
        (url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
        baseClient: _base,
      ).timeout(const Duration(minutes: 5));
      _client = client;
      // Saving the token can fail on a Mac build that is not signed with a
      // Developer ID (Keychain refuses, code -34018). Stay signed in for this
      // session rather than failing the whole sign-in.
      String? warning;
      try {
        await _persist(client.credentials);
        _updates?.cancel();
        _updates = client.credentialUpdates.listen((c) => _persist(c).catchError((_) {}));
      } catch (e) {
        debugPrint('Could not store Google credentials: $e');
        warning = 'Signed in for this session only — this computer could not save the login, so you will need to connect again after restarting.';
      }
      state.value = GoogleAuthState(connected: true, busy: false, error: warning);
      await _resolveEmail();
      return true;
    } on TimeoutException {
      state.value = const GoogleAuthState(connected: false, error: 'Sign-in timed out. Please try again.');
      return false;
    } catch (e) {
      state.value = GoogleAuthState(connected: false, error: _friendly(e));
      return false;
    }
  }

  Future<bool> _connectMobile() async {
    state.value = state.value.copyWith(busy: true, clearError: true);
    try {
      await _initMobile();
      final account = await GoogleSignIn.instance.authenticate(scopeHint: scopes);
      final authz = await account.authorizationClient.authorizeScopes(scopes);
      _client = authz.authClient(scopes: scopes);
      _mobileAuthorizedAt = DateTime.now();
      state.value = GoogleAuthState(connected: true, busy: false, email: account.email);
      await onEmailResolved(account.email);
      return true;
    } catch (e) {
      state.value = GoogleAuthState(connected: false, error: _friendly(e));
      return false;
    }
  }

  // --------------------------------------------------------------- disconnect
  Future<void> disconnect({bool silent = false}) async {
    await _updates?.cancel();
    _updates = null;
    if (AppPlatform.usesGoogleSignIn) {
      try {
        if (_mobileInitialized && !silent) await GoogleSignIn.instance.signOut();
      } catch (_) {}
      _client = null;
      if (!silent) state.value = const GoogleAuthState();
      return;
    }
    final token = _client?.credentials.accessToken.data;
    _client?.close();
    _client = null;
    _base?.close();
    _base = null;
    await _storage.delete(key: _credsKey);
    if (token != null && !silent) {
      try {
        await http.post(Uri.parse('https://oauth2.googleapis.com/revoke'), body: {'token': token});
      } catch (_) {}
    }
    if (!silent) state.value = const GoogleAuthState();
  }

  // ------------------------------------------------------------------ clients
  /// Call before using an API on mobile: refreshes the short-lived token
  /// silently when it is older than ~45 minutes. No-op on desktop (the
  /// auto-refreshing client handles it).
  Future<void> ensureFresh() async {
    if (!AppPlatform.usesGoogleSignIn || _client == null) return;
    final at = _mobileAuthorizedAt;
    if (at != null && DateTime.now().difference(at).inMinutes < 45) return;
    try {
      final account = await GoogleSignIn.instance.attemptLightweightAuthentication();
      final authz = await account?.authorizationClient.authorizationForScopes(scopes);
      if (authz != null) {
        _client = authz.authClient(scopes: scopes);
        _mobileAuthorizedAt = DateTime.now();
      }
    } catch (e) {
      debugPrint('Token refresh failed: $e');
    }
  }

  AuthClient requireClient() {
    final c = _client;
    if (c == null) throw StateError('Google account is not connected.');
    return c;
  }

  gcal.CalendarApi get calendar => gcal.CalendarApi(requireClient());
  gmail.GmailApi get gmailApi => gmail.GmailApi(requireClient());
  gsheets.SheetsApi get sheets => gsheets.SheetsApi(requireClient());
  gdrive.DriveApi get drive => gdrive.DriveApi(requireClient());

  Future<void> _persist(AccessCredentials creds) async {
    try {
      await _storage.write(key: _credsKey, value: jsonEncode(creds.toJson()));
    } catch (e) {
      // Token refreshes keep working in memory; only persistence is lost.
      debugPrint('Could not store Google credentials: $e');
      rethrow;
    }
  }

  Future<void> _resolveEmail() async {
    try {
      final res = await requireClient().get(Uri.parse('https://openidconnect.googleapis.com/v1/userinfo'));
      if (res.statusCode == 200) {
        final email = (jsonDecode(res.body) as Map<String, dynamic>)['email'] as String?;
        if (email != null) {
          state.value = state.value.copyWith(email: email, busy: false);
          await onEmailResolved(email);
        }
      }
    } catch (e) {
      debugPrint('userinfo failed: $e');
    }
  }

  String _friendly(Object e) {
    final s = e.toString();
    if (s.contains('access_denied') || s.contains('canceled') || s.contains('cancelled')) return 'You cancelled the Google sign-in.';
    if (s.contains('invalid_client')) return 'Google rejected the Client ID / Secret. Check Settings → Google.';
    if (s.contains('redirect_uri_mismatch')) return 'OAuth client must be of type "Desktop app".';
    if (s.contains('DEVELOPER_ERROR') || s.contains('10:')) return 'Android OAuth client missing: add this app\'s SHA-1 fingerprint in Google Cloud Console.';
    return 'Google sign-in failed: $s';
  }

  void dispose() {
    _updates?.cancel();
    _client?.close();
    _base?.close();
    state.dispose();
  }
}
