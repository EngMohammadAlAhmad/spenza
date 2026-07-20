import 'package:flutter/material.dart';

enum RevealStyle { fadeSlideUp, fadeScale, fadeOnly }

class Reveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final RevealStyle style;

  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.style = RevealStyle.fadeSlideUp,
  });

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: curved,
      child: widget.child,
      builder: (context, child) {
        Widget result = Opacity(opacity: curved.value, child: child);
        switch (widget.style) {
          case RevealStyle.fadeSlideUp:
            return Transform.translate(
              offset: Offset(0, (1 - curved.value) * 16),
              child: result,
            );
          case RevealStyle.fadeScale:
            return Transform.scale(scale: 0.9 + (0.1 * curved.value), child: result);
          case RevealStyle.fadeOnly:
            return result;
        }
      },
    );
  }
}