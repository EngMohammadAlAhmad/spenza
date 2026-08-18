import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';

class BestSellingSection extends StatelessWidget {
  final List<ProductEntity> products;
  final bool isLoading;

  const BestSellingSection({
    super.key,
    required this.products,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          spacing: 5.0,
          children: [
            SvgPicture.asset('assets/icons/best_selling_icon.svg'),
            Text(
              'الأكثر مبيعاً',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
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
          height: 284.0,
          child: isLoading
              ? ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) => ShimmerPlaceholder(
                    width: 172,
                    height: 284.0,
                    borderRadius: BorderRadius.circular(16),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) {
                    return BestSellingCard(product: products[index])
                        .animate(delay: (30 * index).ms)
                        .fadeIn(duration: 500.ms)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
                  },
                ),
        ),
      ],
    );
  }
}

class BestSellingCard extends StatefulWidget {
  final ProductEntity product;

  const BestSellingCard({super.key, required this.product});

  @override
  State<BestSellingCard> createState() => _BestSellingCardState();
}

class _BestSellingCardState extends State<BestSellingCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        context.push('/categories/product/${product.id}');
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: 172.0,
          height: 284.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(
                height: 160.0,
                width: double.infinity,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      child: product.photo != null && product.photo!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.photo!,
                              width: double.infinity,
                              height: 160.0,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShimmerPlaceholder(width: 172, height: 160),
                              errorWidget: (context, url, error) => const AppIconPlaceholder(size: 60),
                            )
                          : const AppIconPlaceholder(size: 100.0),
                    ),
                    if (product.discountPercentage > 0)
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          '-${product.discountPercentage.toInt()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: Container(
                        height: 39.0,
                        width: 39.0,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 20.0,
                          color: AppColors.neutral,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.rate.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 2.0),
                          const Icon(Icons.star_rounded, size: 20.0, color: AppColors.secondary),
                          const SizedBox(width: 4.0),
                          const Text('•', style: TextStyle(color: AppColors.neutral)),
                          const SizedBox(width: 4.0),
                          Text(
                            product.brand,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutral900,
                        ),
                      ),
                      Row(
                        spacing: 5.0,
                        children: [
                          Text(
                            product.discountedPrice.toString(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            'ل.س',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.neutral,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
