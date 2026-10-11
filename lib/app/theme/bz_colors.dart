import 'package:flutter/material.dart';

/// Bootstrap 5 colour tokens, adapted for Flutter.
///
/// The app deliberately speaks "Bootstrap": primary / secondary / success /
/// danger / warning / info / light / dark, plus subtle tints for badges,
/// alerts and soft buttons (the `-subtle` and `-emphasis` tokens of BS 5.3).
class BzColors {
  BzColors._();

  // Core palette (Bootstrap 5.3)
  static const Color primary = Color(0xFF0D6EFD);
  static const Color secondary = Color(0xFF6C757D);
  static const Color success = Color(0xFF198754);
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF0DCAF0);
  static const Color light = Color(0xFFF8F9FA);
  static const Color dark = Color(0xFF212529);

  // Extended palette
  static const Color indigo = Color(0xFF6610F2);
  static const Color purple = Color(0xFF6F42C1);
  static const Color pink = Color(0xFFD63384);
  static const Color orange = Color(0xFFFD7E14);
  static const Color teal = Color(0xFF20C997);
  static const Color cyan = Color(0xFF0DCAF0);

  // Brand accent: the "buzz" amber used sparingly for highlights.
  static const Color buzz = Color(0xFFFFB300);

  // Greys
  static const Color gray100 = Color(0xFFF8F9FA);
  static const Color gray200 = Color(0xFFE9ECEF);
  static const Color gray300 = Color(0xFFDEE2E6);
  static const Color gray400 = Color(0xFFCED4DA);
  static const Color gray500 = Color(0xFFADB5BD);
  static const Color gray600 = Color(0xFF6C757D);
  static const Color gray700 = Color(0xFF495057);
  static const Color gray800 = Color(0xFF343A40);
  static const Color gray900 = Color(0xFF212529);

  // Subtle backgrounds (light mode)
  static const Color primarySubtle = Color(0xFFCFE2FF);
  static const Color successSubtle = Color(0xFFD1E7DD);
  static const Color dangerSubtle = Color(0xFFF8D7DA);
  static const Color warningSubtle = Color(0xFFFFF3CD);
  static const Color infoSubtle = Color(0xFFCFF4FC);
  static const Color secondarySubtle = Color(0xFFE2E3E5);
  static const Color darkSubtle = Color(0xFFCED4DA);

  // Emphasis text on subtle backgrounds (light mode)
  static const Color primaryEmphasis = Color(0xFF052C65);
  static const Color successEmphasis = Color(0xFF0A3622);
  static const Color dangerEmphasis = Color(0xFF58151C);
  static const Color warningEmphasis = Color(0xFF664D03);
  static const Color infoEmphasis = Color(0xFF055160);
  static const Color secondaryEmphasis = Color(0xFF2B2F32);

  // Dark-mode surfaces
  static const Color darkBg = Color(0xFF121418);
  static const Color darkSurface = Color(0xFF1B1F26);
  static const Color darkSurfaceAlt = Color(0xFF232833);
  static const Color darkBorder = Color(0xFF2F3541);
}

/// Semantic variant used across buttons, badges, alerts and toasts.
enum BzVariant { primary, secondary, success, danger, warning, info, light, dark, buzz }

extension BzVariantX on BzVariant {
  Color get color => switch (this) {
        BzVariant.primary => BzColors.primary,
        BzVariant.secondary => BzColors.secondary,
        BzVariant.success => BzColors.success,
        BzVariant.danger => BzColors.danger,
        BzVariant.warning => BzColors.warning,
        BzVariant.info => BzColors.info,
        BzVariant.light => BzColors.light,
        BzVariant.dark => BzColors.dark,
        BzVariant.buzz => BzColors.buzz,
      };

  /// Foreground that is readable on [color] (Bootstrap uses dark text on
  /// warning / info / light).
  Color get onColor => switch (this) {
        BzVariant.warning || BzVariant.info || BzVariant.light || BzVariant.buzz => BzColors.gray900,
        _ => Colors.white,
      };

  Color subtle(Brightness b) {
    if (b == Brightness.dark) return color.withValues(alpha: 0.18);
    return switch (this) {
      BzVariant.primary => BzColors.primarySubtle,
      BzVariant.secondary => BzColors.secondarySubtle,
      BzVariant.success => BzColors.successSubtle,
      BzVariant.danger => BzColors.dangerSubtle,
      BzVariant.warning => BzColors.warningSubtle,
      BzVariant.info => BzColors.infoSubtle,
      BzVariant.light => BzColors.gray100,
      BzVariant.dark => BzColors.darkSubtle,
      BzVariant.buzz => const Color(0xFFFFF0C2),
    };
  }

  Color emphasis(Brightness b) {
    if (b == Brightness.dark) {
      return switch (this) {
        BzVariant.primary => const Color(0xFF6EA8FE),
        BzVariant.secondary => const Color(0xFFA7ACB1),
        BzVariant.success => const Color(0xFF75B798),
        BzVariant.danger => const Color(0xFFEA868F),
        BzVariant.warning => const Color(0xFFFFDA6A),
        BzVariant.info => const Color(0xFF6EDFF6),
        BzVariant.light => BzColors.gray300,
        BzVariant.dark => BzColors.gray300,
        BzVariant.buzz => const Color(0xFFFFD36A),
      };
    }
    return switch (this) {
      BzVariant.primary => BzColors.primaryEmphasis,
      BzVariant.secondary => BzColors.secondaryEmphasis,
      BzVariant.success => BzColors.successEmphasis,
      BzVariant.danger => BzColors.dangerEmphasis,
      BzVariant.warning => BzColors.warningEmphasis,
      BzVariant.info => BzColors.infoEmphasis,
      BzVariant.light => BzColors.gray700,
      BzVariant.dark => BzColors.gray900,
      BzVariant.buzz => const Color(0xFF664D03),
    };
  }
}
