import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductCard extends StatefulWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap ?? () => context.go('${RoutePaths.categories}/product/${product.id}'),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Product Image
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
                      child: product.photo != null && product.photo!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.photo!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const ShimmerPlaceholder(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (context, url, error) => const AppIconPlaceholder(size: 60),
                            )
                          : const AppIconPlaceholder(size: 60),
                    ),
                    // Discount Badge
                    if (product.discountPercentage > 0)
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    // Favorite Button
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: _FavoriteButton(),
                    ),
                  ],
                ),
              ),
              // Product Details
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.rate.toString(),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4.0),
                          const Icon(Icons.star_rounded, size: 16.0, color: AppColors.secondary),
                          const SizedBox(width: 4.0),
                          const Text('•', style: TextStyle(color: AppColors.neutral)),
                          const SizedBox(width: 4.0),
                          Expanded(
                            child: Text(
                              product.brand,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.neutral),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: .end,
                        children: [
                          Text(
                            product.discountedPrice.toString(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'ل.س',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.neutral),
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

class _FavoriteButton extends StatefulWidget {
  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isFavorite = !_isFavorite),
      child: Container(
        padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 18.0,
          color: _isFavorite ? Colors.red : AppColors.neutral,
        ).animate(target: _isFavorite ? 1 : 0)
            .scaleXY(begin: 1.0, end: 1.3, duration: 150.ms)
            .then()
            .scaleXY(begin: 1.3, end: 1.0, duration: 150.ms),
      ),
    );
  }
}
