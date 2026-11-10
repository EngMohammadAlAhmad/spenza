import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/features/points_market/presentation/widgets/how_to_earn_points_card.dart';
import 'package:spenza/features/points_market/presentation/widgets/points_market_header.dart';

class PointsMarketScreen extends StatelessWidget {
  const PointsMarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const PointsMarketHeader()
                .animate()
                .fadeIn(duration: 500.ms)
                .slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (isTabletLandscape)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: const HowToEarnPointsCard()
                              .animate(delay: 150.ms)
                              .fadeIn(duration: 500.ms)
                              .slideY(
                                  begin: 0.08,
                                  end: 0,
                                  curve: Curves.easeOutCubic),
                        ),
                        const SizedBox(width: 16.0),
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    )
                  else
                    const HowToEarnPointsCard()
                        .animate(delay: 150.ms)
                        .fadeIn(duration: 500.ms)
                        .slideY(
                            begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 24.0),

                  // Section surrounded by blue line in design image (rewards list API call - currently empty as requested)
                  const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
