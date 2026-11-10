import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

typedef RippleChildBuilder = Widget Function(BuildContext context, Color animatedColor);

class RippleButtonWrapper extends StatefulWidget {
  final Widget? child;
  final RippleChildBuilder? builder;
  final BorderRadius? borderRadius;
  final Color? color;
  final double minOpacity;
  final double maxOpacity;

  const RippleButtonWrapper({
    super.key,
    this.child,
    this.builder,
    this.borderRadius,
    this.color,
    this.minOpacity = 0.0,
    this.maxOpacity = 1.0,
  }) : assert(child != null || builder != null, 'Either child or builder must be provided');

  @override
  State<RippleButtonWrapper> createState() => _RippleButtonWrapperState();
}

class _RippleButtonWrapperState extends State<RippleButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textColorAnimation = ColorTween(
      begin: widget.color ?? AppColors.primary,
      end: Colors.white,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? AppRadius.brandRadius;
    final pulseColor = widget.color ?? AppColors.primary;

    return ClipRRect(
      borderRadius: effectiveRadius,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final animatedColor = _textColorAnimation.value ?? AppColors.primary;
          final currentChild = widget.builder != null
              ? widget.builder!(context, animatedColor)
              : widget.child!;

          final opacityVal = _opacityAnimation.value.clamp(0.0, 1.0);

          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulsing Background Fill (Strictly inside button border)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: pulseColor.withValues(alpha: opacityVal),
                    borderRadius: effectiveRadius,
                  ),
                ),
              ),
              // Child Button
              currentChild,
            ],
          );
        },
      ),
    );
  }
}
