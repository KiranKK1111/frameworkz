import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/bz_colors.dart';
import '../../app/theme/bz_theme.dart';
import '../../core/utils/format.dart';

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
    final w = Column(
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
    return w;
  }
}

/// Horizontal group of fields with consistent gap. Every child is expanded;
/// a [BzField] with `flex` set gets that weight.
class BzRow extends StatelessWidget {
  const BzRow(this.children, {super.key, this.gap = 14});
  final List<Widget> children;
  final double gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        // Stack fields vertically when the row would be too cramped (phones).
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
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 16) : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 38, minHeight: 36),
        suffixIcon: suffix,
      ),
    );
  }
}

/// Styled dropdown with label rendering callback.
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
  });

  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final IconData? Function(T)? iconOf;
  final ValueChanged<T?> onChanged;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(BootstrapIcons.chevron_down, size: 13),
      style: TextStyle(fontSize: 13.5, color: Theme.of(context).colorScheme.onSurface, fontFamily: 'Inter'),
      borderRadius: BorderRadius.circular(BzTheme.radius),
      menuMaxHeight: 360,
      decoration: InputDecoration(hintText: hint),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Row(
                  children: [
                    if (iconOf != null && iconOf!(e) != null) ...[Icon(iconOf!(e), size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant), const SizedBox(width: 8)],
                    Expanded(child: Text(labelOf(e), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ))
          .toList(),
      onChanged: enabled ? onChanged : null,
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
          suffixIcon: clearable && value != null
              ? IconButton(splashRadius: 14, icon: const Icon(BootstrapIcons.x_lg, size: 12), onPressed: () => onChanged(null))
              : null,
        ),
        child: Text(value == null ? hint : Fmt.date(value), style: TextStyle(fontSize: 13.5, color: value == null ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface)),
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
        child: Text(value == null ? hint : value!.format(context), style: TextStyle(fontSize: 13.5, color: value == null ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onSurface)),
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
class BzSegmented<T> extends StatelessWidget {
  const BzSegmented({super.key, required this.value, required this.options, required this.onChanged});
  final T value;
  final List<(T, String, IconData?)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
