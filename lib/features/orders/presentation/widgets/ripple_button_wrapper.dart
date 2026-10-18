import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class RippleButtonWrapper extends StatefulWidget {
  final Widget child;

  const RippleButtonWrapper({
    super.key,
    required this.child,
  });

  @override
  State<RippleButtonWrapper> createState() => _RippleButtonWrapperState();
}

class _RippleButtonWrapperState extends State<RippleButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress1 = _controller.value;
        final progress2 = (progress1 + 0.5) % 1.0;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            _buildRippleRing(progress1),
            _buildRippleRing(progress2),
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _buildRippleRing(double progress) {
    final double spread = progress * 16.0;
    final double opacity = (1.0 - progress).clamp(0.0, 0.7);

    final scaledRadius = BorderRadius.only(
      topLeft: Radius.circular(AppRadius.brandRadius.topLeft.x + spread),
      topRight: Radius.circular(AppRadius.brandRadius.topRight.x + spread),
      bottomLeft: Radius.circular(AppRadius.brandRadius.bottomLeft.x + spread),
      bottomRight: Radius.circular(AppRadius.brandRadius.bottomRight.x + spread),
    );

    return Positioned.fill(
      top: -spread,
      bottom: -spread,
      left: -spread,
      right: -spread,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: scaledRadius,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: opacity),
              width: 2.0,
            ),
            color: AppColors.primary.withValues(alpha: opacity * 0.15),
          ),
        ),
      ),
    );
  }
}
