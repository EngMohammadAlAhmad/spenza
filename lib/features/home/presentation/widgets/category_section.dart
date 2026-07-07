import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'فنون', 'icon': Icons.palette_outlined},
      {'name': 'مكتبية', 'icon': Icons.print_outlined},
      {'name': 'مدرسية', 'icon': Icons.school_outlined},
      {'name': 'أقلام', 'icon': Icons.edit_outlined},
      {'name': 'دفاتر', 'icon': Icons.book_outlined},
    ];

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
                'تسوّق حسب التصنيف',
                style: AppTextStyles.heading4(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            reverse: true, // For RTL feel if needed, but let's see
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      categories[index]['icon'] as IconData,
                      color: AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    categories[index]['name'] as String,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: categories.length,
          ),
        ),
      ],
    );
  }
}
