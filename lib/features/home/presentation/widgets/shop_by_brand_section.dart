import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class ShopByBrandSection extends StatelessWidget {
  ShopByBrandSection({super.key});

  // List of PNG image paths
  final List<String> categories = [
    'Pentel',
    'Deli',
    'Pelikan',
    'Castell',
    'Nike',
    'Adidas',
    'Polo',
    'Mercedes-Benz',
    'Volkswagen',
    'Kia Motors',
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
          height: 96.0,
          child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: .zero,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 96.0,
                height: 64.0,
                child: Card(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(categories[index], style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: .bold), textAlign: .center),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}