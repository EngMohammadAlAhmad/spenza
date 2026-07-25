import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';

class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final ShapeBorder? shapeBorder;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shapeBorder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: shapeBorder == null
          ? BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.5),
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            )
          : ShapeDecoration(
              color: AppColors.primary.withValues(alpha: 0.5),
              shape: shapeBorder!,
            ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: AppColors.secondary.withValues(alpha: 0.5),
        );
  }
}
