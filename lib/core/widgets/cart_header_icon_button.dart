import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/app_icon_container.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';

/// A clean, reactive header button that displays a cart icon inside an [AppIconContainer]
/// with a live, animated quantity badge connected to [CartBloc].
class CartHeaderIconButton extends StatelessWidget {
  final String iconPath;
  final double size;
  final double iconSize;
  final bool isCircle;
  final bool primaryColors;
  final Color badgeColor;
  final Color badgeTextColor;
  final Color badgeBorderColor;
  final VoidCallback? onPressed;

  const CartHeaderIconButton({
    super.key,
    this.iconPath = AppAssets.cartIcon,
    this.size = 44.0,
    this.iconSize = 22.0,
    this.isCircle = true,
    this.primaryColors = false,
    this.badgeColor = AppColors.primary,
    this.badgeTextColor = Colors.white,
    this.badgeBorderColor = Colors.white,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          previous.totalItemsCount != current.totalItemsCount,
      builder: (context, state) {
        final itemCount = state.totalItemsCount;
        final hasItems = itemCount > 0;
        final badgeText = itemCount > 99 ? '99+' : '$itemCount';

        final effectiveOnPressed = onPressed ??
            () {
              if (GoRouterState.of(context).matchedLocation != RoutePaths.cart) {
                context.push(RoutePaths.cart);
              }
            };

        return Stack(
          clipBehavior: Clip.none,
          children: [
            AppIconContainer(
              iconPath: iconPath,
              size: size,
              iconSize: iconSize,
              isCircle: isCircle,
              primaryColors: primaryColors,
              onPressed: effectiveOnPressed,
            ),
            PositionedDirectional(
              top: -5,
              end: -6,
              child: AnimatedScale(
                scale: hasItems ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutBack,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(itemCount),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7.0,
                      vertical: 1.0,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 17.0,
                      minHeight: 17.0,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: badgeBorderColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
