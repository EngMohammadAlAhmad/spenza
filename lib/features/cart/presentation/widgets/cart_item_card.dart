import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final NumberFormat formatter;

  const CartItemCard({
    super.key,
    required this.item,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Right side in RTL: Product Image
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.neutral200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
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

          // 2. Middle: Title, details & price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.unitTitle.isNotEmpty || item.variantLabel != null) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    '${item.unitTitle}${item.variantLabel != null ? ' · ${item.variantLabel}' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
                const SizedBox(height: 8.0),
                Text(
                  '${formatter.format(item.totalPrice)} ل.س',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '${formatter.format(item.unitPrice)} ل.س للـ${item.unitTitle}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.neutral,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),

          // 3. Left side in RTL: Remove Icon & Quantity Selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset('assets/icons/remove_icon.svg'),
                onPressed: () {
                  context.read<CartBloc>().add(RemoveFromCartEvent(
                        productId: item.productId,
                        unitId: item.unitId,
                      ));
                },
              ),
              const SizedBox(height: 20.0),

              // Quantity Selector
              _buildQuantitySelector(context, item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, CartItemEntity item) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrease button (-)
          InkWell(
            onTap: () {
              if (item.quantity > 1) {
                context.read<CartBloc>().add(UpdateCartQuantityEvent(
                      productId: item.productId,
                      unitId: item.unitId,
                      quantity: item.quantity - 1,
                    ));
              } else {
                context.read<CartBloc>().add(RemoveFromCartEvent(
                      productId: item.productId,
                      unitId: item.unitId,
                    ));
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.remove, size: 16, color: Colors.black87),
            ),
          ),

          // Quantity text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),

          // Increase button (+)
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(UpdateCartQuantityEvent(
                    productId: item.productId,
                    unitId: item.unitId,
                    quantity: item.quantity + 1,
                  ));
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
