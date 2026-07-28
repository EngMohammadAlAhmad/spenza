import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

enum GalleryItemType { image, video, model3d }

class GalleryItem {
  final String? url;
  final GalleryItemType type;

  const GalleryItem({this.url, required this.type});
}

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final List<String> sideImages;
  final String? video;
  final String? model3d;

  const ProductImageGallery({
    super.key,
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
                child: _buildMainContent(currentItem),
              ),

              // Controls (Back, Share, Favorite)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleActionButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => context.pop(),
                    ),
                    Row(
                      children: [
                        _CircleActionButton(
                          icon: Icons.share_outlined,
                          onTap: () {},
                          shareButton: true,
                        ),
                        const SizedBox(width: 12),
                        _FavoriteButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 64.0,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.secondary.withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : AppColors.fillColor,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        : [],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (item.type == GalleryItemType.image && item.url != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl: item.url!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      else
                        _buildThumbnailIcon(item.type, isSelected),
                      /*if (item.type == GalleryItemType.video)
                        const Icon(Icons.play_circle_fill, color: AppColors.grey, size: 24),*/
                      if (item.type == GalleryItemType.model3d)
                        const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 24),
                    ],
                  ),
                ),
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
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_circle_outline_rounded, size: 80, color: AppColors.secondary),
              SizedBox(height: 12),
              Text('تشغيل الفيديو', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: AppColors.neutral200,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.view_in_ar_rounded, size: 80, color: AppColors.secondary),
              SizedBox(height: 12),
              Text('عرض 3D', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
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
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool? shareButton;

  const _CircleActionButton({required this.icon, required this.onTap, this.shareButton = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 22.0,
          color: shareButton! ? AppColors.primary : AppColors.neutral,
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
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          size: 22.0,
          color: _isFavorite ? Colors.red : AppColors.neutral,
        ),
      ),
    );
  }
}
