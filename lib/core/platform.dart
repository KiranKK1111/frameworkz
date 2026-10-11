import 'dart:io';

import 'package:flutter/foundation.dart';

/// Platform capabilities in one place so feature code never sprinkles
/// `Platform.isX` checks.
class AppPlatform {
  AppPlatform._();

  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Window chrome, tray icon, launch-at-login: desktop only.
  static bool get hasWindowManager => isDesktop;
  static bool get hasTray => isDesktop;

  /// Desktop uses the loopback OAuth flow; mobile uses Google Sign-In.
  static bool get usesGoogleSignIn => isMobile;

  /// Mobile cannot run a background timer, so reminders are pre-scheduled as
  /// local notifications instead.
  static bool get schedulesNotifications => isMobile;
}
