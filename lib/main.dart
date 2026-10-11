import 'dart:io';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:tray_manager/tray_manager.dart' as tray;
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'app/theme/bz_colors.dart';
import 'core/db/seed.dart';
import 'core/platform.dart';
import 'core/providers.dart';
import 'ui/widgets/bz_toast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ---------------------------------------------------------------- window
  if (AppPlatform.hasWindowManager) {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1400, 880),
      minimumSize: Size(420, 640),
      center: true,
      title: 'FrameWorkz',
      backgroundColor: Color(0xFF0B1220),
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // ---------------------------------------------------------------- mobile
  if (AppPlatform.isMobile) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (AppPlatform.isAndroid) {
      // Run at the panel's highest refresh rate (90/120 Hz) for smooth scrolling.
      try {
        await FlutterDisplayMode.setHighRefreshRate();
      } catch (e) {
        debugPrint('Display mode not supported: $e');
      }
    }
  }

  // -------------------------------------------------------------- database
  final db = AppDatabase();
  await _boot('seed database', seedDefaults(db), timeout: const Duration(seconds: 20));

  final container = ProviderContainer(overrides: [databaseProvider.overrideWithValue(db)]);

  // Wait for the first settings snapshot so services read real values.
  await _boot('load settings', container.read(settingsStoreProvider).ready);

  // --------------------------------------------------------- integrations
  final settings = container.read(settingsStoreProvider).current;
  final notifications = container.read(notificationServiceProvider);
  notifications.onTap = (payload) {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null || payload == null) return;
    final parts = payload.split(':');
    switch (parts.first) {
      case 'lead':
        ctx.go(Routes.lead(parts.last));
      case 'client':
        ctx.go(Routes.client(parts.last));
      default:
        ctx.go(Routes.followUps);
    }
  };
  await _boot('notifications', notifications.init(timeZone: settings.timeZone));
  await _boot('google session', container.read(googleAuthProvider).restore(knownEmail: settings.googleEmail));

  // ------------------------------------------------------------- scheduler
  // Excel workbook mirror: writes every change to the user's .xlsx.
  container.read(workbookProvider).start();

  final scheduler = container.read(schedulerProvider);
  scheduler.events.listen((ev) {
    void open() {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx == null) return;
      if (AppPlatform.hasWindowManager) windowManager.show();
      switch (ev.entityType) {
        case EntityType.lead:
          ctx.go(ev.entityId != null ? Routes.lead(ev.entityId!) : Routes.leads);
        case EntityType.client:
          ctx.go(ev.entityId != null ? Routes.client(ev.entityId!) : Routes.clients);
        case EntityType.invoice:
          ctx.go(Routes.finance);
        case EntityType.project:
          ctx.go(Routes.projects);
        case EntityType.followUp:
        case null:
          ctx.go(Routes.followUps);
      }
    }

    switch (ev.kind) {
      case NotificationKind.meeting:
        BzToasts.show(title: ev.title, message: ev.body, variant: BzVariant.primary, icon: BootstrapIcons.camera_video, duration: const Duration(seconds: 12), actionLabel: 'Open', onAction: open);
      case NotificationKind.followUpOverdue:
      case NotificationKind.invoiceOverdue:
        BzToasts.show(title: ev.title, message: ev.body, variant: BzVariant.danger, icon: BootstrapIcons.exclamation_circle, duration: const Duration(seconds: 10), actionLabel: 'Open', onAction: open);
      case NotificationKind.success:
        BzToasts.success(ev.title, message: ev.body, actionLabel: 'Open', onAction: open);
      case NotificationKind.error:
        BzToasts.error(ev.title, message: ev.body);
      default:
        BzToasts.reminder(ev.title, message: ev.body, actionLabel: 'Open', onAction: open);
    }
  });
  scheduler.start();

  runApp(UncontrolledProviderScope(container: container, child: const FrameWorkzApp()));
  debugPrint('[boot] runApp');

  // Non-critical desktop integrations after the first frame.
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    if (AppPlatform.isMobile) {
      // Ask after the intro so the permission sheet does not block boot.
      Future.delayed(const Duration(seconds: 3), notifications.requestPermissions);
      return;
    }
    if (!AppPlatform.isDesktop) return;
    // ---------------------------------------------------------- tray / exit
    final trayController = TrayController(container);
    await _boot('tray', trayController.init());

    // ----------------------------------------------------- launch at login
    try {
      launchAtStartup.setup(appName: 'FrameWorkz', appPath: Platform.resolvedExecutable, packageName: 'com.frameworkz.app');
      if (settings.launchAtStartup) {
        await _boot('launch at startup', launchAtStartup.enable());
      }
    } catch (e) {
      debugPrint('[boot] launchAtStartup failed: $e');
    }
  });
}

/// Runs a boot step with a timeout so one misbehaving plugin can never block
/// the UI from appearing.
Future<T?> _boot<T>(String step, Future<T> future, {Duration timeout = const Duration(seconds: 8)}) async {
  final sw = Stopwatch()..start();
  try {
    final r = await future.timeout(timeout);
    debugPrint('[boot] $step ok (${sw.elapsedMilliseconds} ms)');
    return r;
  } catch (e) {
    debugPrint('[boot] $step FAILED after ${sw.elapsedMilliseconds} ms: $e');
    return null;
  }
}

/// Keeps the app alive in the system tray so reminders keep firing when the
/// window is closed, and offers quick actions from the tray menu.
class TrayController with WindowListener {
  TrayController(this.container);
  final ProviderContainer container;
  tray.TrayIcon? _icon;

  Future<void> init() async {
    windowManager.addListener(this);
    await windowManager.setPreventClose(true);
    try {
      final icon = tray.TrayIcon.create();
      if (icon == null) return;
      _icon = icon;
      icon.icon = tray.ImageAsset.fromAsset('assets/icons/tray_icon.png');
      icon.setTooltip('FrameWorkz');

      final menu = tray.Menu.create();
      if (menu != null) {
        void add(String label, Future<void> Function() action) {
          final item = tray.MenuItem.createWithLabelAndType(label, tray.MenuItemType.normal);
          if (item == null) return;
          item.addListener((e) {
            if (e is tray.MenuItemClickedEvent) action();
          });
          menu.addItem(item);
        }

        add('Open FrameWorkz', _show);
        add("Today's follow-ups", () async {
          await _show();
          rootNavigatorKey.currentContext?.go(Routes.followUps);
        });
        add('New lead…', () async {
          await _show();
          rootNavigatorKey.currentContext?.go('${Routes.leads}?new=1');
        });
        menu.addSeparator();
        add('Quit FrameWorkz', _quit);
        icon.setContextMenu(menu);
      }

      icon.addListener((e) {
        if (e is tray.TrayIconClickedEvent || e is tray.TrayIconDoubleClickedEvent) _show();
        if (e is tray.TrayIconRightClickedEvent) icon.openContextMenu();
      });
      icon.setVisible(true);
    } catch (e) {
      debugPrint('Tray setup failed: $e');
    }
  }

  Future<void> _show() async {
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _quit() async {
    container.read(schedulerProvider).stop();
    try {
      _icon?.setVisible(false);
      _icon?.dispose();
    } catch (_) {}
    await windowManager.setPreventClose(false);
    await windowManager.destroy();
    exit(0);
  }

  @override
  void onWindowClose() async {
    final minimize = container.read(settingsStoreProvider).current.minimizeToTray;
    if (minimize && _icon != null) {
      await windowManager.hide();
      container.read(notificationServiceProvider).show(
            title: 'FrameWorkz is still running',
            body: 'Reminders stay active. Use the tray icon to reopen or quit.',
          );
    } else {
      await _quit();
    }
  }
}
