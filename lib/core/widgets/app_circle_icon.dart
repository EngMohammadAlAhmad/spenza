import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

/// A lightweight, customizable circular wrapper for SVG icons.
class AppCircleIcon extends StatelessWidget {
  final String iconPath;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Color? iconColor;
  final double iconWidth;
  final double iconHeight;
  final VoidCallback? onPressed;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const AppCircleIcon({
    super.key,
    required this.iconPath,
    this.backgroundColor = AppColors.primaryTint,
    this.width = 40.0,
    this.height = 40.0,
    this.iconColor,
    this.iconWidth = 22.0,
    this.iconHeight = 22.0,
    this.onPressed,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: border,
        boxShadow: boxShadow,
      ),
      child: SvgPicture.asset(
        iconPath,
        width: iconWidth,
        height: iconHeight,
        colorFilter: iconColor != null
            ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
            : null,
      ),
    );

    if (onPressed == null) {
      return content;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: content,
    );
  }
}
