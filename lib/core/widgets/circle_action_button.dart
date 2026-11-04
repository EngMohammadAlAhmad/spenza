import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleActionButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final bool? withShadow;

  const CircleActionButton({
    super.key,
    required this.iconPath,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: withShadow!
              ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: SvgPicture.asset(
          iconPath,
          height: 22.0,
          width: 22.0,
        ),
      ),
    );
  }
}