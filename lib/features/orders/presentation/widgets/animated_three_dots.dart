import 'package:flutter/material.dart';

class AnimatedThreeDots extends StatefulWidget {
  final Color color;

  const AnimatedThreeDots({
    super.key,
    this.color = Colors.white,
  });

  @override
  State<AnimatedThreeDots> createState() => _AnimatedThreeDotsState();
}

class _AnimatedThreeDotsState extends State<AnimatedThreeDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
        final val = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: List.generate(3, (index) {
            final dotProgress = (val - (index * 0.2)) % 1.0;
            final scale = 0.5 + 0.5 * (1.0 - (dotProgress - 0.5).abs() * 2.0).clamp(0.0, 1.0);
            final opacity = 0.3 + 0.7 * (1.0 - (dotProgress - 0.5).abs() * 2.0).clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              width: 6.0 * scale,
              height: 6.0 * scale,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
