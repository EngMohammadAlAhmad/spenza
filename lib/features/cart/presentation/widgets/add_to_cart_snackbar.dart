import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

class AddToCartSnackBar {
  AddToCartSnackBar._();

  static void show(
    BuildContext parentContext, {
    CartItemEntity? item,
    List<CartItemEntity>? items,
  }) {
    final itemList = items ?? (item != null ? [item] : <CartItemEntity>[]);
    if (itemList.isEmpty) return;

    final formatter = NumberFormat('#,##0');
    final overlay = Overlay.of(parentContext);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => _AddToCartBannerWidget(
        items: itemList,
        formatter: formatter,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
        onViewCart: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
          if (parentContext.mounted) {
            try {
              final location = GoRouterState.of(parentContext).matchedLocation;
              if (location != RoutePaths.cart) {
                parentContext.push(RoutePaths.cart);
              }
            } catch (_) {
              parentContext.push(RoutePaths.cart);
            }
          }
        },
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _AddToCartBannerWidget extends StatefulWidget {
  final List<CartItemEntity> items;
  final NumberFormat formatter;
  final VoidCallback onDismiss;
  final VoidCallback onViewCart;

  const _AddToCartBannerWidget({
    required this.items,
    required this.formatter,
    required this.onDismiss,
    required this.onViewCart,
  });

  @override
  State<_AddToCartBannerWidget> createState() => _AddToCartBannerWidgetState();
}

class _AddToCartBannerWidgetState extends State<_AddToCartBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItemImage(String? url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.neutral,
          size: 18,
        ),
      );
    }
    return const Icon(
      Icons.image_outlined,
      color: AppColors.neutral,
      size: 18,
    );
  }

  Widget _buildThumbnailWidget() {
    final items = widget.items;
    if (items.length == 1) {
      final singleItem = items.first;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: AppRadius.mediumPlus,
              color: AppColors.neutral200,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.mediumPlus,
              child: _buildItemImage(singleItem.productImage),
            ),
          ),
          Positioned(
            bottom: -2.0,
            left: -2.0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF2EA45B),
                size: 20.0,
              ),
            ),
          ),
        ],
      );
    }

    final firstImage = items[0].productImage;
    final secondImage = items.length > 1 ? items[1].productImage : null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 50.0,
          height: 50.0,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.medium,
                    color: AppColors.neutral200,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: _buildItemImage(secondImage),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                left: 0,
                child: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.medium,
                    color: AppColors.neutral200,
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.medium,
                    child: _buildItemImage(firstImage),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -2.0,
          left: -2.0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF2EA45B),
              size: 20.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;
    final horizontalPadding = isTabletLandscape
        ? (context.width - (context.width * 0.33)) / 2
        : 16.0;

    final isSingleItem = widget.items.length == 1;
    final singleItem = widget.items.first;

    final num totalPrice = widget.items.fold(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    final titleText = isSingleItem
        ? 'added_qty_unit_to_cart'.tr(
            args: ['${singleItem.quantity}', singleItem.unitTitle],
          )
        : 'added_n_items_to_cart'.tr(
            args: ['${widget.items.length}'],
          );

    return Positioned(
      bottom: 120.0,
      left: horizontalPadding,
      right: horizontalPadding,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.extraLarge4,
              border: Border.all(color: AppColors.neutral200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 20.0,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              spacing: 12.0,
              children: [
                _buildThumbnailWidget(),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titleText,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'total_amount_currency'.tr(
                          args: [widget.formatter.format(totalPrice)],
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onViewCart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: AppRadius.extraLarge,
                    ),
                    child: Text(
                      'view_cart'.tr(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
