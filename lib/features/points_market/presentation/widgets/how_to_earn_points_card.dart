import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class HowToEarnPointsCard extends StatelessWidget {
  const HowToEarnPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.largePlus,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'how_to_earn_points'.tr(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: .bold,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideX(begin: isRtl ? 0.05 : -0.05, duration: 400.ms),
          const SizedBox(height: 20.0),

          // Steps Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: Order
              Expanded(
                flex: 3,
                child: _buildStepItem(
                  context,
                  iconPath: AppAssets.productsIconBig,
                  label: 'step_place_order'.tr(),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 450.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    ),
              ),

              // Divider line 1
              Expanded(
                child: _buildDivider(
                  delayMs: 550,
                  isRtl: isRtl,
                ),
              ),

              // Step 2: Delivery
              Expanded(
                flex: 3,
                child: _buildStepItem(
                  context,
                  iconPath: AppAssets.orderArrivedIcon,
                  label: 'step_order_arrives'.tr(),
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 450.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      duration: 500.ms,
                      curve: Curves.easeOutBack,
                    ),
              ),

              // Divider line 2
              Expanded(
                child: _buildDivider(
                  delayMs: 1250,
                  isRtl: isRtl,
                ),
              ),

              // Step 3: Earn points
              Expanded(
                flex: 3,
                child: _buildStep3Item(
                  iconPath: AppAssets.appIconPrimary,
                  label: 'step_points_added'.tr(),
                )
                    .animate()
                    .fadeIn(delay: 1600.ms, duration: 500.ms)
                    .scale(
                      begin: const Offset(0.4, 0.4),
                      duration: 600.ms,
                      curve: Curves.easeOutBack,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),

          // Explanation Text
          Center(
            child: Padding(
              padding: const .symmetric(horizontal: 10.0),
              child: Text(
                'points_explain_text'.tr(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.tertiary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
              .animate()
              .fadeIn(delay: 1950.ms, duration: 550.ms)
              .slideY(begin: 0.15, duration: 550.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, {
    required String iconPath,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            iconPath,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: .bold,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }

  Widget _buildStep3Item({
    required String iconPath,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            iconPath,
          )
              .animate(
                delay: 2100.ms,
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .scaleXY(
                begin: 1.0,
                end: 1.1,
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider({
    required int delayMs,
    required bool isRtl,
  }) {
    return SizedBox(
      height: 52.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            height: 3.0,
            decoration: BoxDecoration(
              color: AppColors.neutralBorderStrong,
              borderRadius: BorderRadius.circular(2.0),
            ),
          )
              .animate()
              .fadeIn(delay: delayMs.ms, duration: 200.ms)
              .scaleX(
                begin: 0.0,
                end: 1.0,
                delay: delayMs.ms,
                duration: 400.ms,
                curve: Curves.easeOutCubic,
                alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
              ),
        ),
      ),
    );
  }
}
