import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

class Step3ItemsSummaryCard extends StatelessWidget {
  final List<CartItemEntity> items;
  final VoidCallback onEditCartPressed;

  const Step3ItemsSummaryCard({
    super.key,
    required this.items,
    required this.onEditCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final totalCount = items.fold<int>(0, (sum, item) => sum + item.quantity);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/products_icon.svg',
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'المنتجات ($totalCount)',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEditCartPressed,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/edit_icon.svg',
                      colorFilter: .mode(AppColors.primary, .srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      'تعديل السلة',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  // Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 48.0,
                      height: 48.0,
                      color: AppColors.neutral200,
                      child: item.productImage != null && item.productImage!.isNotEmpty
                          ? Image.network(
                              item.productImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.neutral,
                              ),
                            )
                          : const Icon(
                              Icons.image_outlined,
                              color: AppColors.neutral,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12.0),

                  // Product Details (Title + Unit/Quantity)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productTitle,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          '${item.unitTitle.isNotEmpty ? item.unitTitle : "وحدة"} × ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.neutral,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),

                  // Price
                  Text(
                    '${formatter.format(item.totalPrice)} ل.س',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
