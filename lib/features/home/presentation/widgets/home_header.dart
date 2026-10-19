import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/animations/circular_reveal_route.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/app_header.dart';
import 'package:spenza/core/widgets/app_search_field.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/features/search/presentation/screens/search_screen.dart';
import 'package:spenza/injection_locator.dart' as di;

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = di.sl<CacheHelper>().getAuthToken().isNotEmpty;
    final bloc = di.sl<AddressesBloc>();
    if (isLoggedIn) {
      bloc.add(const GetAddressesEvent());
    }

    return BlocProvider.value(
      value: bloc,
      child: const _HomeHeaderContent(),
    );
  }
}

class _HomeHeaderContent extends StatelessWidget {
  const _HomeHeaderContent();

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = di.sl<CacheHelper>().getAuthToken().isNotEmpty;

    return AppHeader(
      style: AppHeaderStyle.light,
      backgroundColor: AppColors.backgroundLight,
      showBackButton: false,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(34.0),
        bottomRight: Radius.circular(34.0),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      ),
      titleWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<AddressesBloc, AddressesState>(
            builder: (context, state) {
              String addressText = 'اختر منطقتك';

              if (isLoggedIn && state.addresses.isNotEmpty) {
                final defaultMatches = state.addresses.where((a) => a.isDefault);
                final defaultAddr = defaultMatches.isNotEmpty
                    ? defaultMatches.first
                    : state.addresses.first;
                addressText = defaultAddr.fullTitle;
              }

              return InkWell(
                onTap: () async {
                  if (!isLoggedIn) {
                    context.push(RoutePaths.login);
                    return;
                  }

                  if (state.addresses.isEmpty) {
                    final result = await context.push(RoutePaths.addAddress);
                    if (result == true && context.mounted) {
                      context.read<AddressesBloc>().add(const GetAddressesEvent());
                    }
                  } else {
                    await context.push(RoutePaths.addresses);
                    if (context.mounted) {
                      context.read<AddressesBloc>().add(const GetAddressesEvent());
                    }
                  }
                },
                borderRadius: AppRadius.small,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(AppAssets.locationIcon),
                      const SizedBox(width: 6.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'التوصيل لِـ',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.neutral),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                addressText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(width: 2.0),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18.0,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            spacing: 5.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: const EdgeInsets.all(6.0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  if (GoRouterState.of(context).matchedLocation != RoutePaths.cart) {
                    context.push(RoutePaths.cart);
                  }
                },
                icon: SvgPicture.asset(AppAssets.cartIcon),
              ),
              IconButton(
                padding: const EdgeInsets.all(6.0),
                constraints: const BoxConstraints(),
                onPressed: () {
                  context.push(RoutePaths.notifications);
                },
                icon: SvgPicture.asset(AppAssets.notificationsIcon),
              ),
            ],
          ),
        ],
      ).animate().fadeIn(delay: 200.ms, duration: 600.ms).slideX(begin: 0.1, end: 0),
      bottomChild: GestureDetector(
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
    ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic);
  }
}
