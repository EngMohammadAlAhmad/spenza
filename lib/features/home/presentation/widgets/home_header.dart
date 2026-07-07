import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_radius.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.primary,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'التوصيل إلى',
                        style: AppTextStyles.bodySmall(context).copyWith(
                          color: AppColors.neutral,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          Text(
                            'المنزل - دمشق',
                            style: AppTextStyles.bodyMedium(context).copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'ابحث عن قلم، دفتر، حقيبة...',
              hintStyle: AppTextStyles.bodyMedium(context).copyWith(
                color: AppColors.neutral.withOpacity(0.6),
              ),
              suffixIcon: const Icon(Icons.search, color: AppColors.neutral),
              filled: true,
              fillColor: AppColors.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: AppRadius.extraLarge2,
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }
}
