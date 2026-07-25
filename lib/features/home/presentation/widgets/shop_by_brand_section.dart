import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'تسوّق حسب الماركة',
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
          height: 64.0,
          child: isLoading
              ? ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ShimmerPlaceholder(
                width: 96.0,
                height: 64.0,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
              : ListView.builder(
            itemCount: brands.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: SizedBox(
                  width: 96.0,
                  height: 64.0,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: brand.image != null
                          ? CachedNetworkImage(
                        imageUrl: brand.image!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const ShimmerPlaceholder(
                          width: 96.0,
                          height: 64.0,
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Text(
                            brand.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 15.0,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                          : Center(
                        child: Text(
                          brand.name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 15.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate(delay: (50 * index).ms)
                  .fadeIn(duration: 400.ms)
                  .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
              );
            },
          ),
        ),
      ],
    );
  }
}