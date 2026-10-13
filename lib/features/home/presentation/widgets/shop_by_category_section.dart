import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/view_all_button.dart';

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
      spacing: 15.0,
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'الأقسام',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
              ),
            ),
            ViewAllButton(
              onPressed: () => context.go('${RoutePaths.categories}?tab=0'),
            ),
          ],
        ),
        SizedBox(
          height: 125.0,
          child: isLoading
              ? ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 16.0),
                  itemBuilder: (context, index) => Column(
                    children: [
                      ShimmerPlaceholder(
                        width: 80.0,
                        height: 80.0,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      const SizedBox(height: 8.0),
                      const ShimmerPlaceholder(width: 50, height: 10),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(width: 16.0),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return SizedBox(
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
                                child: category.image != null && category.image!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: category.image!,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => const ShimmerPlaceholder(
                                          width: 80,
                                          height: 80,
                                        ),
                                        errorWidget: (context, url, error) => const AppIconPlaceholder(size: 40.0),
                                      )
                                    : const AppIconPlaceholder(size: 40.0),
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
                    ).animate(delay: (30 * index).ms)
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
                  },
                ),
        ),
      ],
    );
  }
}
