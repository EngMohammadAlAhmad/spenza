import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isNotEmpty ? widget.images : [null];

    return Column(
      children: [
        // Main Image Container
        Container(
          height: 380,
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
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
              // Main Image
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: images[_currentIndex] != null
                    ? CachedNetworkImage(
                        imageUrl: images[_currentIndex]!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const ShimmerPlaceholder(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => const AppIconPlaceholder(size: 150),
                      )
                    : const AppIconPlaceholder(size: 150),
              ),

              // Controls (Back, Share, Favorite)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleActionButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onTap: () => context.pop(),
                    ),
                    // Back Button (Top Right in design, but let's follow the image flow)
                    // The design has Back at top right (RTL), Share/Fav at top left
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

        // Thumbnails
        if (widget.images.length > 1)
          SizedBox(
            height: 70,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              //reverse: true, // RTL
              itemCount: widget.images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final isSelected = _currentIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.fillColor,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.images[index],
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const AppIconPlaceholder(size: 30),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
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
