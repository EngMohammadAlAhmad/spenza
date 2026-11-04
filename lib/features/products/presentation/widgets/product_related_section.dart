import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/widgets/product_card.dart';

class ProductRelatedSection extends StatelessWidget {
  final List<ProductEntity> relatedProducts;

  const ProductRelatedSection({
    super.key,
    required this.relatedProducts,
  });

  @override
  Widget build(BuildContext context) {
    if (relatedProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'you_may_also_like'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ).animate().fadeIn(delay: 1380.ms, duration: 600.ms),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: relatedProducts.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) => SizedBox(
              width: 180,
              child: ProductCard(product: relatedProducts[index]),
            ),
          ),
        ).animate().fadeIn(delay: 1450.ms, duration: 750.ms).slideY(begin: 0.08, end: 0, duration: 750.ms, curve: Curves.easeOutCubic),
      ],
    );
  }
}
