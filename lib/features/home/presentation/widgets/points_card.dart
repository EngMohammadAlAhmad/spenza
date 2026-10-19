import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';

class PointsCard extends StatelessWidget {
  const PointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointsMarketBloc, BaseState<PointsSummaryEntity>>(
      builder: (context, state) {
        final points = state.data?.balance ?? 0;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.brandRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppRadius.brandRadius,
            child: InkWell(
              onTap: () {
                context.push(RoutePaths.pointsMarket);
              },
              borderRadius: AppRadius.brandRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: Row(
                  children: [
                    // Right side: Rounded points icon
                    SvgPicture.asset(
                      AppAssets.roundedIcon,
                    ),
                    const SizedBox(width: 12.0),

                    // Middle: Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'رصيدك ',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '$points ',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'نقطة',
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            'استبدلها بتوصيل مجاني\nأو خصم',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Left side: "سوق النقاط >"
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'سوق النقاط',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                            fontWeight: .bold,
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
