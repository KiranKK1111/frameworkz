import 'package:flutter/material.dart';

import 'bz_colors.dart';

/// Builds the light and dark [ThemeData] for FrameWorkz.
///
/// Visual language: Bootstrap 5 — 1px borders, 8/12px radii, soft shadows,
/// semantic colours, Inter typeface, generous but compact spacing suitable
/// for a desktop productivity tool.
class BzTheme {
  BzTheme._();

  static const double radiusSm = 6;
  static const double radius = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: BzColors.primary,
      onPrimary: Colors.white,
      primaryContainer: isDark ? const Color(0xFF0B3C87) : BzColors.primarySubtle,
      onPrimaryContainer: isDark ? const Color(0xFFCFE2FF) : BzColors.primaryEmphasis,
      secondary: BzColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: isDark ? BzColors.darkSurfaceAlt : BzColors.gray200,
      onSecondaryContainer: isDark ? BzColors.gray300 : BzColors.gray800,
      tertiary: BzColors.buzz,
      onTertiary: BzColors.gray900,
      tertiaryContainer: isDark ? const Color(0xFF5C4300) : const Color(0xFFFFF0C2),
      onTertiaryContainer: isDark ? const Color(0xFFFFD36A) : const Color(0xFF664D03),
      error: BzColors.danger,
      onError: Colors.white,
      errorContainer: isDark ? const Color(0xFF5A1A20) : BzColors.dangerSubtle,
      onErrorContainer: isDark ? const Color(0xFFF1AEB5) : BzColors.dangerEmphasis,
      surface: isDark ? BzColors.darkSurface : Colors.white,
      onSurface: isDark ? const Color(0xFFE6E8EC) : BzColors.gray900,
      surfaceContainerHighest: isDark ? BzColors.darkSurfaceAlt : BzColors.gray200,
      surfaceContainerHigh: isDark ? const Color(0xFF20252E) : BzColors.gray100,
      surfaceContainer: isDark ? const Color(0xFF1D222A) : BzColors.gray100,
      surfaceContainerLow: isDark ? BzColors.darkBg : BzColors.gray100,
      surfaceContainerLowest: isDark ? BzColors.darkBg : Colors.white,
      onSurfaceVariant: isDark ? BzColors.gray500 : BzColors.gray600,
      outline: isDark ? BzColors.darkBorder : BzColors.gray300,
      outlineVariant: isDark ? const Color(0xFF262B35) : BzColors.gray200,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? BzColors.gray100 : BzColors.gray900,
      onInverseSurface: isDark ? BzColors.gray900 : BzColors.gray100,
      inversePrimary: const Color(0xFF9EC5FE),
      surfaceTint: Colors.transparent,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: isDark ? BzColors.darkBg : const Color(0xFFF4F6F9),
      visualDensity: VisualDensity.compact,
      splashFactory: InkSparkle.splashFactory,
    );

    final text = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
      fontFamily: 'Inter',
    );

    final border = scheme.outline;

    return base.copyWith(
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.3),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        bodyMedium: text.bodyMedium?.copyWith(fontSize: 13.5, height: 1.45),
        bodySmall: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: isDark ? BzColors.darkSurfaceAlt : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.8), fontSize: 13.5),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13.5),
        floatingLabelStyle: const TextStyle(color: BzColors.primary, fontWeight: FontWeight.w600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Color(0xFF86B7FE), width: 2),
        ),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: BzColors.danger)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radius), borderSide: const BorderSide(color: BzColors.danger, width: 2)),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius))),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: BorderSide(color: border)),
        textStyle: text.bodyMedium,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
          elevation: const WidgetStatePropertyAll(8),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius), side: BorderSide(color: border))),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusXl)),
        titleTextStyle: text.titleLarge,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: BzColors.gray900, borderRadius: BorderRadius.circular(radiusSm)),
        textStyle: const TextStyle(color: Colors.white, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 400),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        labelStyle: text.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? BzColors.primary : null),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white : null),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? BzColors.primary : null),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: BzColors.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: BzColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: border,
        labelStyle: text.labelLarge,
        unselectedLabelStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: const WidgetStatePropertyAll(false),
        thickness: const WidgetStatePropertyAll(8),
        radius: const Radius.circular(8),
        thumbColor: WidgetStatePropertyAll(scheme.onSurfaceVariant.withValues(alpha: 0.35)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        dense: true,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: text.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: scheme.onSurfaceVariant, letterSpacing: 0.3),
        dataTextStyle: text.bodyMedium,
        dividerThickness: 1,
        headingRowColor: WidgetStatePropertyAll(scheme.surfaceContainerHigh),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: BzColors.primary),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
      }),
    );
  }
}

/// Small shadow presets echoing Bootstrap's `.shadow-sm` / `.shadow` / `.shadow-lg`.
class BzShadows {
  BzShadows._();
  static List<BoxShadow> sm(BuildContext context) => [
        BoxShadow(color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.35 : 0.06), blurRadius: 4, offset: const Offset(0, 1)),
      ];
  static List<BoxShadow> md(BuildContext context) => [
        BoxShadow(color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.45 : 0.10), blurRadius: 16, offset: const Offset(0, 6)),
      ];
  static List<BoxShadow> lg(BuildContext context) => [
        BoxShadow(color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.6 : 0.18), blurRadius: 40, offset: const Offset(0, 16)),
      ];
}
