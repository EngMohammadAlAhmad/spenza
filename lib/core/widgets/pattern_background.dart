import 'package:flutter/material.dart';

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final radialSize = screenSize.width * 0.85;

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/pattern.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            right: -radialSize * 0.47,
            bottom: -radialSize * 0.4,
            width: radialSize,
            height: radialSize,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/pattern_radial.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
