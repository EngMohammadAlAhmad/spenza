import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../../../core/themes/app_radius.dart';

class BrandSection extends StatelessWidget {
  const BrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios, size: 14, color: AppColors.blue),
                    const SizedBox(width: 4),
                    Text(
                      'عرض الكل',
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'تسوّق حسب الماركة',
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.medium,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Center(
                  child: Text(
                    'Brand ${index + 1}',
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.neutral,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
