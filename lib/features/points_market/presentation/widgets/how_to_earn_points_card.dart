import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

class HowToEarnPointsCard extends StatelessWidget {
  const HowToEarnPointsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.0),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step 1: Order
              _buildStepItem(
                iconWidget: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
                backgroundColor: const Color(0xFFF5F5F5),
                label: 'بتطلب',
              ),

              // Divider line
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Container(
                  width: 30,
                  height: 1.5,
                  color: Colors.grey.shade300,
                ),
              ),

              // Step 2: Delivery
              _buildStepItem(
                iconWidget: const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.black54,
                  size: 22,
                ),
                backgroundColor: const Color(0xFFF5F5F5),
                label: 'بيوصلك الطلب',
              ),

              // Divider line
              Padding(
                padding: const EdgeInsets.only(top: 22.0),
                child: Container(
                  width: 30,
                  height: 1.5,
                  color: Colors.grey.shade300,
                ),
              ),

              // Step 3: Earn points
              _buildStepItem(
                iconWidget: SvgPicture.asset(
                  'assets/images/rounded_icon.svg',
                  width: 42,
                  height: 42,
                ),
                backgroundColor: Colors.transparent,
                label: 'بتنضاف نقاطك',
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
    required Widget iconWidget,
    required Color backgroundColor,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: iconWidget),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
