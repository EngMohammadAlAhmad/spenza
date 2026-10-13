import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/dimens.dart';
import 'package:spenza/core/widgets/app_search_field.dart';

import 'package:spenza/core/utils/animations/circular_reveal_route.dart';
import 'package:spenza/features/search/presentation/screens/search_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 186.44,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.0,
        right: 16.0,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34.0),
          bottomRight: Radius.circular(34.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: .spaceEvenly,
        children: [
          Row(
            spacing: 5.0,
            mainAxisAlignment: .spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset('assets/icons/location_icon.svg'),
                onPressed: () {},
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    'التوصيل لِـ',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.neutral),
                  ),
                  Text(
                    'المنزل - دمشق',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (GoRouterState.of(context).matchedLocation != RoutePaths.cart) {
                    context.push(RoutePaths.cart);
                  }
                },
                icon: SvgPicture.asset('assets/icons/cart_icon.svg'),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: SvgPicture.asset('assets/icons/notifications_icon.svg'),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: 0.1, end: 0),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              Navigator.push(
                context,
                CircularRevealRoute(
                  page: const SearchScreen(),
                  center: details.globalPosition,
                ),
              );
            },
            child: const AbsorbPointer(
              child: AppSearchField(
                readOnly: true,
              ),
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms).scale(begin: const Offset(0.95, 0.95)),
          SizedBox(height: AppDimens.spaceS),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic);
  }
}
