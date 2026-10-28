import 'package:flutter/material.dart';

/// Helper class for quick access to screen dimensions using [MediaQuery].
///
/// Usage examples:
/// - `AppSize.height(context)` or `context.height`
/// - `AppSize.width(context)` or `context.width`
class AppSize {
  AppSize._();

  /// Gets the screen height for the given [BuildContext].
  static double height(BuildContext context) => MediaQuery.sizeOf(context).height;

  /// Gets the screen width for the given [BuildContext].
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  /// Gets the full screen [Size] for the given [BuildContext].
  static Size size(BuildContext context) => MediaQuery.sizeOf(context);

  /// Gets the screen padding (e.g. status bar, notch) for the given [BuildContext].
  static EdgeInsets padding(BuildContext context) => MediaQuery.paddingOf(context);

  /// Gets the view insets (e.g. software keyboard) for the given [BuildContext].
  static EdgeInsets viewInsets(BuildContext context) => MediaQuery.viewInsetsOf(context);
}

/// Extension on [BuildContext] for even shorter access to screen dimensions.
///
/// Usage examples:
/// - `context.height`
/// - `context.width`
extension AppSizeContextX on BuildContext {
  /// Screen height
  double get height => MediaQuery.sizeOf(this).height;

  /// Screen width
  double get width => MediaQuery.sizeOf(this).width;

  /// Full screen [Size]
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Screen padding (e.g. status bar, bottom inset)
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  /// View insets (e.g. keyboard height)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
}
