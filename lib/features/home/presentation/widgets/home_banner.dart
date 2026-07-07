import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_radius.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 180,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: AppRadius.extraLarge,
          ),
          child: Stack(
            children: [
              // Mocking the backpack image with a simple icon or placeholder
              Positioned(
                left: 20,
                bottom: 20,
                top: 20,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: AppRadius.overMedium,
                  ),
                  child: const Icon(
                    Icons.backpack,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'عروض العودة للمدارس',
                      style: AppTextStyles.heading4(context).copyWith(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'خصومات حتى 40% على كل\nالمستلزمات',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.extraLarge,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 0,
                        ),
                      ),
                      child: Text(
                        'تسوّق الآن',
                        style: AppTextStyles.button(context).copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
