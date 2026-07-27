import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShopByBrandSection extends StatelessWidget {
  final List<BrandEntity> brands;
  final bool isLoading;

  const ShopByBrandSection({
    super.key,
    required this.brands,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'تسوّق حسب الماركة',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
                color: AppColors.primary,
              ),
            ),
            TextButton(
              onPressed: () => context.go('${RoutePaths.categories}?tab=1'),
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
          height: 64.0,
          child: isLoading
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                  itemBuilder: (context, index) => ShimmerPlaceholder(
                    width: 96.0,
                    height: 64.0,
                    borderRadius: BorderRadius.circular(12),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: brands.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return SizedBox(
                      width: 96.0,
                      height: 64.0,
                      child: Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.fillColor, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: brand.image != null && brand.image!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: brand.image!,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => const ShimmerPlaceholder(
                                    width: 96.0,
                                    height: 64.0,
                                  ),
                                  errorWidget: (context, url, error) => const AppIconPlaceholder(size: 75.0, padding: 8.0),
                                )
                              : const AppIconPlaceholder(size: 75.0, padding: 8),
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms).scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        );
                  },
                ),
        ),
      ],
    );
  }
}
