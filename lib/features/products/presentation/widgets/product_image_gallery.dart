import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_event.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/circle_action_button.dart';
import 'package:spenza/core/widgets/favorite_button.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

enum GalleryItemType { image, video, model3d }

class GalleryItem {
  final String? url;
  final GalleryItemType type;

  const GalleryItem({this.url, required this.type});
}

class ProductImageGallery extends StatefulWidget {
  final ProductEntity product;
  final List<String> images;
  final List<String> sideImages;
  final String? video;
  final String? model3d;

  const ProductImageGallery({
    super.key,
    required this.product,
    required this.images,
    this.sideImages = const [],
    this.video,
    this.model3d,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;
  late List<GalleryItem> _allMedia;

  @override
  void initState() {
    super.initState();
    _prepareMedia();
  }

  void _prepareMedia() {
    final media = <GalleryItem>[];

    // Add actual media
    for (var img in widget.images) {
      media.add(GalleryItem(url: img, type: GalleryItemType.image));
    }
    for (var img in widget.sideImages) {
      media.add(GalleryItem(url: img, type: GalleryItemType.image));
    }
    if (widget.video != null) {
      media.add(GalleryItem(url: widget.video, type: GalleryItemType.video));
    }
    if (widget.model3d != null) {
      media.add(GalleryItem(url: widget.model3d, type: GalleryItemType.model3d));
    }

    // If empty, add placeholders (2 images, 1 video, 1 3d object)
    if (media.isEmpty) {
      media.add(const GalleryItem(type: GalleryItemType.image));
      media.add(const GalleryItem(type: GalleryItemType.image));
      media.add(const GalleryItem(type: GalleryItemType.video));
      media.add(const GalleryItem(type: GalleryItemType.model3d));
    }

    _allMedia = media;
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = _allMedia[_currentIndex];

    return Column(
      children: [
        // Main Image Container
        Container(
          height: 300.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Main Content
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.94, end: 1.0).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<int>(_currentIndex),
                    child: _buildMainContent(currentItem),
                  ),
                ),
              ),

              // Controls (Back, Share, Favorite)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleActionButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => context.pop(),
                    )
                        .animate()
                        .fadeIn(duration: 650.ms, delay: 200.ms)
                        .scale(
                          begin: const Offset(0.4, 0.4),
                          duration: 750.ms,
                          curve: Curves.easeOutBack,
                        ),
                    Row(
                      children: [
                        CircleActionButton(
                          icon: Icons.share_outlined,
                          onTap: () {},
                          shareButton: true,
                        )
                            .animate()
                            .fadeIn(duration: 650.ms, delay: 350.ms)
                            .scale(
                              begin: const Offset(0.4, 0.4),
                              duration: 750.ms,
                              curve: Curves.easeOutBack,
                            ),
                        const SizedBox(width: 12),
                        BlocBuilder<FavoritesBloc, BaseState<List<ProductEntity>>>(
                          builder: (context, state) {
                            final isFavorite = state.data?.any((p) => p.id == widget.product.id) ?? false;
                            return FavoriteButton(
                              initialFavorite: isFavorite,
                              onFavoriteChanged: (isFav) {
                                context.read<FavoritesBloc>().add(ToggleFavoriteEvent(widget.product));
                              },
                            );
                          },
                        )
                            .animate()
                            .fadeIn(duration: 650.ms, delay: 500.ms)
                            .scale(
                              begin: const Offset(0.4, 0.4),
                              duration: 750.ms,
                              curve: Curves.easeOutBack,
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(
              begin: const Offset(0.95, 0.95),
              duration: 800.ms,
              curve: Curves.easeOutCubic,
            ),

        const SizedBox(height: 20),

        // Media Row (Thumbnails/Icons)
        SizedBox(
          height: 64.0,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _allMedia.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10.0),
            itemBuilder: (context, index) {
              final item = _allMedia[index];
              final isSelected = _currentIndex == index;
              return AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    width: 64.0,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.secondary.withValues(alpha: 0.1) : Colors.white,
                      borderRadius: AppRadius.large,
                      border: Border.all(
                        color: isSelected ? AppColors.secondary : AppColors.fillColor,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (item.type == GalleryItemType.image && item.url != null)
                          ClipRRect(
                            borderRadius: AppRadius.upMedium,
                            child: CachedNetworkImage(
                              imageUrl: item.url!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        else
                          _buildThumbnailIcon(item.type, isSelected),
                        if (item.type == GalleryItemType.model3d)
                          const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 24),
                      ],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: (350 + index * 120).ms, duration: 700.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 700.ms,
                    curve: Curves.easeOutBack,
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(GalleryItem item) {
    if (item.type == GalleryItemType.image) {
      return item.url != null
          ? CachedNetworkImage(
              imageUrl: item.url!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
              placeholder: (context, url) => const ShimmerPlaceholder(
                width: double.infinity,
                height: double.infinity,
              ),
              errorWidget: (context, url, error) => const AppIconPlaceholder(size: 150),
            )
          : const AppIconPlaceholder(size: 150);
    } else if (item.type == GalleryItemType.video) {
      return Container(
        color: AppColors.neutral200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_circle_outline_rounded, size: 80, color: AppColors.secondary)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(begin: 1.0, end: 1.1, duration: 1500.ms, curve: Curves.easeInOut),
              const SizedBox(height: 12),
              const Text('تشغيل الفيديو', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: AppColors.neutral200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.view_in_ar_rounded, size: 80, color: AppColors.secondary)
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(begin: 1.0, end: 1.1, duration: 1500.ms, curve: Curves.easeInOut)
                  .shimmer(delay: 1000.ms, duration: 2000.ms),
              const SizedBox(height: 12),
              const Text('عرض 3D', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildThumbnailIcon(GalleryItemType type, bool isSelected) {
    IconData iconData;
    switch (type) {
      case GalleryItemType.image:
        iconData = Icons.image_outlined;
        break;
      case GalleryItemType.video:
        iconData = Icons.play_circle_fill;
        break;
      case GalleryItemType.model3d:
        iconData = Icons.view_in_ar_rounded;
        break;
    }
    return Icon(
      iconData,
      color: isSelected ? AppColors.secondary : AppColors.neutral,
      size: 32,
    ).animate(target: isSelected ? 1 : 0).scaleXY(begin: 1.0, end: 1.15, duration: 300.ms, curve: Curves.easeOutBack);
  }
}
