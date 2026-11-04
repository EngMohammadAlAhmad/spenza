import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';

/// A standardized circular back button widget used across the application.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;
  final double size;
  final double iconSize;
  final bool withShadow;

  const AppBackButton({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.icon,
    this.size = 44.0,
    this.iconSize = 20.0,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final VoidCallback effectiveOnTap = onTap ??
            () {
          if (context.canPop()) {
            context.pop();
          } else if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        };

    return InkWell(
      onTap: effectiveOnTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.neutralBackground,
          shape: BoxShape.circle,
          boxShadow: withShadow
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon ?? Icons.arrow_back_ios_new_rounded,
            size: iconSize,
            color: iconColor ?? AppColors.neutral900,
          ),
        ),
      ),
    );
  }
}