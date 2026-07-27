import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/home/domain/entities/banner_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spenza/core/widgets/app_icon_placeholder.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerEntity> banners;
  final bool isLoading;

  const BannerSlider({super.key, required this.banners, this.isLoading = false});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ShimmerPlaceholder(
          width: double.infinity,
          height: 152.0,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            final banner = widget.banners[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: banner.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const ShimmerPlaceholder(
                    width: double.infinity,
                    height: 152.0,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.fillColor,
                    child: const AppIconPlaceholder(size: 60),
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 152.0,
            viewportFraction: 0.92,
            enlargeCenterPage: false,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            onPageChanged: (index, reason) {
              setState(() => _currentPage = index);
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentPage,
          count: widget.banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 2.5,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
      ],
    );
  }
}
