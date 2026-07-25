import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

class ShopByCategorySection extends StatelessWidget {
  final List<CategoryEntity> categories;
  final bool isLoading;

  const ShopByCategorySection({
    super.key,
    required this.categories,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تسوّق حسب التصنيف',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
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
          height: 125.0,
          child: isLoading
              ? ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  ShimmerPlaceholder(
                    width: 80.0,
                    height: 80.0,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  const SizedBox(height: 8),
                  const ShimmerPlaceholder(width: 50, height: 10),
                ],
              ),
            ),
          )
              : ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 80.0,
                  child: Column(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: category.image != null
                                ? CachedNetworkImage(
                              imageUrl: category.image!,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const ShimmerPlaceholder(
                                width: 80,
                                height: 80,
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.category_outlined,
                                color: AppColors.primary,
                                size: 50.0,
                              ),
                            )
                                : const Icon(Icons.category_outlined, color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: .ellipsis,
                        textAlign: .center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: (70 * index).ms)
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        ),
      ],
    );
  }
}