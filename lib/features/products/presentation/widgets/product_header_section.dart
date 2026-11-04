import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';

class ProductHeaderSection extends StatelessWidget {
  final ProductItemEntity product;
  final bool isOutOfStock;

  const ProductHeaderSection({
    super.key,
    required this.product,
    required this.isOutOfStock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
          decoration: BoxDecoration(
            color: AppColors.primaryTint,
            borderRadius: AppRadius.extra2Large,
          ),
          child: Text(
            product.category.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms).slideX(begin: 0.08, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: 10.0),

        // Product Title
        Text(
          product.title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
          textAlign: TextAlign.right,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(begin: 0.08, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),

        const SizedBox(height: 16.0),

        // Rating & Availability Row
        Row(
          spacing: 5.0,
          children: [
            Text(
              '· ${'ratings_count'.tr(args: ['${product.ratingsCount}'])}',
              style: const TextStyle(color: AppColors.neutral, fontSize: 14.0),
            ),
            const SizedBox(width: 3.0),
            Text(
              product.rate.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            const Icon(Icons.star_rounded, color: AppColors.secondary, size: 22.0),
            const Spacer(),
            Row(
              spacing: 6.0,
              children: [
                Text(
                  isOutOfStock ? 'out_of_stock'.tr() : 'in_stock'.tr(),
                  style: TextStyle(
                    color: isOutOfStock ? AppColors.error : AppColors.successForeground,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                ),
                SvgPicture.asset(
                  isOutOfStock ? AppAssets.unAvailableIcon : AppAssets.availableIcon,
                  colorFilter: ColorFilter.mode(
                    isOutOfStock ? AppColors.error : AppColors.successLight,
                    BlendMode.srcIn,
                  ),
                  width: 18.0,
                  height: 18.0,
                ),
              ],
            ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
          ],
        ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
      ],
    );
  }
}
