import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/home/domain/entities/dummy_banner_entity.dart';


class BannerSlider extends StatefulWidget {
  final List<DummyBannerEntity> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _controller,
          itemCount: widget.banners.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: const .symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/temp/ad.png'),
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

class _BannerCard extends StatelessWidget {
  final DummyBannerEntity banner;

  const _BannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: banner.bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      banner.buttonText,
                      style: TextStyle(
                        color: banner.bgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Image.asset(
              banner.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image, color: Colors.white54, size: 50);
              },
            ),
          ),
        ],
      ),
    );
  }
}