import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class AppTheme {
  static ThemeData getTheme({required bool isDark, required Locale locale}) {
    final colorScheme = ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? AppColors.primaryDark : AppColors.primary,
      onPrimary: Colors.white,
      secondary: isDark ? AppColors.secondaryDark : AppColors.secondary,
      onSecondary: Colors.black54,
      error: isDark ? AppColors.errorDark : AppColors.errorLight,
      onError: Colors.white,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
    );

    final baseTextColor = isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
    final secondaryTextColor = isDark ? AppColors.secondaryTextDark : AppColors.secondaryTextLight;
    final isArabic = locale.languageCode == 'ar';

    final textTheme = TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: .bold,
        color: baseTextColor,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: .bold,
        color: baseTextColor,
        letterSpacing: -0.3,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: .w600,
        color: baseTextColor,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: .bold,
        color: baseTextColor,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: .w600,
        color: baseTextColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: .w600,
        color: baseTextColor,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: .w600,
        color: baseTextColor,
        fontFamily: 'Zain',
      ),
      titleMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: .w500,
        color: baseTextColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: .w500,
        color: baseTextColor,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: .w400,
        color: baseTextColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: .w400,
        color: baseTextColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: .w400,
        color: secondaryTextColor,
        height: 1.4,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontSize: 14,
        //fontWeight: .w600,
        color: baseTextColor,
        letterSpacing: 0.3,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: .w500,
        color: baseTextColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: .w500,
        color: secondaryTextColor,
        letterSpacing: 0.5,
      ),
    );

    final inputAppRadius = AppRadius.medium;

    final inputBorder = OutlineInputBorder(
      borderRadius: inputAppRadius,
      borderSide: BorderSide(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
        width: 1.5,
      ),
    );

    final focusedInputBorder = OutlineInputBorder(
      borderRadius: inputAppRadius,
      borderSide: BorderSide(
        color: colorScheme.primary,
        width: 1.0,
      ),
    );

    final errorInputBorder = OutlineInputBorder(
      borderRadius: inputAppRadius,
      borderSide: BorderSide(
        color: colorScheme.error,
        width: 1.0,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      primaryColor: colorScheme.primary,
      disabledColor: isDark ? AppColors.disabledDark : AppColors.disabledLight,
      textTheme: textTheme,
      fontFamily: 'Zain',

      // APP BAR
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge,
        surfaceTintColor: Colors.transparent,
      ),

      // ICONS
      iconTheme: IconThemeData(
        color: baseTextColor,
        size: 24.0,
      ),

      // ELEVATED BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: .normal,
            letterSpacing: 0.3,
            fontFamily: 'Zain',
          ),
        ),
      ),

      // OUTLINED BUTTON
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.primary, width: 1.5),
          foregroundColor: colorScheme.primary,
          padding: const .symmetric(horizontal: 24.0, vertical: 14.0),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
          textStyle: TextStyle(
            fontSize: 14.0,
            fontWeight: .bold,
            letterSpacing: 0.3,
            fontFamily: 'Zain',
          ),
        ),
      ),

      // TEXT BUTTON
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.secondary,
          padding: const .symmetric(horizontal: 16.0, vertical: 10.0),
          textStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: .normal,
            letterSpacing: 0.2,
            fontFamily: 'Zain',
          ),
        ),
      ),

      // FLOATING ACTION BUTTON
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.overMedium,
        ),
      ),

      // INPUT / TEXTFORMFIELD
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.cardDark : Colors.white,
        contentPadding: const .symmetric(horizontal: 16.0, vertical: 14.0),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: focusedInputBorder,
        errorBorder: errorInputBorder,
        focusedErrorBorder: errorInputBorder,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: secondaryTextColor,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: secondaryTextColor,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.error,
          fontSize: 12,
        ),
      ),

      // CARD
      cardTheme: CardThemeData(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        margin: const .all(8.0),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.overMedium,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.0,
          ),
        ),
      ),

      // CHIP
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        selectedColor: colorScheme.primary.withValues(alpha: 0.12),
        labelStyle: textTheme.bodyMedium!,
        secondaryLabelStyle: textTheme.bodyMedium!,
        padding: const .symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.small,
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),

      // SWITCH
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return isDark ? AppColors.borderDark : AppColors.borderLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark
              ? AppColors.borderDark.withValues(alpha: 0.5)
              : AppColors.borderLight.withValues(alpha: 0.5);
        }),
      ),

      // BOTTOM NAV BAR
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: secondaryTextColor,
        selectedLabelStyle: textTheme.bodySmall,
        unselectedLabelStyle: textTheme.bodySmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // DIALOG
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
        ),
      ),

      // DIVIDER
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),

      // SNACKBAR
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? AppColors.cardDark : const Color(0xFF1E293B),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
      ),

      // CHECKBOX
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mini,
        ),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.0,
        ),
      ),

      // RADIO
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return isDark ? AppColors.borderDark : AppColors.borderLight;
        }),
      ),

      // PROGRESS INDICATOR
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: isDark ? AppColors.borderDark : AppColors.borderLight,
      ),

      // LIST TILE
      listTileTheme: ListTileThemeData(
        contentPadding: const .symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
        ),
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.08),
        selectedColor: colorScheme.primary,
      ),
    );
  }
}