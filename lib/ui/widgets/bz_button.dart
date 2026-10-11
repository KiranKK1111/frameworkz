import 'package:flutter/material.dart';

import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';

enum BzSize { sm, md, lg }

/// Bootstrap-style button: solid, outline or link variants, three sizes,
/// optional leading icon, loading state and a soft lift on hover.
class BzButton extends StatefulWidget {
  const BzButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = BzVariant.primary,
    this.outline = false,
    this.soft = false,
    this.link = false,
    this.size = BzSize.md,
    this.loading = false,
    this.block = false,
    this.tooltip,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final BzVariant variant;
  final bool outline;
  final bool soft;
  final bool link;
  final BzSize size;
  final bool loading;
  final bool block;
  final String? tooltip;

  @override
  State<BzButton> createState() => _BzButtonState();
}

class _BzButtonState extends State<BzButton> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final b = theme.brightness;
    final enabled = widget.onPressed != null && !widget.loading;
    final v = widget.variant;

    final (double hPad, double vPad, double font, double iconSize) = switch (widget.size) {
      BzSize.sm => (10, 6, 12.5, 14),
      BzSize.md => (14, 9, 13.5, 16),
      BzSize.lg => (20, 12, 15, 18),
    };

    Color bg;
    Color fg;
    Color border;
    if (widget.link) {
      bg = Colors.transparent;
      fg = v.color;
      border = Colors.transparent;
    } else if (widget.outline) {
      bg = _hover ? v.color : Colors.transparent;
      fg = _hover ? v.onColor : (v == BzVariant.light ? theme.colorScheme.onSurface : v.color);
      border = v == BzVariant.light ? theme.colorScheme.outline : v.color;
    } else if (widget.soft) {
      bg = _hover ? v.color.withValues(alpha: b == Brightness.dark ? 0.3 : 0.22) : v.subtle(b);
      fg = v.emphasis(b);
      border = Colors.transparent;
    } else {
      final base = v == BzVariant.light ? (b == Brightness.dark ? BzColors.darkSurfaceAlt : BzColors.light) : v.color;
      bg = _hover ? _shade(base, b == Brightness.dark && v == BzVariant.light ? 0.08 : -0.08) : base;
      fg = v == BzVariant.light ? theme.colorScheme.onSurface : v.onColor;
      border = v == BzVariant.light ? theme.colorScheme.outline : bg;
    }
    if (!enabled) {
      bg = bg.withValues(alpha: widget.link ? 0 : 0.55);
      fg = fg.withValues(alpha: 0.6);
      border = border.withValues(alpha: 0.4);
    }

    final content = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading)
          SizedBox(width: iconSize, height: iconSize, child: CircularProgressIndicator(strokeWidth: 2, color: fg))
        else if (widget.icon != null)
          Icon(widget.icon, size: iconSize, color: fg),
        if (widget.loading || widget.icon != null) const SizedBox(width: 8),
        Text(
          widget.label,
          style: TextStyle(fontSize: font, fontWeight: FontWeight.w600, color: fg, letterSpacing: 0.1, decoration: widget.link && _hover ? TextDecoration.underline : null),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 6),
          Icon(widget.trailingIcon, size: iconSize, color: fg),
        ],
      ],
    );

    Widget btn = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _down = true) : null,
        onTapUp: enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: () => setState(() => _down = false),
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: const Duration(milliseconds: 90),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(BzTheme.radius),
              border: Border.all(color: border),
              boxShadow: !widget.link && !widget.outline && !widget.soft && _hover && enabled
                  ? [BoxShadow(color: v.color.withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4))]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: enabled ? widget.onPressed : null,
                borderRadius: BorderRadius.circular(BzTheme.radius),
                splashColor: fg.withValues(alpha: 0.12),
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.link ? 4 : hPad, vertical: vPad),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) btn = Tooltip(message: widget.tooltip!, child: btn);
    return btn;
  }

  static Color _shade(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}

/// Square icon-only button with tooltip, hover tint and optional badge dot.
class BzIconButton extends StatefulWidget {
  const BzIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.variant = BzVariant.secondary,
    this.size = 34,
    this.iconSize = 16,
    this.filled = false,
    this.badgeCount,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final BzVariant variant;
  final double size;
  final double iconSize;
  final bool filled;
  final int? badgeCount;

  @override
  State<BzIconButton> createState() => _BzIconButtonState();
}

class _BzIconButtonState extends State<BzIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = widget.onPressed != null;
    final color = widget.variant == BzVariant.secondary ? theme.colorScheme.onSurfaceVariant : widget.variant.color;
    final bg = widget.filled
        ? widget.variant.subtle(theme.brightness)
        : (_hover ? color.withValues(alpha: 0.10) : Colors.transparent);

    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(BzTheme.radius),
                border: widget.filled ? Border.all(color: color.withValues(alpha: 0.2)) : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onPressed,
                  borderRadius: BorderRadius.circular(BzTheme.radius),
                  child: Center(child: Icon(widget.icon, size: widget.iconSize, color: enabled ? color : color.withValues(alpha: 0.4))),
                ),
              ),
            ),
            if (widget.badgeCount != null && widget.badgeCount! > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  constraints: const BoxConstraints(minWidth: 18),
                  decoration: BoxDecoration(color: BzColors.danger, borderRadius: BorderRadius.circular(999), border: Border.all(color: theme.colorScheme.surface, width: 2)),
                  child: Text(
                    widget.badgeCount! > 99 ? '99+' : '${widget.badgeCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700, height: 1.2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
