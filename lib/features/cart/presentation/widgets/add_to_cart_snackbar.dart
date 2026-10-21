import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

class AddToCartSnackBar {
  AddToCartSnackBar._();

  static void show(BuildContext parentContext, {required CartItemEntity item}) {
    final formatter = NumberFormat('#,##0');
    final overlay = Overlay.of(parentContext);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => _AddToCartBannerWidget(
        item: item,
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
  final CartItemEntity item;
  final NumberFormat formatter;
  final VoidCallback onDismiss;
  final VoidCallback onViewCart;

  const _AddToCartBannerWidget({
    required this.item,
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

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120.0,
      left: 16.0,
      right: 16.0,
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
                // Product Image with Checkmark Badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.mediumPlus,
                        color: AppColors.neutral200,
                      ),
                      child: ClipRRect(
                        borderRadius: AppRadius.mediumPlus,
                        child: widget.item.productImage != null && widget.item.productImage!.isNotEmpty
                            ? Image.network(
                          widget.item.productImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.neutral,
                          ),
                        ) : const Icon(
                          Icons.image_outlined,
                          color: AppColors.neutral,
                        ),
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
                ),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'انضافت ${widget.item.quantity} ${widget.item.unitTitle} لسلتك',
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
                        'المجموع ${widget.formatter.format(widget.item.totalPrice)} ل.س',
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
                    child: const Text(
                      'عرض السلة',
                      style: TextStyle(
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
