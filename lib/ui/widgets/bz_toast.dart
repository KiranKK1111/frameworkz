import 'dart:async';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';

/// A single toast entry.
class BzToastItem {
  BzToastItem({
    required this.id,
    required this.title,
    this.message,
    this.variant = BzVariant.dark,
    this.icon,
    this.duration = const Duration(seconds: 4),
    this.actionLabel,
    this.onAction,
  });

  final int id;
  final String title;
  final String? message;
  final BzVariant variant;
  final IconData? icon;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  bool removing = false;
}

/// Global toast controller. Call `BzToasts.success('Saved')` from anywhere;
/// [BzToastHost] renders the stack bottom-right with slide / fade animations
/// and a shrinking progress bar.
class BzToasts {
  BzToasts._();

  static final ValueNotifier<List<BzToastItem>> items = ValueNotifier(const []);
  static int _seq = 0;
  static final Map<int, Timer> _timers = {};

  static void show({
    required String title,
    String? message,
    BzVariant variant = BzVariant.dark,
    IconData? icon,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final item = BzToastItem(
      id: ++_seq,
      title: title,
      message: message,
      variant: variant,
      icon: icon,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
    final list = [...items.value, item];
    // keep the stack short
    while (list.length > 5) {
      final first = list.removeAt(0);
      _timers.remove(first.id)?.cancel();
    }
    items.value = list;
    _timers[item.id] = Timer(duration, () => dismiss(item.id));
  }

  static void success(String title, {String? message, String? actionLabel, VoidCallback? onAction}) =>
      show(title: title, message: message, variant: BzVariant.success, icon: BootstrapIcons.check_circle_fill, actionLabel: actionLabel, onAction: onAction);

  static void error(String title, {String? message}) =>
      show(title: title, message: message, variant: BzVariant.danger, icon: BootstrapIcons.x_circle_fill, duration: const Duration(seconds: 7));

  static void warning(String title, {String? message, String? actionLabel, VoidCallback? onAction}) =>
      show(title: title, message: message, variant: BzVariant.warning, icon: BootstrapIcons.exclamation_triangle_fill, duration: const Duration(seconds: 6), actionLabel: actionLabel, onAction: onAction);

  static void info(String title, {String? message, String? actionLabel, VoidCallback? onAction}) =>
      show(title: title, message: message, variant: BzVariant.primary, icon: BootstrapIcons.info_circle_fill, actionLabel: actionLabel, onAction: onAction);

  static void reminder(String title, {String? message, String? actionLabel, VoidCallback? onAction}) => show(
        title: title,
        message: message,
        variant: BzVariant.buzz,
        icon: BootstrapIcons.bell_fill,
        duration: const Duration(seconds: 10),
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void dismiss(int id) {
    _timers.remove(id)?.cancel();
    final list = [...items.value];
    final idx = list.indexWhere((t) => t.id == id);
    if (idx == -1) return;
    list[idx].removing = true;
    items.value = list;
    Timer(const Duration(milliseconds: 260), () {
      items.value = items.value.where((t) => t.id != id).toList();
    });
  }
}

/// Overlay host. Wrap the app content once (see `MaterialApp.builder`).
class BzToastHost extends StatelessWidget {
  const BzToastHost({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          right: MediaQuery.sizeOf(context).width < 700 ? 12 : 20,
          bottom: MediaQuery.sizeOf(context).width < 700 ? 96 : 20,
          child: ValueListenableBuilder<List<BzToastItem>>(
            valueListenable: BzToasts.items,
            builder: (context, list, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final t in list)
                    Padding(
                      key: ValueKey(t.id),
                      padding: const EdgeInsets.only(top: 10),
                      child: _ToastCard(item: t),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.item});
  final BzToastItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = item.variant.color;
    final bg = isDark ? BzColors.darkSurfaceAlt : Colors.white;

    final maxW = MediaQuery.sizeOf(context).width - 24;
    Widget card = Material(
      color: Colors.transparent,
      child: Container(
        width: maxW < 360 ? maxW : 360,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(BzTheme.radiusLg),
          border: Border.all(color: theme.colorScheme.outline),
          boxShadow: BzShadows.md(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(color: item.variant.subtle(theme.brightness), borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Icon(item.icon ?? BootstrapIcons.info_circle_fill, size: 17, color: item.variant == BzVariant.dark ? theme.colorScheme.onSurface : accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(item.title, style: theme.textTheme.titleSmall),
                        if (item.message != null && item.message!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(item.message!, style: theme.textTheme.bodySmall?.copyWith(height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                        if (item.actionLabel != null) ...[
                          const SizedBox(height: 6),
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              BzToasts.dismiss(item.id);
                              item.onAction?.call();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              child: Text(item.actionLabel!, style: theme.textTheme.labelMedium?.copyWith(color: BzColors.primary, fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    splashRadius: 16,
                    icon: const Icon(BootstrapIcons.x_lg, size: 13),
                    onPressed: () => BzToasts.dismiss(item.id),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 3,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: 0),
                duration: item.duration,
                builder: (context, v, _) => Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(widthFactor: v, child: Container(color: accent)),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (item.removing) {
      return card.animate().fadeOut(duration: 220.ms).slideX(begin: 0, end: 0.25, duration: 220.ms, curve: Curves.easeIn);
    }
    return card.animate().fadeIn(duration: 260.ms).slideX(begin: 0.3, end: 0, duration: 320.ms, curve: Curves.easeOutCubic).scaleXY(begin: 0.96, end: 1, duration: 320.ms, curve: Curves.easeOutBack);
  }
}
