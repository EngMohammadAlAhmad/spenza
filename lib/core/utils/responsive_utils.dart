import 'package:flutter/material.dart';
import 'package:spenza/core/utils/app_size.dart';

/// Responsive breakpoints following Material Design guidelines
class ResponsiveBreakpoints {
  static const double mobile = 550.0;
  static const double tablet = 850.0;
  static const double desktop = 1100.0;
  static const double wide = 1500.0;
}

/// Screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  wide,
}

/// Device form factor classification considering orientation
enum DeviceFormFactor {
  mobile,
  tabletPortrait,
  tabletLandscape,
  desktop,
}

/// Extension on [BuildContext] for easy, idiomatic responsive UI calls
extension ResponsiveContextX on BuildContext {
  /// Check if device is in landscape mode
  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;

  /// Check if device is in portrait mode
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  /// Check if screen is mobile (<550dp width and shortestSide < 550dp)
  bool get isMobile => MediaQuery.sizeOf(this).shortestSide < 550 && width < 550;

  /// Check if screen is tablet (shortestSide >= 550dp or width >= 550dp)
  bool get isTablet => MediaQuery.sizeOf(this).shortestSide >= 550 || (width >= 550 && width < ResponsiveBreakpoints.desktop);

  /// Check if tablet in portrait mode
  bool get isTabletPortrait => isTablet && isPortrait;

  /// Check if tablet in landscape mode
  bool get isTabletLandscape => (isTablet && isLandscape) || (width >= ResponsiveBreakpoints.tablet);

  /// Check if desktop or wider screen
  bool get isDesktop => width >= ResponsiveBreakpoints.desktop;

  /// Get current device form factor
  DeviceFormFactor get formFactor {
    if (width >= ResponsiveBreakpoints.desktop) {
      return DeviceFormFactor.desktop;
    }
    if (isTablet) {
      return isLandscape ? DeviceFormFactor.tabletLandscape : DeviceFormFactor.tabletPortrait;
    }
    return DeviceFormFactor.mobile;
  }

  /// Select value based on current device screen size & orientation
  T responsiveValue<T>({
    required T mobile,
    T? tabletPortrait,
    T? tabletLandscape,
    T? desktop,
  }) {
    final ff = formFactor;
    switch (ff) {
      case DeviceFormFactor.mobile:
        return mobile;
      case DeviceFormFactor.tabletPortrait:
        return tabletPortrait ?? mobile;
      case DeviceFormFactor.tabletLandscape:
        return tabletLandscape ?? tabletPortrait ?? mobile;
      case DeviceFormFactor.desktop:
        return desktop ?? tabletLandscape ?? tabletPortrait ?? mobile;
    }
  }

  /// Get grid crossAxisCount automatically configured for mobile, tablet portrait & landscape
  int gridColumns({
    int mobile = 2,
    int? tabletPortrait,
    int? tabletLandscape,
    int? desktop,
  }) {
    return responsiveValue<int>(
      mobile: mobile,
      tabletPortrait: tabletPortrait ?? 3,
      tabletLandscape: tabletLandscape ?? 4,
      desktop: desktop ?? 5,
    );
  }

  /// Get responsive horizontal padding
  EdgeInsets responsiveHorizontalPadding({
    double mobile = 16.0,
    double? tabletPortrait,
    double? tabletLandscape,
    double? desktop,
  }) {
    final padding = responsiveValue<double>(
      mobile: mobile,
      tabletPortrait: tabletPortrait ?? 24.0,
      tabletLandscape: tabletLandscape ?? 32.0,
      desktop: desktop ?? 48.0,
    );
    return EdgeInsets.symmetric(horizontal: padding);
  }

  /// Get responsive child aspect ratio for grids
  double gridChildAspectRatio({
    double mobile = 0.75,
    double? tabletPortrait,
    double? tabletLandscape,
    double? desktop,
  }) {
    return responsiveValue<double>(
      mobile: mobile,
      tabletPortrait: tabletPortrait ?? 0.85,
      tabletLandscape: tabletLandscape ?? 0.95,
      desktop: desktop ?? 1.1,
    );
  }
}

/// Responsive utility class for handling different screen sizes
class Responsive {
  Responsive._();

  /// Get current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = context.width;

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
  static bool isMobile(BuildContext context) => context.isMobile;

  /// Check if screen is tablet
  static bool isTablet(BuildContext context) => context.isTablet;

  /// Check if screen is desktop
  static bool isDesktop(BuildContext context) => context.isDesktop;

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
  static int getGridColumns(
    BuildContext context, {
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

/// A widget that switches between Column and Row depending on device mode/orientation
class AdaptiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final bool useRowInTabletPortrait;
  final bool useRowInTabletLandscape;
  final double spacing;

  const AdaptiveRowColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.useRowInTabletPortrait = false,
    this.useRowInTabletLandscape = true,
    this.spacing = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final isRow = (context.isTabletLandscape && useRowInTabletLandscape) ||
        (context.isTabletPortrait && useRowInTabletPortrait) ||
        (context.isDesktop);

    final spacedChildren = spacing > 0 ? _addSpacing(context, isRow) : children;

    if (isRow) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        children: spacedChildren,
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: spacedChildren,
    );
  }

  List<Widget> _addSpacing(BuildContext context, bool isRow) {
    if (children.isEmpty) return [];
    final list = <Widget>[];
    final spacer = isRow ? SizedBox(width: spacing) : SizedBox(height: spacing);
    for (int i = 0; i < children.length; i++) {
      list.add(children[i]);
      if (i < children.length - 1) list.add(spacer);
    }
    return list;
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
