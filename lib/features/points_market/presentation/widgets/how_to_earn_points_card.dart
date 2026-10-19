import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class HowToEarnPointsCard extends StatelessWidget {
  const HowToEarnPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Text(
            'كيف بتجمع نقاط',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
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
                  backgroundColor: const Color(0xFFF5F5F5),
                  label: 'بتطلب',
                ),
              ),

              // Divider line
              Expanded(
                child: _buildDivider(),
              ),

              // Step 2: Delivery
              Expanded(
                flex: 3,
                child: _buildStepItem(
                  iconPath: AppAssets.orderArrivedIcon,
                  backgroundColor: const Color(0xFFF5F5F5),
                  label: 'بيوصلك الطلب',
                ),
              ),

              // Divider line
              Expanded(
                child: _buildDivider(),
              ),

              // Step 3: Earn points
              Expanded(
                flex: 3,
                child: _buildStepItem(
                  iconPath: AppAssets.appIconPrimary,
                  backgroundColor: Colors.transparent,
                  label: 'بتنضاف نقاطك',
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
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem({
    required String iconPath,
    required Color backgroundColor,
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

  Widget _buildDivider() {
    return SizedBox(
      height: 52.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            height: 3.0,
            color: AppColors.neutralBorderStrong,
          ),
        ),
      ),
    );
  }
}

