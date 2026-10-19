import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/home/presentation/widgets/offer_card.dart';

class TodayOffersSection extends StatelessWidget {
  final List<ProductEntity> products;
  final bool isLoading;

  const TodayOffersSection({
    super.key,
    required this.products,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: .spaceBetween,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'عروض اليوم',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            /*const Spacer(),
            ViewAllButton(
              onPressed: () {},
            ),*/
          ],
        ),
        SizedBox(
          height: 298.2,
          child: isLoading
              ? ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) => ShimmerPlaceholder(
                    width: 172,
                    height: 298.2,
                    borderRadius: AppRadius.overMedium,
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) {
                    return OfferCard(product: products[index])
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
