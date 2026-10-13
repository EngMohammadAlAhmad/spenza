import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double height;
  final double? width;
  final bool showArrow;
  final bool isOutlined;
  final Widget? icon;
  final Color? underlayerColor;
  final bool isLoading;
  final BorderRadius? borderRadius;

  static const double _underlayerOffset = 2.0;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fontSize,
    this.height = 56.0,
    this.width,
    this.showArrow = false,
    this.isOutlined = false,
    this.icon,
    this.underlayerColor,
    this.isLoading = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.brandRadius;
    final button = _buildButton(context, effectiveRadius);

    return SizedBox(
      width: width ?? double.infinity,
      child: isOutlined
          ? button
          : Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: height + _underlayerOffset,
                  decoration: BoxDecoration(
                    color: underlayerColor ?? AppColors.primaryLight,
                    borderRadius: effectiveRadius,
                  ),
                ),
                // The actual button, pushed down so the strip above shows
                Padding(
                  padding: const EdgeInsets.only(top: _underlayerOffset),
                  child: button,
                ),
              ],
            ),
    );
  }

  Widget _buildButton(BuildContext context, BorderRadius effectiveRadius) {
    final bool isEnabled = onPressed != null;

    final child = isLoading
        ? Center(
            child: SizedBox(
              height: 24.0,
              width: 24.0,
              child: CircularProgressIndicator(
                color: isOutlined ? AppColors.primary : Colors.white,
                strokeWidth: 2.0,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 8.0),
              ],
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isOutlined ? AppColors.primary : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8.0),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ],
          );

    if (isOutlined) {
      return SizedBox(
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveRadius,
            ),
            backgroundColor: underlayerColor,
            padding: EdgeInsets.zero,
          ),
          child: child,
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isEnabled && !isLoading
              ? [AppColors.primaryBold, AppColors.primary]
              : [
                  AppColors.primaryBold.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.3)
                ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: effectiveRadius,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: effectiveRadius,
          ),
          padding: EdgeInsets.zero,
        ),
        child: child,
      ),
    );
  }
}