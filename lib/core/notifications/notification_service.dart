import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../platform.dart';

/// Native notifications on every platform.
///
/// * Desktop: immediate toasts via `local_notifier` (the in-app scheduler
///   decides *when*).
/// * Mobile: `flutter_local_notifications`, with reminders pre-scheduled as
///   zoned notifications so they fire even when the app is closed.
class NotificationService {
  bool _ready = false;
  final FlutterLocalNotificationsPlugin _mobile = FlutterLocalNotificationsPlugin();

  /// Invoked when the user taps a notification; payload is `type:id`.
  void Function(String? payload)? onTap;

  static const _channelId = 'frameworkz_reminders';

  Future<void> init({String timeZone = 'Asia/Kolkata'}) async {
    if (AppPlatform.isDesktop) {
      try {
        await localNotifier.setup(appName: 'FrameWorkz', shortcutPolicy: ShortcutPolicy.requireCreate);
        _ready = true;
      } catch (e) {
        debugPrint('local_notifier setup failed: $e');
      }
      return;
    }
    if (AppPlatform.isMobile) {
      try {
        tzdata.initializeTimeZones();
        try {
          tz.setLocalLocation(tz.getLocation(timeZone));
        } catch (_) {}
        const android = AndroidInitializationSettings('@mipmap/ic_launcher');
        const ios = DarwinInitializationSettings();
        await _mobile.initialize(
          settings: const InitializationSettings(android: android, iOS: ios),
          onDidReceiveNotificationResponse: (r) => onTap?.call(r.payload),
        );
        _ready = true;
      } catch (e) {
        debugPrint('flutter_local_notifications setup failed: $e');
      }
    }
  }

  /// Asks for notification permissions. Called after the first frame so the
  /// system dialog never blocks start-up.
  Future<void> requestPermissions() async {
    if (!AppPlatform.isMobile || !_ready) return;
    try {
      final androidImpl = _mobile.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.requestExactAlarmsPermission();
      await _mobile.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (e) {
      debugPrint('Notification permission request failed: $e');
    }
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Reminders',
          channelDescription: 'Follow-ups, meetings and invoice reminders',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      );

  /// Shows a notification right now.
  Future<void> show({
    required String title,
    String? body,
    VoidCallback? onClick,
    String? payload,
    List<String> actions = const [],
    ValueChanged<int>? onAction,
  }) async {
    if (!_ready) return;
    try {
      if (AppPlatform.isDesktop) {
        final n = LocalNotification(
          title: title,
          body: body,
          actions: actions.isEmpty ? null : actions.map((a) => LocalNotificationAction(text: a)).toList(),
        );
        n.onClick = onClick;
        n.onClickAction = onAction;
        await n.show();
      } else {
        await _mobile.show(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000 % 1000000,
          title: title,
          body: body,
          notificationDetails: _details,
          payload: payload,
        );
      }
    } catch (e) {
      debugPrint('Notification failed: $e');
    }
  }

  /// Schedules a notification at [when] (mobile only; desktop uses the live
  /// scheduler). Ids are stable per entity so re-planning replaces entries.
  Future<void> schedule({required int id, required DateTime when, required String title, String? body, String? payload}) async {
    if (!_ready || !AppPlatform.schedulesNotifications) return;
    if (!when.isAfter(DateTime.now())) return;
    try {
      await _mobile.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Schedule failed: $e');
    }
  }

  Future<void> cancelScheduled() async {
    if (!_ready || !AppPlatform.schedulesNotifications) return;
    try {
      await _mobile.cancelAllPendingNotifications();
    } catch (e) {
      debugPrint('cancelAllPendingNotifications failed: $e');
    }
  }

  /// Stable notification id from a string key.
  static int idFor(String key) => key.hashCode & 0x7fffffff;
}
