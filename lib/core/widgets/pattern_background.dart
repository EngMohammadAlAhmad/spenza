import 'package:flutter/material.dart';
import 'package:spenza/core/utils/app_assets.dart';

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final radialSize = MediaQuery.sizeOf(context).width * 0.85;

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                AppAssets.pattern,
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
                AppAssets.patternRadial,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}