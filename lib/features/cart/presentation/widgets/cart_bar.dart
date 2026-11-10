import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';

class CartBar extends StatelessWidget {
  const CartBar({super.key});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return const SizedBox.shrink();
        }

        final itemCount = state.totalItemsCount;
        final totalPrice = state.totalCartPrice;

        final itemText = itemCount == 1
            ? 'one_item_in_cart'.tr()
            : (itemCount == 2
                ? 'two_items_in_cart'.tr()
                : 'n_items_in_cart'.tr(args: ['$itemCount']));

        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.isTablet ? context.width * 0.33 : 16.0),
            child: InkWell(
              onTap: () {
                if (GoRouterState.of(context).matchedLocation != RoutePaths.cart) {
                  context.push(RoutePaths.cart);
                }
              },
              borderRadius: AppRadius.extraLarge,
              child: Container(
                height: 60.0,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.primaryBold,
                      AppColors.primary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: AppRadius.brandRadius,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Right Side (RTL Start): Shopping Bag Icon with Badge + Text Column
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // White Circle Icon Container
                        Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppAssets.cartIcon2,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),

                        // Yellow Quantity Badge on Top-Left of Circle
                        Positioned(
                          top: -5.0,
                          left: -5.0,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 22.0,
                              minHeight: 22.0,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$itemCount',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12.0),

                    // Info Column (Count & Price)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            itemText,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1.0),
                          Text(
                            '${formatter.format(totalPrice)} ${'sp_currency'.tr()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Left Side (RTL End): White Pill Button ("عرض السلة <")
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.large,
                      ),
                      child: Row(
                        spacing: 2.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'view_cart'.tr(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 18.0,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
