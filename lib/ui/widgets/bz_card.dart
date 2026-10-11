import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';

/// Bootstrap card with optional header (title / subtitle / actions), hover
/// lift and tap handling.
class BzCard extends StatefulWidget {
  const BzCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.headerPadding,
    this.onTap,
    this.hoverLift = false,
    this.accent,
    this.footer,
    this.clip = false,
    this.fill = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? headerPadding;
  final VoidCallback? onTap;
  final bool hoverLift;
  final Color? accent;
  final Widget? footer;
  final bool clip;

  /// When true the card expands to the height it is given and the body fills
  /// the remaining space (use inside Expanded / fixed-height parents).
  final bool fill;

  @override
  State<BzCard> createState() => _BzCardState();
}

class _BzCardState extends State<BzCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    // `fill` only applies when the parent gives a bounded height; otherwise an
    // Expanded body would be unbounded (e.g. stacked columns on phones).
    return _build(context, widget.fill && BzBounded.of(context));
  }

  Widget _build(BuildContext context, bool fill) {
    final theme = Theme.of(context);
    final lift = widget.hoverLift && _hover;
    final hasHeader =
        widget.title != null ||
        widget.actions != null ||
        widget.leading != null;

    final bodyChild = Padding(padding: widget.padding, child: widget.child);
    Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (hasHeader) ...[
          Padding(
            padding:
                widget.headerPadding ??
                const EdgeInsets.fromLTRB(18, 14, 12, 14),
            child: Row(
              children: [
                if (widget.leading != null) ...[
                  widget.leading!,
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(widget.title!, style: theme.textTheme.titleMedium),
                      if (widget.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.actions != null)
                  ...widget.actions!.expand(
                    (a) => [const SizedBox(width: 6), a],
                  ),
              ],
            ),
          ),
          const Divider(),
        ],
        if (fill) Expanded(child: bodyChild) else bodyChild,
        if (widget.footer != null) ...[
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(BzTheme.radiusLg),
              ),
            ),
            child: widget.footer,
          ),
        ],
      ],
    );

    if (widget.accent != null) {
      body = Stack(
        children: [
          body,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(width: 4, color: widget.accent),
          ),
        ],
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, lift ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(BzTheme.radiusLg),
          border: Border.all(
            color: lift
                ? BzColors.primary.withValues(alpha: 0.45)
                : theme.colorScheme.outline,
          ),
          boxShadow: lift ? BzShadows.md(context) : BzShadows.sm(context),
        ),
        clipBehavior: widget.clip || widget.accent != null
            ? Clip.antiAlias
            : Clip.none,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(BzTheme.radiusLg),
            child: body,
          ),
        ),
      ),
    );
  }
}

/// KPI tile with icon, big animated number and optional trend / hint.
class BzStatTile extends StatelessWidget {
  const BzStatTile({
    super.key,
    required this.label,
    required this.value,
    this.numericValue,
    this.icon,
    this.variant = BzVariant.primary,
    this.hint,
    this.onTap,
    this.delay = Duration.zero,
    this.formatter,
  });

  final String label;
  final String value;
  final num? numericValue;
  final IconData? icon;
  final BzVariant variant;
  final String? hint;
  final VoidCallback? onTap;
  final Duration delay;
  final String Function(num)? formatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final phone = context.isPhone;
    final tile = BzCard(
      onTap: onTap,
      hoverLift: onTap != null,
      padding: EdgeInsets.fromLTRB(phone ? 14 : 18, phone ? 12 : 16, phone ? 14 : 18, phone ? 12 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    fontSize: phone ? 10 : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: phone ? 4 : 8),
                if (numericValue != null)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: numericValue!.toDouble()),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutCubic,
                    builder: (context, v, _) => Text(
                      formatter != null ? formatter!(v) : v.round().toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: phone ? 22 : 26,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                else
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: phone ? 22 : 26,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (hint case final h?) ...[
                  const SizedBox(height: 6),
                  Text(
                    h,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (icon != null && !phone)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: variant.subtle(b),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 20, color: variant.emphasis(b)),
            ),
        ],
      ),
    );
    return tile
        .animate(delay: delay)
        .fadeIn(duration: 350.ms)
        .slideY(
          begin: 0.12,
          end: 0,
          duration: 420.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Section label used inside pages and forms.
class BzSectionTitle extends StatelessWidget {
  const BzSectionTitle(this.text, {super.key, this.trailing, this.icon});
  final String text;
  final Widget? trailing;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 7),
          ],
          Text(
            text.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.9,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Expanded(child: SizedBox()),
          ?trailing,
        ],
      ),
    );
  }
}

/// Simple label/value row for detail panels.
class BzKeyValue extends StatelessWidget {
  const BzKeyValue(
    this.label,
    this.value, {
    super.key,
    this.icon,
    this.valueWidget,
    this.onTap,
    this.copyable = false,
  });
  final String label;
  final String value;
  final IconData? icon;
  final Widget? valueWidget;
  final VoidCallback? onTap;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v =
        valueWidget ??
        Text(
          value.isEmpty ? '—' : value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: onTap != null && value.isNotEmpty ? BzColors.primary : null,
          ),
          overflow: TextOverflow.ellipsis,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 118,
            child: Text(label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: onTap != null && value.isNotEmpty
                ? MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(onTap: onTap, child: v),
                  )
                : v,
          ),
        ],
      ),
    );
  }
}
