import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/utils/format.dart';
import 'bz_button.dart';

/// Page header with title, subtitle and right-aligned actions.
class BzPageHeader extends StatelessWidget {
  const BzPageHeader({super.key, required this.title, this.subtitle, this.actions, this.icon, this.breadcrumb, this.phoneTitle = false});
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final IconData? icon;
  final Widget? breadcrumb;

  /// On phones the app bar already shows the page name, so the title is hidden
  /// unless this is true (e.g. a month name on the calendar).
  final bool phoneTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final phone = context.isPhone;
    final titleBlock = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null && !phone) ...[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: BzColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(icon, size: 19, color: BzColors.primary),
          ),
          const SizedBox(width: 14),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (breadcrumb != null) ...[breadcrumb!, const SizedBox(height: 4)],
              if (!phone || phoneTitle) Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontSize: 22)),
              if (subtitle != null) ...[if (!phone || phoneTitle) const SizedBox(height: 3), Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis)],
            ],
          ),
        ),
        if (actions != null && !phone) ...actions!.expand((a) => [const SizedBox(width: 8), a]),
      ],
    );
    final content = phone && actions != null && actions!.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleBlock,
              const SizedBox(height: 12),
              BzHScroll(children: actions!),
            ],
          )
        : titleBlock;
    return Padding(
      padding: EdgeInsets.only(bottom: phone ? 14 : 20),
      child: content,
    ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.08, end: 0, duration: 300.ms, curve: Curves.easeOutCubic);
  }
}

/// Empty state with illustration circle, copy and primary action.
class BzEmptyState extends StatelessWidget {
  const BzEmptyState({super.key, required this.icon, required this.title, required this.message, this.actionLabel, this.onAction, this.compact = false});
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? 20 : 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 56 : 84,
              height: compact ? 56 : 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [BzColors.primary.withValues(alpha: 0.14), BzColors.buzz.withValues(alpha: 0.18)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: compact ? 24 : 34, color: BzColors.primary),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1, end: 1.04, duration: 1800.ms, curve: Curves.easeInOut),
            SizedBox(height: compact ? 12 : 20),
            Text(title, style: compact ? theme.textTheme.titleMedium : theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(message, style: theme.textTheme.bodySmall?.copyWith(fontSize: 13, height: 1.5), textAlign: TextAlign.center),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? 14 : 22),
              BzButton(label: actionLabel!, icon: BootstrapIcons.plus_lg, onPressed: onAction),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}

/// Initials avatar with a deterministic colour per name.
class BzAvatar extends StatelessWidget {
  const BzAvatar(this.name, {super.key, this.size = 36, this.radius});
  final String name;
  final double size;
  final double? radius;

  static const _palette = [
    Color(0xFF0D6EFD),
    Color(0xFF6610F2),
    Color(0xFF6F42C1),
    Color(0xFFD63384),
    Color(0xFFFD7E14),
    Color(0xFF198754),
    Color(0xFF20C997),
    Color(0xFF0DCAF0),
    Color(0xFFDC3545),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _palette[name.isEmpty ? 0 : name.codeUnits.fold<int>(0, (a, b) => a + b) % _palette.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? size * 0.3),
        gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.75)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      alignment: Alignment.center,
      child: Text(Fmt.initials(name), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * 0.38, letterSpacing: 0.5)),
    );
  }
}

/// Small pill with icon + text used for meta info (source, service, phone…).
class BzMetaChip extends StatelessWidget {
  const BzMetaChip({super.key, required this.icon, required this.text, this.onTap, this.color});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.onSurfaceVariant;
    final w = Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: c),
          const SizedBox(width: 6),
          Text(text, style: theme.textTheme.labelSmall?.copyWith(color: onTap != null ? BzColors.primary : theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
        ],
      ),
    );
    if (onTap == null) return w;
    return MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(onTap: onTap, child: w));
  }
}

/// Wraps page content with standard padding and max width, scrollable.
class BzPage extends StatelessWidget {
  const BzPage({super.key, required this.child, this.scroll = true, this.maxWidth = 1680});
  final Widget child;
  final bool scroll;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final g = context.pageGutter;
    final phone = context.isPhone;
    final body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: EdgeInsets.fromLTRB(g, phone ? 16 : 20, g, phone ? 96 : 24), child: child),
      ),
    );
    if (!scroll) return body;
    return SingleChildScrollView(child: body);
  }
}

/// Loading placeholder.
class BzLoading extends StatelessWidget {
  const BzLoading({super.key, this.message});
  final String? message;
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5)),
            if (message != null) ...[const SizedBox(height: 12), Text(message!, style: Theme.of(context).textTheme.bodySmall)],
          ],
        ),
      );
}

/// Subtle divider with centered label.
class BzLabeledDivider extends StatelessWidget {
  const BzLabeledDivider(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(child: Divider()),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(label, style: Theme.of(context).textTheme.labelSmall)),
          const Expanded(child: Divider()),
        ],
      );
}

/// Timeline row used for activity feeds.
class BzTimelineItem extends StatelessWidget {
  const BzTimelineItem({super.key, required this.icon, required this.title, this.detail, required this.time, this.color, this.isLast = false});
  final IconData icon;
  final String title;
  final String? detail;
  final DateTime time;
  final Color? color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? BzColors.primary;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: c.withValues(alpha: 0.12), shape: BoxShape.circle, border: Border.all(color: c.withValues(alpha: 0.35))),
                alignment: Alignment.center,
                child: Icon(icon, size: 13, color: c),
              ),
              if (!isLast) Expanded(child: Container(width: 2, margin: const EdgeInsets.symmetric(vertical: 4), color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))),
                      Text(Fmt.timeAgo(time), style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                  if (detail != null && detail!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(detail!, style: theme.textTheme.bodySmall?.copyWith(height: 1.4)),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable container for list rows with hover highlight.
class BzHoverRow extends StatefulWidget {
  const BzHoverRow({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10), this.selected = false});
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final bool selected;

  @override
  State<BzHoverRow> createState() => _BzHoverRowState();
}

class _BzHoverRowState extends State<BzHoverRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.selected
                ? BzColors.primary.withValues(alpha: 0.08)
                : (_hover ? theme.colorScheme.surfaceContainerHigh : Colors.transparent),
            borderRadius: BorderRadius.circular(BzTheme.radius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
