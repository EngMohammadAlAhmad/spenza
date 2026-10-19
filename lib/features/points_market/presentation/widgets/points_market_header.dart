import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';

class PointsMarketHeader extends StatelessWidget {
  const PointsMarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsMarketBloc, BaseState<PointsSummaryEntity>>(
      builder: (context, state) {
        final points = state.data?.balance ?? 0;

        return AppHeader(
          style: AppHeaderStyle.gradient,
          title: 'سوق النقاط',
          onBackPressed: () => Navigator.pop(context),
          trailingActions: [
            IconButton(
              onPressed: () => context.push(RoutePaths.pointsHistory),
              icon: SvgPicture.asset(AppAssets.activityIcon),
            ),
          ],
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8.0,
            left: 16.0,
            right: 16.0,
            bottom: 24.0,
          ),
          bottomChild: Column(
            spacing: 12.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Points Balance Row
              Row(
                spacing: 14.0,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 56.0,
                    width: 56.0,
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.upMedium,
                      color: Colors.white,
                    ),
                    child: SvgPicture.asset(AppAssets.iconSmall),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'رصيدك',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14.0,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$points ',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: 'نقطة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Glassmorphism Progress Container
              Container(
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: AppRadius.upMedium,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'أول طلب بيبلشلك الرصيد. طلب بـ 50,000 ل.س بيعطيك 50 نقطة.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.95),
                        fontSize: 12.5,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10.0),
                    ClipRRect(
                      borderRadius: AppRadius.ordinary,
                      child: LinearProgressIndicator(
                        value: 0.92,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFF2B211),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Action Buttons Row
              Row(
                spacing: 10.0,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // My Rewards button
                  GestureDetector(
                    onTap: () => context.push(RoutePaths.myRewards),
                    child: Container(
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.extraLarge,
                      ),
                      child: const Text(
                        'مكافآتي',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  // Points History button
                  GestureDetector(
                    onTap: () => context.push(RoutePaths.pointsHistory),
                    child: Container(
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppRadius.extraLarge,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        spacing: 6.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(AppAssets.activityIcon),
                          const Text(
                            'حركة النقاط',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: .bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
