import 'package:flutter/material.dart';

class AnimatedBranchContainer extends StatelessWidget {
  final int currentIndex;
  final List<Widget> children;

  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (index) {
        Offset targetOffset;
        if (index == currentIndex) {
          targetOffset = Offset.zero;
        } else if (index < currentIndex) {
          targetOffset = const Offset(1.0, 0.0);
        } else {
          targetOffset = const Offset(-1.0, 0.0);
        }

        return TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(
            begin: targetOffset,
            end: targetOffset,
          ),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return FractionalTranslation(
              translation: value,
              child: child,
            );
          },
          child: IgnorePointer(
            ignoring: index != currentIndex,
            child: TickerMode(
              enabled: index == currentIndex,
              child: children[index],
            ),
          ),
        );
      }),
    );
  }
}