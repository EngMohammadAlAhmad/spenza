import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
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
            ? 'منتج واحد بسلتك'
            : (itemCount == 2
                ? 'منتجان بسلتك'
                : '$itemCount منتجات بسلتك');

        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                            AppAssets.cartIcon,
                            colorFilter: const ColorFilter.mode(
                              AppColors.primary,
                              BlendMode.overlay,
                            ),
                          ),
                        ),

                        // Yellow Quantity Badge on Top-Left of Circle
                        Positioned(
                          top: -2,
                          left: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2B211),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11.0,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
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
                            '${formatter.format(totalPrice)} ل.س',
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
                        children: const [
                          Text(
                            'عرض السلة',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
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
