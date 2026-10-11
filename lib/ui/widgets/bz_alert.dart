import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';

/// Bootstrap alert (`.alert-*`), optionally dismissible, with an action slot.
class BzAlert extends StatelessWidget {
  const BzAlert({
    super.key,
    required this.message,
    this.title,
    this.variant = BzVariant.info,
    this.icon,
    this.onDismiss,
    this.action,
    this.dense = false,
  });

  final String message;
  final String? title;
  final BzVariant variant;
  final IconData? icon;
  final VoidCallback? onDismiss;
  final Widget? action;
  final bool dense;

  IconData get _icon => icon ??
      switch (variant) {
        BzVariant.success => BootstrapIcons.check_circle_fill,
        BzVariant.danger => BootstrapIcons.x_circle_fill,
        BzVariant.warning => BootstrapIcons.exclamation_triangle_fill,
        BzVariant.buzz => BootstrapIcons.lightbulb,
        _ => BootstrapIcons.info_circle_fill,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final fg = variant.emphasis(b);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: dense ? 10 : 13),
      decoration: BoxDecoration(
        color: variant.subtle(b),
        borderRadius: BorderRadius.circular(BzTheme.radius),
        border: Border.all(color: variant.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(_icon, size: 17, color: fg),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: theme.textTheme.titleSmall?.copyWith(color: fg)),
                if (title != null) const SizedBox(height: 2),
                Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: fg, height: 1.45)),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 12), action!],
          if (onDismiss != null) ...[
            const SizedBox(width: 6),
            IconButton(
              visualDensity: VisualDensity.compact,
              splashRadius: 16,
              onPressed: onDismiss,
              icon: Icon(BootstrapIcons.x_lg, size: 13, color: fg),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.1, end: 0, duration: 300.ms, curve: Curves.easeOutCubic);
  }
}
