import 'package:flutter/material.dart';

/// Custom text styles for the app
/// Usage: Text('Hello', style: AppTextStyles.heading1(context))
class AppTextStyles {
  // ============ HEADINGS ============

  /// Main page heading - 32px, bold
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontSize: 32.0,
      fontWeight: .bold,
      color: Theme.of(context).colorScheme.onSurface,
      letterSpacing: -0.5,
    );
  }

  /// Section heading - 24px, semi-bold
  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontSize: 24.0,
      fontWeight: .bold,
      color: Theme.of(context).colorScheme.onSurface,
      letterSpacing: -0.3,
    );
  }

  /// Subsection heading - 20px, semi-bold
  static TextStyle heading3(BuildContext context) {
    return TextStyle(
      fontSize: 20.0,
      fontWeight: .w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  /// Card/Widget heading - 18px, semi-bold
  static TextStyle heading4(BuildContext context) {
    return TextStyle(
      fontSize: 18.0,
      fontWeight: .w600,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // ============ BODY TEXT ============

  /// Regular body text - 16px, normal
  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: .w400,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.5,
    );
  }

  /// Default body text - 14px, normal
  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: .w400,
      fontFamily: 'Zain',
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.5,
    );
  }

  /// Small body text - 12px, normal
  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: .w400,
      fontFamily: 'Zain',
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.4,
    );
  }

  // ============ SECONDARY/MUTED TEXT ============

  /// Secondary text - medium weight with reduced opacity
  static TextStyle textSecondary(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 14.0,
      fontWeight: .w400,
      color: isDark
          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)
          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      height: 1.5,
    );
  }

  /// Caption/Helper text - 12px, muted
  static TextStyle caption(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12.0,
      fontWeight: .w400,
      color: isDark
          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      height: 1.3,
    );
  }

  // ============ LABELS & BUTTONS ============

  /// Button text - 14px, semi-bold
  static TextStyle button(BuildContext context) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: .w600,
      letterSpacing: 0.3,
    );
  }

  /// Large button text - 16px, semi-bold
  static TextStyle buttonLarge(BuildContext context) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: .w600,
      letterSpacing: 0.3,
    );
  }

  /// Small button text - 12px, semi-bold
  static TextStyle buttonSmall(BuildContext context) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: .w600,
      letterSpacing: 0.2,
    );
  }

  /// Label text - 13px, medium
  static TextStyle label(BuildContext context) {
    return TextStyle(
      fontSize: 13.0,
      fontWeight: .w500,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // ============ SPECIAL STYLES ============

  /// Overline text (small caps) - 11px, bold, uppercase
  static TextStyle overline(BuildContext context) {
    return TextStyle(
      fontSize: 11.0,
      fontWeight: .w700,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
      letterSpacing: 1.5,
    );
  }

  /// Numbers/Stats - 28px, bold
  static TextStyle statNumber(BuildContext context) {
    return TextStyle(
      fontSize: 28.0,
      fontWeight: .bold,
      color: Theme.of(context).colorScheme.onSurface,
      height: 1.2,
    );
  }

  /// Link text - 14px, underlined
  static TextStyle link(BuildContext context) {
    return TextStyle(
      fontSize: 14.0,
      fontWeight: .w500,
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );
  }

  /// Error text - 12px, error color
  static TextStyle error(BuildContext context) {
    return TextStyle(
      fontSize: 12.0,
      fontWeight: .w400,
      color: Theme.of(context).colorScheme.error,
      height: 1.3,
    );
  }

  /// Success text - 12px, success color
  static TextStyle success(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: 12.0,
      fontWeight: .w500,
      color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
      height: 1.3,
    );
  }
}