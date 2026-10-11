import 'dart:ui';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import 'bz_button.dart';

/// Bootstrap-style modal on desktop; a rounded, draggable bottom sheet on
/// phones (the pattern used by modern consumer apps). Same header / body /
/// footer contract on both.
Future<T?> showBzModal<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  String? subtitle,
  IconData? icon,
  BzVariant variant = BzVariant.primary,
  List<Widget>? actions,
  double width = 560,
  double? maxHeight,
  bool dismissible = true,
  EdgeInsetsGeometry bodyPadding = const EdgeInsets.fromLTRB(24, 20, 24, 24),
  bool fullscreenOnPhone = false,
}) {
  if (context.isPhone) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: dismissible,
      enableDrag: dismissible,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => _BzSheetFrame(
        title: title,
        subtitle: subtitle,
        icon: icon,
        variant: variant,
        actions: actions,
        bodyPadding: bodyPadding,
        fullscreen: fullscreenOnPhone,
        child: child,
      ),
    );
  }
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (ctx, a1, a2) => _BzModalFrame(
      title: title,
      subtitle: subtitle,
      icon: icon,
      variant: variant,
      width: width,
      maxHeight: maxHeight,
      bodyPadding: bodyPadding,
      actions: actions,
      child: child,
    ),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeIn);
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6 * anim.value, sigmaY: 6 * anim.value),
        child: FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(curved),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, this.subtitle, this.icon, required this.variant, this.handle = false});
  final String title;
  final String? subtitle;
  final IconData? icon;
  final BzVariant variant;
  final bool handle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (handle)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outline, borderRadius: BorderRadius.circular(2))),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(handle ? 20 : 24, handle ? 14 : 18, 14, 16),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: variant.subtle(theme.brightness), borderRadius: BorderRadius.circular(11)),
                  alignment: Alignment.center,
                  child: Icon(icon, size: 18, color: variant.emphasis(theme.brightness)),
                ),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: theme.textTheme.titleLarge?.copyWith(fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle!, style: theme.textTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),
              BzIconButton(icon: BootstrapIcons.x_lg, tooltip: 'Close', iconSize: 14, onPressed: () => Navigator.of(context).maybePop()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.actions, this.stacked = false});
  final List<Widget> actions;
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      padding: EdgeInsets.fromLTRB(20, 14, 20, stacked ? 18 : 14),
      child: stacked && actions.length > 2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: actions.reversed.expand((a) => [a, const SizedBox(height: 8)]).toList()..removeLast(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: stacked
                  ? actions.map((a) => Expanded(child: Padding(padding: const EdgeInsets.only(left: 8), child: a))).toList()
                  : actions.expand((a) => [a, const SizedBox(width: 8)]).toList()
                ..removeLast(),
            ),
    );
  }
}

class _BzModalFrame extends StatelessWidget {
  const _BzModalFrame({
    required this.title,
    required this.child,
    required this.width,
    required this.bodyPadding,
    this.subtitle,
    this.icon,
    this.variant = BzVariant.primary,
    this.actions,
    this.maxHeight,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final BzVariant variant;
  final Widget child;
  final List<Widget>? actions;
  final double width;
  final double? maxHeight;
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width.clamp(320, size.width - 48),
          constraints: BoxConstraints(maxHeight: maxHeight ?? size.height - 80),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(BzTheme.radiusXl),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: BzShadows.lg(context),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(title: title, subtitle: subtitle, icon: icon, variant: variant),
              const Divider(),
              Flexible(child: SingleChildScrollView(padding: bodyPadding, child: child)),
              if (actions != null && actions!.isNotEmpty) ...[const Divider(), _Footer(actions: actions!)],
            ],
          ),
        ),
      ),
    );
  }
}

class _BzSheetFrame extends StatelessWidget {
  const _BzSheetFrame({
    required this.title,
    required this.child,
    required this.bodyPadding,
    this.subtitle,
    this.icon,
    this.variant = BzVariant.primary,
    this.actions,
    this.fullscreen = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final BzVariant variant;
  final Widget child;
  final List<Widget>? actions;
  final EdgeInsetsGeometry bodyPadding;
  final bool fullscreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: inset),
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * (fullscreen ? 0.96 : 0.92)),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: BzShadows.lg(context),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(title: title, subtitle: subtitle, icon: icon, variant: variant, handle: true),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                padding: bodyPadding is EdgeInsets ? const EdgeInsets.fromLTRB(18, 16, 18, 20) : bodyPadding,
                child: child,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[const Divider(), _Footer(actions: actions!, stacked: true)],
            SizedBox(height: MediaQuery.paddingOf(context).bottom > 0 ? 0 : 6),
          ],
        ),
      ),
    );
  }
}

/// Confirmation dialog. Returns `true` when confirmed.
Future<bool> showBzConfirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  BzVariant variant = BzVariant.danger,
  IconData icon = BootstrapIcons.exclamation_triangle_fill,
}) async {
  final res = await showBzModal<bool>(
    context: context,
    title: title,
    icon: icon,
    variant: variant,
    width: 460,
    child: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5)),
    actions: [
      BzButton(label: cancelLabel, variant: BzVariant.light, onPressed: () => Navigator.of(context).pop(false)),
      BzButton(label: confirmLabel, variant: variant, onPressed: () => Navigator.of(context).pop(true)),
    ],
  );
  return res ?? false;
}

/// Side sheet from the right on desktop; full-height bottom sheet on phones.
Future<T?> showBzSideSheet<T>({
  required BuildContext context,
  required Widget child,
  double width = 520,
}) {
  if (context.isPhone) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.sizeOf(ctx).height * 0.9,
        decoration: BoxDecoration(color: Theme.of(ctx).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (ctx, a1, a2) => Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Theme.of(ctx).colorScheme.surface,
        child: SizedBox(width: width, height: double.infinity, child: child),
      ),
    ),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic, reverseCurve: Curves.easeIn);
      return SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved), child: child);
    },
  );
}
