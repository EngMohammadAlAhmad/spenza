import 'package:flutter/material.dart';
import 'package:spenza/core/utils/responsive_utils.dart';

/// A reusable, responsive sticky bottom container for pinned buttons and footers across Spenza app.
///
/// Features:
/// - Standard rounded top corners (white background, elevation shadow, safe area).
/// - Automatic responsive layout: on mobile, content spans available width;
///   on tablet landscape (or desktop/wider screens), content is automatically centered
///   with a constrained max width (defaults to 450.0).
class AppBottomContainer extends StatelessWidget {
  /// The main child widget inside the bottom container (e.g. [CustomButton] or a Row).
  final Widget child;

  /// Background color (defaults to [Colors.white]).
  final Color backgroundColor;

  /// Border radius of top corners (defaults to `BorderRadius.vertical(top: Radius.circular(24.0))`).
  final BorderRadiusGeometry borderRadius;

  /// Box shadow list (defaults to subtle top shadow).
  final List<BoxShadow>? boxShadow;

  /// Inner padding (defaults to `EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0)`).
  final EdgeInsetsGeometry padding;

  /// Optional fixed height for the container.
  final double? height;

  /// Maximum width for the inner content in tablet landscape or desktop mode (defaults to `450.0`).
  final double maxContentWidth;

  /// Whether to apply safe area at the bottom (defaults to `true`).
  final bool safeAreaBottom;

  const AppBottomContainer({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(24.0)),
    this.boxShadow,
    this.padding = const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 5.0),
    this.height,
    this.maxContentWidth = 450.0,
    this.safeAreaBottom = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // On tablet landscape, desktop, or wide screens (>= 600dp width):
    // Center horizontally and constrain width without expanding vertical height (heightFactor: 1.0).
    final isWide = context.isTabletLandscape || context.isDesktop || MediaQuery.sizeOf(context).width >= 600;
    if (isWide) {
      content = Align(
        alignment: Alignment.center,
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: child,
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16.0,
                offset: const Offset(0, -4),
              ),
            ],
      ),
      child: SafeArea(
        top: false,
        bottom: safeAreaBottom,
        child: Padding(
          padding: padding,
          child: content,
        ),
      ),
    );
  }
}
