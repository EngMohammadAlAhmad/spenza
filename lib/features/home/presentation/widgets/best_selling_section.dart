import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';

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
      spacing: 15.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'best_selling'.tr(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              /*const Spacer(),
              ViewAllButton(
                onPressed: () {},
              ),*/
            ],
          ),
        ),
        SizedBox(
          height: 298.0,
          child: isLoading
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) => ShimmerPlaceholder(
                    width: 172,
                    height: 298.0,
                    borderRadius: AppRadius.overMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: products.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(width: 15.0),
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 172.0,
                      height: 298.0,
                      child: ProductCard(product: products[index]),
                    )
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
