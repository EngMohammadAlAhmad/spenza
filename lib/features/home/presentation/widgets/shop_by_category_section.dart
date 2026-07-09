import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class ShopByCategorySection extends StatelessWidget {
  ShopByCategorySection({super.key});

  final List<String> categoryImages = [
    'assets/images/temp/arts.png',
    'assets/images/temp/supplies.png',
    'assets/images/temp/scoolar.png',
    'assets/images/temp/pens.png',
    'assets/images/temp/arts.png',
    'assets/images/temp/supplies.png',
    'assets/images/temp/scoolar.png',
    'assets/images/temp/pens.png',
    'assets/images/temp/arts.png',
    'assets/images/temp/supplies.png',
    'assets/images/temp/scoolar.png',
    'assets/images/temp/pens.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'تسوّق حسب التصنيف',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
                color: AppColors.primary
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'عرض الكل >',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.blue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 90.0,
          child: ListView.builder(
            itemCount: categoryImages.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Image.asset(
                categoryImages[index],
                width: 87.0,
                height: 87.0,
                fit: BoxFit.contain,
              );
            },
          ),
        ),
      ],
    );
  }
}