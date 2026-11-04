import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/marquee_widget.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';

class ProductSpecificationsCard extends StatelessWidget {
  final List<ProductSpecificationEntity> specifications;

  const ProductSpecificationsCard({
    super.key,
    required this.specifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.overMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        children: [
          for (int i = 0; i < specifications.length; i++) ...[
            _buildSpecificationRow(context, specifications[i]),
            if (i < specifications.length - 1)
              Divider(
                height: 24.0,
                thickness: 1.0,
                color: AppColors.neutral200.withValues(alpha: 0.6),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecificationRow(BuildContext context, ProductSpecificationEntity spec) {
    final valuesText = spec.values.map((v) => v.name).where((n) => n.isNotEmpty).join(', ');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Attribute Name
        Flexible(
          flex: 2,
          child: Text(
            spec.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral,
                  fontSize: 14.0,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 16.0),
        // Attribute Value(s)
        Expanded(
          flex: 3,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: MarqueeWidget(
              child: Text(
                valuesText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral900,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
