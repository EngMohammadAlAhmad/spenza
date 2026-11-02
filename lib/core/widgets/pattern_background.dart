import 'package:flutter/material.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';

class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    
    // Scaled-down size for patternRadial so it sits subtly in the corner
    final radialSize = isTablet ? 260.0 : (context.width * 0.65).clamp(200.0, 300.0);

    return IgnorePointer(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.035,
              child: Image.asset(
                AppAssets.pattern,
                scale: isTablet ? 2.6 : 1.8, // Higher scale value zooms out the pattern tiles
                repeat: ImageRepeat.repeat,  // Fills the whole screen seamlessly
              ),
            ),
          ),
          Positioned(
            right: -radialSize * 0.44,
            bottom: -radialSize * 0.4,
            width: radialSize,
            height: radialSize,
            child: Opacity(
              opacity: 0.12,
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
