import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFD46B60);
  static const Color primaryBold = Color(0xFFA94443);
  static const Color primary500 = Color(0xFFC74436);
  static const Color primary600 = Color(0xFF9D352B);
  static const Color primary700 = Color(0xFF772820);
  static const Color primaryDark = Color(0xFFE1968F);
  static const Color primaryLight = Color(0xFFEFC6C2);
  static const Color primaryTint = Color(0xFFFAE6E3);
  static const Color primaryTintDark = Color(0xFF3A1410);

  static const Color neutral = Color(0xFF737373);
  static const Color neutral200 = Color(0xFFF0F0F0);

  static const Color neutralBackground = Color(0xFFF7F4F0);
  static const Color neutralBackgroundDark = Color(0xFF292826);
  static const Color neutralBackgroundCanvasDark = Color(0xFF151414);

  static const Color neutralBorderStrong = Color(0xFFDDD8D2);
  static const Color neutral700 = Color(0xFF555555);
  static const Color neutral900 = Color(0xFF444444);

  static const Color secondary = Color(0xFFF2B211);
  static const Color secondaryDark = Color(0xFFF59E0B);
  static const Color secondaryTint = Color(0xFFFDF2D3);
  static const Color secondaryTintDark = Color(0xFF423104);

  static const Color tertiary = Color(0xFF756F6A);
  static const Color tertiaryDark = Color(0xFF9C9792);

  static const Color fillColor = Color(0xFFF6F2EC);
  static const Color borderColor = Color(0xFF383839);

  // Surfaces / backgrounds
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color backgroundLight = Color(0xFFF9F9F9);

  static const Color neutralBackgroundSurface = Color(0xFFFFFFFF);
  static const Color neutralBackgroundSurfaceDark = Color(0xFF1F1E1D);

  // Card/Container surfaces
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardBackgroundLight = Color(0xFFE6E7E8);
  static const Color cardDark = Color(0xFF262524);

  // Text on surface
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);

  // Secondary text
  static const Color secondaryTextLight = Color(0xFF64748B);
  static const Color secondaryTextDark = Color(0xFF94A3B8);
  static const Color textSecondary = Color(0xFF9D9791);
  static const Color textBody = Color(0xFF57524E);
  static const Color textBodyDark = Color(0xFFC9C5C1);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textPrimaryDark = Color(0xFFF2F0EE);

  // Success
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color successForeground = Color(0xFF0F5C3B);

  // Warning
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);
  static const Color warningAlert = Color(0xFF735406);

  // Error
  static const Color error = Color(0xFFD00416);
  static const Color alert = Color(0xFFFB3748);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);


  // Borders
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF383634);

  // Disabled
  static const Color disabledLight = Color(0xFFCBD5E1);
  static const Color disabledDark = Color(0xFF475569);

  // Hover states
  static const Color hoverLight = Color(0xFFF1F5F9);
  static const Color hoverDark = Color(0xFF334155);

  // Divider
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color dividerDark = Color(0xFF383634);

  static const Color blue = Color(0xFF566AB0);
  static const Color blue2 = Color(0xFF1447E6);
  static const Color blueAccent = Color(0xFFDBEAFE);
  static const Color grey = Color(0xFFB9B3A9);
  static const Color neutralBackgroundInverse = Color(0xFF1A1A1A);
  static const Color neutralBorderDefault = Color(0xFFEEEAE5);
  static const Color thirdAccent = Color(0xFFE9ECF7);

  // Central Theme-Aware Color Helpers
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color primaryColor(BuildContext context) {
    return isDarkMode(context) ? primaryDark : primary;
  }
  static Color primaryStrongColor(BuildContext context) {
    return isDarkMode(context) ? primaryLight : primaryBold;
  }

  static Color tertiaryColor(BuildContext context) {
    return isDarkMode(context) ? tertiaryDark : tertiary;
  }

  static Color primaryTintColor(BuildContext context) {
    return isDarkMode(context) ? primaryTintDark : primaryTint;
  }

  static Color secondaryTintColor(BuildContext context) {
    return isDarkMode(context) ? secondaryTintDark : secondaryTint;
  }

  static Color secondaryColor(BuildContext context) {
    return isDarkMode(context) ? secondaryDark : secondary;
  }

  static Color neutralBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? neutralBackgroundDark : neutralBackground;
  }

  static Color neutralBackgroundCanvasColor(BuildContext context) {
    return isDarkMode(context) ? neutralBackgroundCanvasDark : neutralBackground;
  }

  static Color neutralBackgroundSurfaceColor(BuildContext context) {
    return isDarkMode(context) ? neutralBackgroundSurfaceDark : neutralBackgroundSurface;
  }

  static Color textBodyColor(BuildContext context) {
    return isDarkMode(context) ? textBodyDark : textBody;
  }

  static Color cardBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? cardDark : cardLight;
  }

  static Color badgeColor(BuildContext context) {
    return isDarkMode(context) ? borderDark : cardLight;
  }

  static Color badgeInactiveColor(BuildContext context) {
    return isDarkMode(context) ? grey.withValues(alpha: 0.2) : neutralBorderDefault;
  }

  static Color bottomSheetBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? cardDark : const Color(0xFFF9F6F2);
  }

  static Color headerBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? cardDark : backgroundLight;
  }

  static Color containerBoxBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF333130) : neutralBackground;
  }

  static Color placeholderColor(BuildContext context) {
    return isDarkMode(context) ? dividerDark : secondaryTint;
  }

  static Color tileIconBackgroundColor(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF383634) : neutralBackground;
  }

  static Color textPrimaryColor(BuildContext context) {
    return isDarkMode(context) ? textPrimaryDark : textPrimary;
  }

  static Color secondaryTextColor(BuildContext context) {
    return isDarkMode(context) ? secondaryTextDark : tertiary;
  }

  static Color dividerColor(BuildContext context) {
    return isDarkMode(context) ? dividerDark : neutral200;
  }

  static Color getDisabledColor(BuildContext context) {
    return isDarkMode(context) ? disabledDark : disabledLight;
  }

  static Color getErrorColor(BuildContext context) {
    return isDarkMode(context) ? errorDark : errorLight;
  }

  static Color getSuccessColor(BuildContext context) {
    return isDarkMode(context) ? successDark : successLight;
  }

  static Color getWarningColor(BuildContext context) {
    return isDarkMode(context) ? warningDark : warningLight;
  }

  static Color dragHandleColor(BuildContext context) {
    return isDarkMode(context) ? const Color(0xFF616161) : const Color(0xFFE0E0E0);
  }

  static Color cardShadow(BuildContext context) {
    return isDarkMode(context)
        ? Colors.black.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.04);
  }
}
