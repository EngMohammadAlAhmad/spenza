import 'package:flutter/material.dart';

/// A widget that automatically scrolls its child horizontally if it exceeds
/// the available width, functioning like a news ticker / marquee.
class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration pauseDuration;
  final Duration backDuration;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.pauseDuration = const Duration(milliseconds: 1200),
    this.backDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startScrolling() async {
    while (mounted && _scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) {
        await Future.delayed(const Duration(milliseconds: 500));
        continue;
      }

      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_scrollController.hasClients) return;

      final duration = Duration(
        milliseconds: (maxScroll * 30).toInt().clamp(2000, 15000),
      );

      await _scrollController.animateTo(
        maxScroll,
        duration: duration,
        curve: Curves.linear,
      );
      if (!mounted || !_scrollController.hasClients) return;

      await Future.delayed(widget.pauseDuration);
      if (!mounted || !_scrollController.hasClients) return;

      await _scrollController.animateTo(
        0.0,
        duration: widget.backDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: widget.direction,
      physics: const BouncingScrollPhysics(),
      child: widget.child,
    );
  }
}
