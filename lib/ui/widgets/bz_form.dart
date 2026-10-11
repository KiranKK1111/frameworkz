import 'dart:math' as math;

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/responsive.dart';
import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/utils/format.dart';
import 'bz_misc.dart';
import 'bz_modal.dart';

/// Bootstrap "form-label above control" layout.
class BzField extends StatelessWidget {
  const BzField({super.key, required this.label, required this.child, this.required = false, this.help, this.flex});
  final String label;
  final Widget child;
  final bool required;
  final String? help;
  final int? flex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Flexible(child: Text(label, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (required) Text(' *', style: theme.textTheme.labelMedium?.copyWith(color: BzColors.danger)),
            ],
          ),
        ),
        child,
        if (help != null) Padding(padding: const EdgeInsets.only(top: 5), child: Text(help!, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}

/// Horizontal group of fields with consistent gap. Every child is expanded;
/// a [BzField] with `flex` set gets that weight. Stacks vertically when the
/// row would be too cramped (phones).
class BzRow extends StatelessWidget {
  const BzRow(this.children, {super.key, this.gap = 14});
  final List<Widget> children;
  final double gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        if (c.maxWidth < 420 && children.length > 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children.expand((w) => [w, SizedBox(height: gap)]).toList()..removeLast(),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children.expand((w) => [Expanded(flex: w is BzField ? (w.flex ?? 1) : 1, child: w), SizedBox(width: gap)]).toList()..removeLast(),
        );
      });
}

/// Buttons at the end of a form or sheet. Desktop: right-aligned row. Phone:
/// one button fills the width, two sit side by side, more form a 2-column grid.
class BzActionRow extends StatelessWidget {
  const BzActionRow(this.children, {super.key, this.alignEnd = true, this.gap = 8});
  final List<Widget> children;
  final bool alignEnd;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    if (context.isPhone) {
      if (children.length == 1) return SizedBox(width: double.infinity, child: children.first);
      if (children.length == 2) {
        return Row(children: [Expanded(child: children[0]), SizedBox(width: gap), Expanded(child: children[1])]);
      }
      return BzResponsiveGrid(minItemWidth: 140, maxColumns: 2, gap: gap, children: children);
    }
    return Row(
      mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: children.expand((c) => [c, SizedBox(width: gap)]).toList()..removeLast(),
    );
  }
}

class BzTextField extends StatelessWidget {
  const BzTextField({
    super.key,
    this.controller,
    this.hint,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.enabled = true,
    this.obscure = false,
    this.focusNode,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final bool enabled;
  final bool obscure;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: obscure ? 1 : maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscure,
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        hintText: hint,
        hintMaxLines: 1,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16) : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 36),
        suffixIcon: suffix,
      ),
    );
  }
}

class _Picked<T> {
  const _Picked(this.value);
  final T value;
}

/// Select control. Renders as a Bootstrap-style field (or a filter pill when
/// [compact]) and opens a bottom-sheet picker on phones or an anchored popup
/// on larger screens, so the options are always readable and tappable.
class BzDropdown<T> extends StatelessWidget {
  const BzDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.iconOf,
    this.hint,
    this.enabled = true,
    this.compact = false,
    this.title,
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final IconData? Function(T)? iconOf;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final bool enabled;

  /// Pill style used in filter rows.
  final bool compact;

  /// Sheet title on phones (defaults to [hint]).
  final String? title;

  bool _isSelected(T item) => item == value;

  Future<void> _open(BuildContext context) async {
    final theme = Theme.of(context);
    _Picked<T>? picked;
    if (context.isPhone) {
      picked = await showBzModal<_Picked<T>>(
        context: context,
        title: title ?? hint ?? 'Select',
        icon: BootstrapIcons.list_ul,
        bodyPadding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in items)
              BzHoverRow(
                selected: _isSelected(e),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                onTap: () => Navigator.of(context, rootNavigator: true).pop(_Picked<T>(e)),
                child: Row(children: [
                  if (iconOf != null) ...[
                    Icon(iconOf!(e) ?? BootstrapIcons.dot, size: 15, color: _isSelected(e) ? BzColors.primary : theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: Text(labelOf(e), style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15, fontWeight: _isSelected(e) ? FontWeight.w700 : FontWeight.w500))),
                  if (_isSelected(e)) const Icon(BootstrapIcons.check_lg, size: 15, color: BzColors.primary),
                ]),
              ),
          ],
        ),
      );
    } else {
      final box = context.findRenderObject() as RenderBox;
      final origin = box.localToGlobal(Offset.zero);
      final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
      picked = await showMenu<_Picked<T>>(
        context: context,
        position: RelativeRect.fromLTRB(origin.dx, origin.dy + box.size.height + 4, overlay.size.width - origin.dx - box.size.width, 0),
        constraints: BoxConstraints(minWidth: math.max(box.size.width, 180), maxWidth: math.max(box.size.width, 260), maxHeight: 400),
        items: [
          for (final e in items)
            PopupMenuItem<_Picked<T>>(
              value: _Picked<T>(e),
              height: 38,
              child: Row(children: [
                if (iconOf != null) ...[
                  Icon(iconOf!(e) ?? BootstrapIcons.dot, size: 14, color: _isSelected(e) ? BzColors.primary : theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 10),
                ],
                Expanded(child: Text(labelOf(e), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: _isSelected(e) ? FontWeight.w700 : FontWeight.w500), overflow: TextOverflow.ellipsis)),
                if (_isSelected(e)) const Icon(BootstrapIcons.check_lg, size: 13, color: BzColors.primary),
              ]),
            ),
        ],
      );
    }
    if (picked != null) onChanged(picked.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = value;
    // A null value is a real choice when the options include null
    // (e.g. "No follow-up"), otherwise it means "nothing picked yet".
    final hasChoice = v != null || items.contains(v);
    final label = hasChoice ? labelOf(v as T) : (hint ?? 'Select');
    final icon = hasChoice && iconOf != null ? iconOf!(v as T) : null;
    final muted = theme.colorScheme.onSurfaceVariant;

    if (compact) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: enabled ? () => _open(context) : null,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
            decoration: BoxDecoration(
              color: v != null && hint != null && label != hint ? BzColors.primary.withValues(alpha: 0.10) : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon ?? BootstrapIcons.funnel, size: 12, color: muted),
              const SizedBox(width: 6),
              Flexible(child: Text(label, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 6),
              Icon(BootstrapIcons.chevron_down, size: 10, color: muted),
            ]),
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(BzTheme.radius),
      onTap: enabled ? () => _open(context) : null,
      child: InputDecorator(
        isEmpty: v == null,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, size: 15) : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 36),
          suffixIcon: Icon(BootstrapIcons.chevron_down, size: 13, color: muted),
          suffixIconConstraints: const BoxConstraints(minWidth: 34, minHeight: 36),
          enabled: enabled,
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 13.5, color: v == null ? muted : theme.colorScheme.onSurface),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Date picker rendered as a read-only field.
class BzDateField extends StatelessWidget {
  const BzDateField({
    super.key,
    required this.value,
    required this.onChanged,
    this.hint = 'Pick a date',
    this.clearable = true,
    this.firstDate,
    this.lastDate,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final String hint;
  final bool clearable;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(BzTheme.radius),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: firstDate ?? DateTime(2015),
          lastDate: lastDate ?? DateTime(2100),
        );
        if (picked != null) onChanged(DateTime(picked.year, picked.month, picked.day, value?.hour ?? 0, value?.minute ?? 0));
      },
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(BootstrapIcons.calendar3, size: 15),
          prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 36),
          suffixIcon: clearable && value != null ? IconButton(splashRadius: 14, icon: const Icon(BootstrapIcons.x_lg, size: 12), onPressed: () => onChanged(null)) : null,
        ),
        child: Text(value == null ? hint : Fmt.date(value), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5, color: value == null ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface)),
      ),
    );
  }
}

/// Time picker rendered as a read-only field.
class BzTimeField extends StatelessWidget {
  const BzTimeField({super.key, required this.value, required this.onChanged, this.hint = 'Pick a time'});
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(BzTheme.radius),
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: value ?? const TimeOfDay(hour: 11, minute: 0));
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          prefixIcon: Icon(BootstrapIcons.clock, size: 15),
          prefixIconConstraints: BoxConstraints(minWidth: 38, minHeight: 36),
        ),
        child: Text(value == null ? hint : value!.format(context), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.5, color: value == null ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface)),
      ),
    );
  }
}

/// Currency input (₹) accepting digits and a decimal point.
class BzMoneyField extends StatelessWidget {
  const BzMoneyField({super.key, required this.controller, this.hint = '0'});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return BzTextField(
      controller: controller,
      hint: hint,
      prefixIcon: BootstrapIcons.currency_rupee,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
    );
  }
}

/// Search input used in page toolbars.
class BzSearchField extends StatelessWidget {
  const BzSearchField({super.key, required this.onChanged, this.hint = 'Search…', this.controller, this.width = 320, this.autofocus = false});
  final ValueChanged<String> onChanged;
  final String hint;
  final TextEditingController? controller;
  final double width;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: hint,
          hintMaxLines: 1,
          prefixIcon: const Icon(BootstrapIcons.search, size: 14),
          prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 34),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        ),
      ),
    );
  }
}

/// Segmented control (Bootstrap button group) for view / filter toggles.
/// Scales down instead of overflowing when space is tight.
class BzSegmented<T> extends StatelessWidget {
  const BzSegmented({super.key, required this.value, required this.options, required this.onChanged});
  final T value;
  final List<(T, String, IconData?)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(BzTheme.radius + 2),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final o in options)
              GestureDetector(
                onTap: () => onChanged(o.$1),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: o.$1 == value ? theme.colorScheme.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(BzTheme.radius),
                      boxShadow: o.$1 == value ? BzShadows.sm(context) : null,
                    ),
                    child: Row(
                      children: [
                        if (o.$3 != null) ...[Icon(o.$3, size: 13, color: o.$1 == value ? BzColors.primary : theme.colorScheme.onSurfaceVariant), const SizedBox(width: 6)],
                        Text(o.$2, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: o.$1 == value ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Toggle row used in settings.
class BzSwitchTile extends StatelessWidget {
  const BzSwitchTile({super.key, required this.title, this.subtitle, required this.value, required this.onChanged, this.icon});
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(BzTheme.radius),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant), const SizedBox(width: 12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
