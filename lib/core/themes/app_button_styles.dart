import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_radius.dart';

/// Custom button styles for the app
/// Usage: ElevatedButton(style: AppButtonStyles.primary(context), ...)
class AppButtonStyles {
  // ============ ELEVATED BUTTONS ============

  /// Primary button - main action button
  static ButtonStyle primary(BuildContext context) {
    //final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 4;
        }
        if (states.contains(WidgetState.pressed)) {
          return 1;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.15);
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.25);
        }
        return null;
      }),
    );
  }

  /// Secondary button - less emphasis
  static ButtonStyle secondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF1F5F9),
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 2;
        }
        return 0;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0);
        }
        if (states.contains(WidgetState.pressed)) {
          return isDark
              ? const Color(0xFF475569)
              : const Color(0xFFCBD5E1);
        }
        return isDark
            ? const Color(0xFF1E293B)
            : const Color(0xFFF1F5F9);
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05);
        }
        if (states.contains(WidgetState.pressed)) {
          return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        }
        return null;
      }),
    );
  }

  /// Success button - for positive actions
  static ButtonStyle success(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = isDark ? const Color(0xFF34D399) : const Color(0xFF10B981);
    return ElevatedButton.styleFrom(
      backgroundColor: successColor,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 4;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        successColor.withValues(alpha: 0.4),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.15);
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.25);
        }
        return null;
      }),
    );
  }

  /// Danger button - for destructive actions
  static ButtonStyle danger(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.error,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    ).copyWith(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 4;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.error.withValues(alpha: 0.4),
      ),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withValues(alpha: 0.15);
        }
        if (states.contains(WidgetState.pressed)) {
          return Colors.white.withValues(alpha: 0.25);
        }
        return null;
      }),
    );
  }

  // ============ OUTLINED BUTTONS ============

  /// Outlined primary button
  static ButtonStyle outlinedPrimary(BuildContext context) {
    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 1.5,
      ),
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    ).copyWith(
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.0,
          );
        }
        return BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        );
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return 2;
        }
        return 0;
      }),
      shadowColor: WidgetStateProperty.all(
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Theme.of(context).colorScheme.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.pressed)) {
          return Theme.of(context).colorScheme.primary.withValues(alpha: 0.15);
        }
        return Colors.transparent;
      }),
    );
  }

  /// Outlined secondary button
  static ButtonStyle outlinedSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return OutlinedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      side: BorderSide(color: borderColor, width: 1.5),
      padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        letterSpacing: 0.3,
      ),
    );
  }

  // ============ TEXT BUTTONS ============

  /// Text button - minimal style
  static ButtonStyle text(BuildContext context) {
    return TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.secondary,
      padding: const .symmetric(horizontal: 16.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.small,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: .w600,
        letterSpacing: 0.2,
        fontFamily: 'Baloo2',
      ),
    );
  }

  // ============ SIZE VARIATIONS ============

  /// Large button padding
  static ButtonStyle large(BuildContext context, ButtonStyle baseStyle) {
    return baseStyle.copyWith(
      padding: WidgetStateProperty.all(
        const .symmetric(horizontal: 32.0, vertical: 16.0),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 16,
          fontWeight: .w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  /// Small button padding
  static ButtonStyle small(BuildContext context, ButtonStyle baseStyle) {
    return baseStyle.copyWith(
      padding: WidgetStateProperty.all(
        const .symmetric(horizontal: 16.0, vertical: 10.0),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: .w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  /// Icon button - square shape
  static ButtonStyle icon(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.styleFrom(
      backgroundColor: isDark
          ? const Color(0xFF1E293B)
          : const Color(0xFFF1F5F9),
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      elevation: 0,
      padding: const .all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.medium,
      ),
      minimumSize: const Size(44.0, 44.0),
    );
  }
}