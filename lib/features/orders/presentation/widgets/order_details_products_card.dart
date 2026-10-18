import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsProductsCard extends StatelessWidget {
  final OrderDetailsEntity order;
  final NumberFormat formatter;

  const OrderDetailsProductsCard({
    super.key,
    required this.order,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final deliveryFee = order.totals?.deliveryFee ?? order.delivery?.fee ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        spacing: 10.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المنتجات (${order.items.isNotEmpty ? order.items.length : order.itemsCount})',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),

          // Items List
          if (order.items.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: order.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Row(
                  children: [
                    // Product Image Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: item.productImage != null && item.productImage!.isNotEmpty
                          ? Image.network(
                              item.productImage!,
                              width: 44.0,
                              height: 44.0,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _buildItemPlaceholder(),
                            )
                          : _buildItemPlaceholder(),
                    ),
                    const SizedBox(width: 12.0),

                    // Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            item.variantLabel.isNotEmpty
                                ? '${item.variantLabel} × ${item.quantity}'
                                : '${item.unitName} × ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8.0),

                    // Price
                    Text(
                      '${formatter.format(item.lineTotal)} ل.س',
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                );
              },
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          // Subtotals & Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التوصيل',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${formatter.format(deliveryFee)} ل.س',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                '${formatter.format(order.total)} ل.س',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemPlaceholder() {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        size: 22.0,
        color: AppColors.neutral,
      ),
    );
  }
}
