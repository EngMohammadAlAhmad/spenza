import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/add_to_cart_snackbar.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';

class ProductDetailsBottomBar extends StatelessWidget {
  final ProductDetailsState state;
  final ProductDetailsEntity data;
  final VoidCallback? onAddToCart;

  const ProductDetailsBottomBar({
    super.key,
    required this.state,
    required this.data,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final product = data.product;
    final formatter = NumberFormat('#,##0');

    ProductUnitEntity? selectedUnit;
    for (final u in product.units) {
      if (u.id == state.selectedUnitId) {
        selectedUnit = u;
        break;
      }
    }
    selectedUnit ??= product.units.isNotEmpty ? product.units.first : null;

    final unitTitle = selectedUnit?.title ?? 'قطعة';
    final num unitPrice = selectedUnit != null
        ? (selectedUnit.discountedPrice > 0
            ? selectedUnit.discountedPrice
            : (selectedUnit.price > 0
                ? selectedUnit.price
                : (product.discountedPrice > 0 ? product.discountedPrice : product.price)))
        : (product.discountedPrice > 0 ? product.discountedPrice : product.price);

    final num totalPrice = unitPrice * state.quantity;

    ProductVariantEntity? selectedVariant;
    try {
      selectedVariant = product.variants.firstWhere(
        (v) => state.selectedOptions.values.every((valId) => v.selectionKey.contains(valId.toString())),
      );
    } catch (_) {
      selectedVariant = product.variants.isNotEmpty ? product.variants.first : null;
    }

    final isOutOfStock = selectedVariant != null ? !selectedVariant.inStock : !product.storage.inStock;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            children: [
              // Right side in RTL: Animated Total Details
              Expanded(
                flex: 2,
                child: _AnimatedTotalWidget(
                  totalPrice: totalPrice.toInt(),
                  quantity: state.quantity,
                  unitTitle: unitTitle,
                  formatter: formatter,
                ),
              ),
              const SizedBox(width: 16.0),

              Expanded(
                flex: 3,
                child: CustomButton(
                  text: isOutOfStock ? 'نفذت الكمية' : 'أضف للسلة',
                  height: 52.0,
                  icon: SvgPicture.asset(
                    AppAssets.cartIcon2,
                    width: 20,
                    height: 20,
                  ),
                  onPressed: isOutOfStock
                      ? null
                      : () {
                          final int? variantId = selectedVariant?.id ??
                              (product.defaultVariantId > 0
                                  ? product.defaultVariantId
                                  : (product.variants.isNotEmpty ? product.variants.first.id : null));

                          final cartItem = CartItemEntity(
                            productId: product.id,
                            productTitle: product.title,
                            productImage: product.mainImage,
                            unitPrice: unitPrice,
                            originalPrice: product.price,
                            quantity: state.quantity,
                            unitId: selectedUnit?.id ?? 0,
                            unitTitle: unitTitle,
                            variantId: variantId,
                            variantLabel: selectedVariant?.label,
                          );

                          context.read<CartBloc>().add(AddToCartEvent(cartItem));
                          AddToCartSnackBar.show(context, item: cartItem);

                          if (onAddToCart != null) {
                            onAddToCart!();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedTotalWidget extends StatelessWidget {
  final int totalPrice;
  final int quantity;
  final String unitTitle;
  final NumberFormat formatter;

  const _AnimatedTotalWidget({
    required this.totalPrice,
    required this.quantity,
    required this.unitTitle,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top line: "الإجمالي · X unit"
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            'الإجمالي · $quantity $unitTitle',
            key: ValueKey('$quantity-$unitTitle'),
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.neutral,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 2.0),
        // Bottom line: "96,000 ل.س"
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.4),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            '${formatter.format(totalPrice)} ل.س',
            key: ValueKey(totalPrice),
            style: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}
