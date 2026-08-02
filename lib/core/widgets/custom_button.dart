import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final bool? shareButton;
  final bool? withShadow;

  const CircleActionButton({super.key, required this.icon, required this.onTap, this.shareButton = false, this.backgroundColor = Colors.white, this.withShadow = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: withShadow! ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Icon(
          icon,
          size: 22.0,
          color: shareButton! ? AppColors.primary : AppColors.neutral,
        ),
      ),
    );
  }
}