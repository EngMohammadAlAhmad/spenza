import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';

class PointsMarketHeader extends StatelessWidget {
  const PointsMarketHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;

    return BlocBuilder<PointsMarketBloc, BaseState<PointsSummaryEntity>>(
      builder: (context, state) {
        final points = state.data?.balance ?? 0;

        return AppHeader(
          style: AppHeaderStyle.gradient,
          title: 'points_market'.tr(),
          onBackPressed: () => Navigator.pop(context),
          trailingActions: [
            IconButton(
              onPressed: () => context.push(RoutePaths.pointsHistory),
              icon: SvgPicture.asset(AppAssets.activityIcon),
            ),
          ],
          padding: EdgeInsets.only(
            top: context.screenPadding.top + 8.0,
            left: 16.0,
            right: 16.0,
            bottom: 24.0,
          ),
          bottomChild: Column(
            spacing: 16.0,
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
                        'your_balance'.tr(),
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
                            TextSpan(
                              text: 'points_unit'.tr(),
                              style: const TextStyle(
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

              // Glassmorphism Progress Container
              Container(
                width: isTabletLandscape ? context.width * 0.27 : null,
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
                      'points_card_progress_desc'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: .bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
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
                      child: Text(
                        'my_rewards'.tr(),
                        style: const TextStyle(
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
                          Text(
                            'points_history'.tr(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
