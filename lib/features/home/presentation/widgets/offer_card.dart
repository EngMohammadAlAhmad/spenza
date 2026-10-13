import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/favorite_button.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_event.dart';

class OfferCard extends StatefulWidget {
  final ProductEntity product;

  const OfferCard({super.key, required this.product});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
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
          height: 298.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: BlocBuilder<FavoritesBloc, BaseState<List<ProductEntity>>>(
                        builder: (context, state) {
                          final isFavorite = state.data?.any((p) => p.id == product.id) ?? false;
                          return FavoriteButton(
                            size: 20.0,
                            initialFavorite: isFavorite,
                            onFavoriteChanged: (isFav) {
                              context.read<FavoritesBloc>().add(ToggleFavoriteEvent(product));
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        '${product.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.neutral,
                              decoration: TextDecoration.lineThrough,
                            ),
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
