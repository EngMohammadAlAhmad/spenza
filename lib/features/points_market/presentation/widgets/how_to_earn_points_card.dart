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
            'كيف بتجمع نقاط',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
                  iconPath: AppAssets.productsIconBig,
                  label: 'بتطلب',
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
                  iconPath: AppAssets.orderArrivedIcon,
                  label: 'بيوصلك الطلب',
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
                  label: 'بتنضاف نقاطك',
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
          const Center(
            child: Text(
              'نقطة لكل 1,000 ل.س من قيمة طلبك، وبتنضاف بعد ما يتسلم الطلب.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.neutral,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 1950.ms, duration: 550.ms)
              .slideY(begin: 0.15, duration: 550.ms, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }

  Widget _buildStepItem({
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
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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

