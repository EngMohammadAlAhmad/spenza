import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

class OfferItem {
  final String imagePath;
  final int discountPercent;
  final double rating;
  final String brandName;
  final String title;
  final int oldPrice;
  final int newPrice;

  const OfferItem({
    required this.imagePath,
    required this.discountPercent,
    required this.rating,
    required this.brandName,
    required this.title,
    required this.oldPrice,
    required this.newPrice,
  });
}

class TodayOffersSection extends StatefulWidget {
  const TodayOffersSection({super.key});

  @override
  State<TodayOffersSection> createState() => _TodayOffersSectionState();
}

class _TodayOffersSectionState extends State<TodayOffersSection> {
  final List<OfferItem> offers = const [
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_1.png',
      discountPercent: 15,
      rating: 4.8,
      brandName: 'Roco',
      title: 'دفتر سلكي 200 - A4 ورقة مسطر',
      oldPrice: 26000,
      newPrice: 22000,
    ),
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_2.png',
      discountPercent: 20,
      rating: 4.6,
      brandName: 'Pental',
      title: 'أقلام فلوماستر تحديد - 6 ألوان نيون',
      oldPrice: 30000,
      newPrice: 24000,
    ),
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_1.png',
      discountPercent: 15,
      rating: 4.8,
      brandName: 'Roco',
      title: 'دفتر سلكي 200 - A4 ورقة مسطر',
      oldPrice: 26000,
      newPrice: 22000,
    ),
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_2.png',
      discountPercent: 20,
      rating: 4.6,
      brandName: 'Pental',
      title: 'أقلام فلوماستر تحديد - 6 ألوان نيون',
      oldPrice: 30000,
      newPrice: 24000,
    ),
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_1.png',
      discountPercent: 15,
      rating: 4.8,
      brandName: 'Roco',
      title: 'دفتر سلكي 200 - A4 ورقة مسطر',
      oldPrice: 26000,
      newPrice: 22000,
    ),
    OfferItem(
      imagePath: 'assets/images/temp/offer_image_2.png',
      discountPercent: 20,
      rating: 4.6,
      brandName: 'Pental',
      title: 'أقلام فلوماستر تحديد - 6 ألوان نيون',
      oldPrice: 30000,
      newPrice: 24000,
    ),
  ];

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
            SvgPicture.asset('assets/icons/today_offers_icon.svg'),
            Text(
              'عروض اليوم',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: .bold,
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
          height: 298.2,
          child: ListView.builder(
            itemCount: offers.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: OfferCard(offer: offers[index]),
              ).animate(delay: (70 * index).ms)
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
            },
          ),
        ),
      ],
    );
  }
}

class OfferCard extends StatefulWidget {
  final OfferItem offer;

  const OfferCard({super.key, required this.offer});

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {},
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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 1),
              ),
            ],
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
                      child: Image.asset(
                        offer.imagePath,
                        width: double.infinity,
                        height: 160.0,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                          '-${offer.discountPercent}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black,
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8.0,
                      left: 8.0,
                      child: _FavoriteButton(),
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
                            offer.rating.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 2.0),
                          Icon(Icons.star, size: 20.0, color: AppColors.secondary),
                          const SizedBox(width: 4.0),
                          const Text('•', style: TextStyle(color: AppColors.neutral)),
                          const SizedBox(width: 4.0),
                          Text(
                            offer.brandName,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 4.0),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        offer.title,
                        maxLines: 2,
                        overflow: .ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.neutral900,
                        ),
                      ),
                      Row(
                        spacing: 5.0,
                        children: [
                          Text(
                            offer.newPrice.toString(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: .bold,
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
                        '${offer.oldPrice}',
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

class _FavoriteButton extends StatefulWidget {
  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _favorited = !_favorited),
      child: Container(
        height: 39.0,
        width: 39.0,
        padding: const EdgeInsets.all(4.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          _favorited ? Icons.favorite : Icons.favorite_border,
          size: 20.0,
          color: _favorited ? Colors.red : AppColors.neutral,
        ).animate(target: _favorited ? 1 : 0)
            .scaleXY(begin: 1.0, end: 1.3, duration: 150.ms, curve: Curves.easeOut)
            .then()
            .scaleXY(begin: 1.3, end: 1.0, duration: 150.ms),
      ),
    );
  }
}