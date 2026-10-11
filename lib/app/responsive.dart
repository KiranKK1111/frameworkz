import 'package:flutter/material.dart';

/// Breakpoints shared by every screen.
///
/// * phone   < 700 dp  → bottom navigation, single column, bottom sheets
/// * tablet  < 1100 dp → collapsed sidebar, two columns where they fit
/// * desktop ≥ 1100 dp → full sidebar, multi-column
enum FormFactor { phone, tablet, desktop }

class Breakpoints {
  Breakpoints._();
  static const double phone = 700;
  static const double tablet = 1100;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  FormFactor get formFactor {
    final w = screenWidth;
    if (w < Breakpoints.phone) return FormFactor.phone;
    if (w < Breakpoints.tablet) return FormFactor.tablet;
    return FormFactor.desktop;
  }

  bool get isPhone => formFactor == FormFactor.phone;
  bool get isTablet => formFactor == FormFactor.tablet;
  bool get isDesktop => formFactor == FormFactor.desktop;

  /// Compact = phone or tablet (anything below the full desktop layout).
  bool get isCompact => screenWidth < Breakpoints.tablet;

  /// Standard page gutter for the current form factor.
  double get pageGutter => isPhone ? 16 : (isTablet ? 20 : 24);
}

/// Lays children out in equal-width, equal-height tiles. The column count is
/// derived from the available width and [minItemWidth], so the same code
/// produces 5 tiles on a wide monitor, 3 on a laptop and 2 on a phone.
class BzResponsiveGrid extends StatelessWidget {
  const BzResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 220,
    this.maxColumns = 6,
    this.gap = 14,
    this.itemHeight,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double gap;

  /// Fixed tile height for uniform rows. When null, rows size to their tallest
  /// child via [IntrinsicHeight].
  final double? itemHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final width = c.maxWidth.isFinite ? c.maxWidth : MediaQuery.sizeOf(context).width;
        var cols = ((width + gap) / (minItemWidth + gap)).floor().clamp(1, maxColumns);
        if (children.length < cols) cols = children.length.clamp(1, maxColumns);
        final rows = <Widget>[];
        for (var i = 0; i < children.length; i += cols) {
          final slice = children.sublist(i, (i + cols).clamp(0, children.length));
          // A short last row stretches its tiles so no empty slot is left.
          Widget row = Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < slice.length; j++) ...[
                if (j > 0) SizedBox(width: gap),
                Expanded(child: slice[j]),
              ],
            ],
          );
          final scale = MediaQuery.textScalerOf(context).scale(10) / 10;
          row = itemHeight != null ? SizedBox(height: itemHeight! * (scale > 1 ? scale : 1), child: row) : IntrinsicHeight(child: row);
          rows.add(row);
          if (i + cols < children.length) rows.add(SizedBox(height: gap));
        }
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows);
      },
    );
  }
}

/// Two columns on wide screens, stacked on compact ones. [ratio] is the flex
/// of the first column relative to the second.
class BzTwoColumn extends StatelessWidget {
  const BzTwoColumn({
    super.key,
    required this.left,
    required this.right,
    this.ratio = 3,
    this.rightFlex = 2,
    this.gap = 16,
    this.breakpoint = 1000,
  });

  final Widget left;
  final Widget right;
  final int ratio;
  final int rightFlex;
  final double gap;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth < breakpoint) {
        return BzBounded(
          bounded: false,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, SizedBox(height: gap), right]),
        );
      }
      // Both columns get the same height so cards can stretch to the bottom.
      // (LayoutBuilder cannot live under IntrinsicHeight, so descendants learn
      // about the bounded height through [BzBounded] instead.)
      return BzBounded(
        bounded: true,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: ratio, child: left),
              SizedBox(width: gap),
              Expanded(flex: rightFlex, child: right),
            ],
          ),
        ),
      );
    });
  }
}

/// Tells descendants whether they are laid out with a bounded height (so
/// `BzCard(fill: true)` / [BzFillColumn] may use Expanded). Absent = bounded.
class BzBounded extends InheritedWidget {
  const BzBounded({super.key, required this.bounded, required super.child});
  final bool bounded;

  static bool of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<BzBounded>()?.bounded ?? true;

  @override
  bool updateShouldNotify(BzBounded old) => old.bounded != bounded;
}

/// A column whose last child fills the remaining height when the parent gives
/// a bounded height (e.g. inside [BzTwoColumn]); otherwise behaves like a
/// plain column. Use with `BzCard(fill: true)` as the last child.
class BzFillColumn extends StatelessWidget {
  const BzFillColumn({super.key, required this.children, this.gap = 14});
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final bounded = BzBounded.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          if (bounded && i == children.length - 1) Expanded(child: children[i]) else children[i],
        ],
      ],
    );
  }
}

/// Chips row: horizontal scroll on phones, wrapping on larger screens.
class BzHScrollOrWrap extends StatelessWidget {
  const BzHScrollOrWrap({super.key, required this.children, required this.scroll, this.gap = 8});
  final List<Widget> children;
  final bool scroll;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (scroll) return BzHScroll(gap: gap, children: children);
    return Wrap(spacing: gap, runSpacing: gap, crossAxisAlignment: WrapCrossAlignment.center, children: children);
  }
}

/// Horizontal scroller for action buttons / chips that must never overflow.
class BzHScroll extends StatelessWidget {
  const BzHScroll({super.key, required this.children, this.gap = 8, this.padding = EdgeInsets.zero});
  final List<Widget> children;
  final double gap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}
