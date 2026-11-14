import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/add_to_cart_snackbar.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';

class ReorderPreviewBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  final OrderDetailsEntity order;

  const ReorderPreviewBottomSheet({
    super.key,
    required this.parentContext,
    required this.order,
  });

  static Future<void> show(BuildContext parentContext, OrderDetailsEntity order) {
    return showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReorderPreviewBottomSheet(
        parentContext: parentContext,
        order: order,
      ),
    );
  }

  @override
  State<ReorderPreviewBottomSheet> createState() =>
      _ReorderPreviewBottomSheetState();
}

class _ReorderPreviewBottomSheetState
    extends State<ReorderPreviewBottomSheet> {
  @override
  void initState() {
    super.initState();
    _fetchPreview();
  }

  void _fetchPreview() {
    final itemsParams = widget.order.items.map((item) {
      return CheckoutPreviewItemParam(
        productId: item.productId,
        productUnitId: item.unitId,
        productVariantId: item.variantId,
        quantity: item.quantity,
      );
    }).toList();

    context.read<CartBloc>().add(
          GetCheckoutPreviewEvent(
            params: CheckoutPreviewParams(items: itemsParams),
          ),
        );
  }

  void _addItemsToCart(CartState cartState) {
    final previewItems = cartState.cartPreview?.items ?? [];
    final List<CartItemEntity> cartItems = [];

    for (var item in widget.order.items) {
      final matches = previewItems.where(
        (p) => p.productId == item.productId && p.unitId == item.unitId,
      );

      final newUnitPrice =
          matches.isNotEmpty ? matches.first.unitPrice : item.unitPrice;

      final cartItem = CartItemEntity(
        productId: item.productId,
        productTitle: item.productName,
        productImage: item.productImage,
        unitPrice: newUnitPrice,
        originalPrice: item.unitPrice,
        quantity: item.quantity,
        unitId: item.unitId,
        unitTitle: item.unitName,
        variantId: item.variantId,
        variantLabel: item.variantLabel,
      );

      context.read<CartBloc>().add(AddToCartEvent(cartItem));
      cartItems.add(cartItem);
    }

    Navigator.pop(context);
    if (cartItems.isNotEmpty) {
      AddToCartSnackBar.show(widget.parentContext, items: cartItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    return Container(
      constraints: BoxConstraints(
        maxHeight: context.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 12.0,
        bottom: MediaQuery.of(context).padding.bottom + 16.0,
      ),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final isLoading = cartState.previewStatus == RequestStatus.loading;
          final preview = cartState.cartPreview;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle & Close Button
              Container(
                width: 40.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: AppColors.neutralBorderStrong,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              const SizedBox(height: 8.0),

              // Title
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    'order_again'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.neutral900),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),

              // Subtitle
              Text(
                'reorder_preview_desc'.tr(args: [widget.order.orderNumber]),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16.0),

              // Content: Loading state OR Products List
              if (isLoading || preview == null) ...[
                const SizedBox(
                  height: 180.0,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary500),
                  ),
                ),
              ] else ...[
                // Card containing order items list
                Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.overMedium,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.order.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 20.0),
                        itemBuilder: (context, index) {
                          final item = widget.order.items[index];
                          final matches = preview.items.where(
                            (p) =>
                                p.productId == item.productId &&
                                p.unitId == item.unitId,
                          );

                          final newUnitPrice = matches.isNotEmpty
                              ? matches.first.unitPrice
                              : item.unitPrice;
                          final oldUnitPrice = item.unitPrice;
                          final priceChanged = newUnitPrice != oldUnitPrice;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image Thumbnail
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: SizedBox(
                                  width: 56.0,
                                  height: 56.0,
                                  child: item.productImage != null &&
                                          item.productImage!.startsWith('http')
                                      ? Image.network(
                                          item.productImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, _, _) => Image.asset(
                                            AppAssets.logoWatermark,
                                            color: AppColors.primary,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Image.asset(
                                          AppAssets.logoWatermark,
                                          color: AppColors.primary,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12.0),

                              // Name, Quantity, New Price Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.neutral900,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      '${item.unitName} × ${item.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    if (priceChanged)
                                      Text(
                                        'price_became_instead'.tr(args: [
                                          '${formatter.format(newUnitPrice)} ${'sp_currency'.tr()}',
                                          formatter.format(oldUnitPrice),
                                        ]),
                                        style: const TextStyle(
                                          color: Color(0xFFB45309),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                        ),
                                      )
                                    else
                                      Text(
                                        '${formatter.format(newUnitPrice)} ${'sp_currency'.tr()}',
                                        style: const TextStyle(
                                          color: AppColors.neutral900,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8.0),

                              // Old line total price
                              Text(
                                '${formatter.format(item.lineTotal)} ${'sp_currency'.tr()}',
                                style: TextStyle(
                                  color: priceChanged
                                      ? AppColors.textSecondary
                                      : AppColors.neutral900,
                                  decoration:
                                      priceChanged ? TextDecoration.lineThrough : null,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Total Today Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'total_today'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutral900,
                          ),
                    ),
                    Text(
                      '${formatter.format(preview.itemsSubtotal)} ${'sp_currency'.tr()}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.neutral900,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Bottom Buttons (Cancel & Add to Cart)
                Row(
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'add_to_cart'.tr(),
                        height: 48.0,
                        onPressed: () => _addItemsToCart(cartState),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'cancel'.tr(),
                        isOutlined: true,
                        height: 48.0,
                        textColor: AppColors.primary,
                        borderColor: AppColors.primary,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
