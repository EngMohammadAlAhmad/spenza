import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

/// A customizable, lightweight container wrapper for SVG icons.
/// Supports both rounded rectangle (default using [AppRadius.ordinary]) and circle shapes via [isCircle].
/// Uses theme-aware default colors ([AppColors.neutralBackgroundColor] and [AppColors.textBodyColor]),
/// or primary theme colors ([AppColors.primaryTintColor] and [AppColors.primaryColor]) when [primaryColors] is true.
/// Allows disabling icon tinting via [applyIconColor] set to false.
/// Shows a click/ripple effect matching exact dimensions and shape when [onPressed] is provided.
class AppIconContainer extends StatelessWidget {
  final String iconPath;
  final Color? backgroundColor;
  final double? size;
  final double? width;
  final double? height;
  final Color? iconColor;
  final bool applyIconColor;
  final double? iconSize;
  final double? iconWidth;
  final double? iconHeight;
  final bool isCircle;
  final bool primaryColors;
  final BorderRadius? borderRadius;
  final VoidCallback? onPressed;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const AppIconContainer({
    super.key,
    required this.iconPath,
    this.backgroundColor,
    this.size = 40.0,
    this.width,
    this.height,
    this.iconColor,
    this.applyIconColor = true,
    this.iconSize = 22.0,
    this.iconWidth,
    this.iconHeight,
    this.isCircle = false,
    this.primaryColors = false,
    this.borderRadius,
    this.onPressed,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? size ?? 40.0;
    final effectiveHeight = height ?? size ?? 40.0;
    final effectiveIconWidth = iconWidth ?? iconSize ?? 22.0;
    final effectiveIconHeight = iconHeight ?? iconSize ?? 22.0;

    final effectiveBackgroundColor = backgroundColor ??
        (primaryColors
            ? AppColors.primaryTintColor(context)
            : AppColors.neutralBackgroundColor(context));

    final effectiveIconColor = iconColor ??
        (primaryColors
            ? AppColors.primaryColor(context)
            : AppColors.textBodyColor(context));

    final iconWidget = SvgPicture.asset(
      iconPath,
      width: effectiveIconWidth,
      height: effectiveIconHeight,
      colorFilter: applyIconColor
          ? ColorFilter.mode(effectiveIconColor, BlendMode.srcIn)
          : null,
    );

    // Non-interactive state (no onPressed)
    if (onPressed == null) {
      return Container(
        width: effectiveWidth,
        height: effectiveHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : (borderRadius ?? AppRadius.ordinary),
          border: border,
          boxShadow: boxShadow,
        ),
        child: iconWidget,
      );
    }

    // Interactive state with click/ripple effect matching exact size and shape
    final ShapeBorder shapeBorder = isCircle
        ? const CircleBorder()
        : RoundedRectangleBorder(
            borderRadius: borderRadius ?? AppRadius.ordinary,
          );

    Widget interactiveContent = Material(
      color: effectiveBackgroundColor,
      shape: shapeBorder,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        customBorder: shapeBorder,
        onTap: onPressed,
        child: SizedBox(
          width: effectiveWidth,
          height: effectiveHeight,
          child: Center(
            child: iconWidget,
          ),
        ),
      ),
    );

    if (border != null || boxShadow != null) {
      interactiveContent = Container(
        width: effectiveWidth,
        height: effectiveHeight,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : (borderRadius ?? AppRadius.ordinary),
          border: border,
          boxShadow: boxShadow,
        ),
        child: interactiveContent,
      );
    }

    return interactiveContent;
  }
}
