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
    this.minOpacity = 0.05,
    this.maxOpacity = 0.35,
  }) : assert(child != null || builder != null, 'Either child or builder must be provided');

  @override
  State<RippleButtonWrapper> createState() => _RippleButtonWrapperState();
}

class _RippleButtonWrapperState extends State<RippleButtonWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale1XAnimation;
  late Animation<double> _scale1YAnimation;
  late Animation<double> _scale2XAnimation;
  late Animation<double> _scale2YAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    )..repeat(reverse: true);

    _scale1XAnimation = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scale1YAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale2XAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _scale2YAnimation = Tween<double>(begin: 1.0, end: 1.24).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

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

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final animatedColor = _textColorAnimation.value ?? AppColors.primary;
        final currentChild = widget.builder != null
            ? widget.builder!(context, animatedColor)
            : widget.child!;

        final opacityVal = _opacityAnimation.value.clamp(0.0, 1.0);

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer Soft Ambient Glow
            Positioned.fill(
              child: Transform.scale(
                scaleX: _scale2XAnimation.value,
                scaleY: _scale2YAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: pulseColor.withValues(alpha: (opacityVal * 0.5).clamp(0.0, 1.0)),
                    borderRadius: effectiveRadius,
                  ),
                ),
              ),
            ),
            // Inner Breathing Ring
            Positioned.fill(
              child: Transform.scale(
                scaleX: _scale1XAnimation.value,
                scaleY: _scale1YAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: pulseColor.withValues(alpha: opacityVal),
                    borderRadius: effectiveRadius,
                  ),
                ),
              ),
            ),
            // Child Button
            currentChild,
          ],
        );
      },
    );
  }
}
