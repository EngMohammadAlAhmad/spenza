import 'package:flutter/material.dart';

/// Responsive breakpoints following Material Design guidelines
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double wide = 1600;
}

/// Screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  wide,
}

/// Responsive utility class for handling different screen sizes
class Responsive {
  /// Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < ResponsiveBreakpoints.mobile) {
      return ScreenSize.mobile;
    } else if (width < ResponsiveBreakpoints.tablet) {
      return ScreenSize.tablet;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return ScreenSize.desktop;
    } else {
      return ScreenSize.wide;
    }
  }

  /// Check if screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  }

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.mobile &&
        width < ResponsiveBreakpoints.tablet;
  }

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.tablet;
  }

  /// Check if screen is wide desktop
  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.wide;
  }

  /// Get responsive value based on screen size
  static T value<T>(
      BuildContext context, {
        required T mobile,
        T? tablet,
        T? desktop,
        T? wide,
      }) {
    final screenSize = getScreenSize(context);

    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.wide:
        return wide ?? desktop ?? tablet ?? mobile;
    }
  }

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
    int wide = 4,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
  }

  /// Get responsive padding
  static EdgeInsets getPadding(BuildContext context, {
    double mobile = 16,
    double? tablet,
    double? desktop,
    double? wide,
  }) {
    final padding = value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
    return .all(padding);
  }

  /// Get responsive horizontal padding
  static EdgeInsets getHorizontalPadding(BuildContext context, {
    double mobile = 16.0,
    double? tablet,
    double? desktop,
    double? wide,
  }) {
    final padding = value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
    return .symmetric(horizontal: padding);
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
    double? wide,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
  }

  /// Calculate child aspect ratio for grid based on screen width
  static double getChildAspectRatio(BuildContext context, {
    double mobile = 0.75,
    double tablet = 1.0,
    double desktop = 1.2,
    double wide = 1.3,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
  }

  /// Get responsive spacing
  static double spacing(BuildContext context, {
    double mobile = 8,
    double? tablet,
    double? desktop,
    double? wide,
  }) {
    return value(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      wide: wide,
    );
  }
}

/// Widget that builds different layouts based on screen size
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Responsive.getScreenSize(context);
    return builder(context, screenSize);
  }
}

/// Widget for conditionally showing content based on screen size
class ResponsiveVisibility extends StatelessWidget {
  final Widget child;
  final bool mobile;
  final bool tablet;
  final bool desktop;
  final bool wide;

  const ResponsiveVisibility({
    super.key,
    required this.child,
    this.mobile = true,
    this.tablet = true,
    this.desktop = true,
    this.wide = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = Responsive.getScreenSize(context);

    final shouldShow = switch (screenSize) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
      ScreenSize.wide => wide,
    };

    return shouldShow ? child : const SizedBox.shrink();
  }
}