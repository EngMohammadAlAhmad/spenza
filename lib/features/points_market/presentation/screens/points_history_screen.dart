import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';

class PointsHistoryScreen extends StatelessWidget {
  const PointsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // Header
          AppHeader(
            title: 'حركة النقاط',
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          const SizedBox(height: 16.0),

          // Points Summary Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<PointsMarketBloc, BaseState<PointsSummaryEntity>>(
              builder: (context, state) {
                final points = state.data?.balance ?? 0;

                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.large,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF91292B),
                        Color(0xFFC74436),
                        Color(0xFFD46B60),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: AppRadius.large,
                          child: Image.asset(
                            AppAssets.pattern,
                            fit: BoxFit.cover,
                            opacity: const AlwaysStoppedAnimation(0.08),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 18.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'رصيدك',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 13.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '$points ',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'نقطة',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              'النقاط بتنضاف بعد تسليم كل طلب',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.90),
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
