import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/utils/tab_index_notifier.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/product_card.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_event.dart';
import 'package:spenza/features/favorites/presentation/widgets/favorites_header.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  /// Index of the Favorites branch in the bottom navigation bar.
  static const int _tabIndex = 2;

  /// Changing this value changes the animation keys, which restarts them.
  int _animTrigger = 0;
  int _lastIndex = navTabIndex.value;

  @override
  void initState() {
    super.initState();
    navTabIndex.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final index = navTabIndex.value;
    if (index == _tabIndex && _lastIndex != _tabIndex && mounted) {
      setState(() => _animTrigger++);
    }
    _lastIndex = index;
  }

  @override
  void dispose() {
    navTabIndex.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyPrefix = 'fav_anim_$_animTrigger';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        StatefulNavigationShell.of(context).goBranch(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        body: Column(
          children: [
            FavoritesHeader(key: ValueKey('${keyPrefix}_header')),
            Expanded(
              child: BlocListener<AuthStatusBloc, AuthStatusState>(
                listener: (context, state) {
                  if (state.isLoggedIn) {
                    context.read<FavoritesBloc>().add(GetFavoritesEvent());
                  }
                },
                child: BlocBuilder<AuthStatusBloc, AuthStatusState>(
                  builder: (context, authState) {
                    if (!authState.isLoggedIn) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: _buildLoginPrompt(context, keyPrefix),
                      );
                    }

                    return BlocBuilder<FavoritesBloc, BaseState<List<ProductEntity>>>(
                      builder: (context, state) {
                        final products = state.data ?? [];

                        if (state.isLoading && products.isEmpty) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                        }

                        if (products.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: _buildNoFavoritesState(context, keyPrefix),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductCard(
                              key: ValueKey('${keyPrefix}_prod_${product.id}'),
                              product: product,
                            )
                                .animate(key: ValueKey('${keyPrefix}_anim_prod_${product.id}'))
                                .fadeIn(
                                  duration: 350.ms,
                                  delay: (index * 40).clamp(0, 200).ms,
                                )
                                .slideY(
                                  begin: 0.08,
                                  end: 0,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, String keyPrefix) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_outline_rounded,
          size: 96.0,
          color: AppColors.primary.withValues(alpha: 0.3),
        )
            .animate(key: ValueKey('${keyPrefix}_login_icon'))
            .scale(duration: 600.ms, curve: Curves.easeOutBack),
        Text(
          'save_your_favorite_products'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
          textAlign: TextAlign.center,
        )
            .animate(key: ValueKey('${keyPrefix}_login_title'))
            .fadeIn(delay: 200.ms)
            .slideY(begin: 0.2, end: 0),
        Text(
          'save_favorites_login_desc'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        )
            .animate(key: ValueKey('${keyPrefix}_login_desc'))
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.2, end: 0.0),
        CustomButton(
          text: 'login'.tr(),
          onPressed: () => context.push(RoutePaths.login),
          icon: SvgPicture.asset(AppAssets.loginIcon),
          width: 200.0,
        )
            .animate(key: ValueKey('${keyPrefix}_login_btn'))
            .fadeIn(delay: 600.ms)
            .scale(begin: const Offset(0.95, 0.95)),
        TextButton(
          onPressed: () => context.go(RoutePaths.home),
          child: Text(
            'browse_store_first'.tr(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ).animate(key: ValueKey('${keyPrefix}_login_browse')).fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildNoFavoritesState(BuildContext context, String keyPrefix) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creative Empty State Illustration for Favorites
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            )
                .animate(key: ValueKey('${keyPrefix}_empty_circle'), onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 2.seconds, curve: Curves.easeInOut),
            Icon(
              Icons.favorite_rounded,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
                .animate(key: ValueKey('${keyPrefix}_empty_heart'), onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -5, end: 5, duration: 1.5.seconds, curve: Curves.easeInOut),
            Positioned(
              top: 20,
              left: 20,
              child: const Icon(Icons.star_rounded, size: 30, color: AppColors.secondary)
                  .animate(key: ValueKey('${keyPrefix}_empty_star'), onPlay: (c) => c.repeat())
                  .rotate(duration: 4.seconds),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: const Icon(Icons.auto_awesome, size: 25, color: AppColors.secondary)
                  .animate(key: ValueKey('${keyPrefix}_empty_sparkle'), onPlay: (c) => c.repeat(reverse: true))
                  .scaleXY(begin: 0.8, end: 1.2, duration: 2.seconds),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'your_favorites_waiting'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
          textAlign: TextAlign.center,
        )
            .animate(key: ValueKey('${keyPrefix}_empty_title'))
            .fadeIn(delay: 200.ms)
            .slideY(begin: 0.2, end: 0),
        Text(
          'empty_favorites_desc'.tr(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        )
            .animate(key: ValueKey('${keyPrefix}_empty_desc'))
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.2, end: 0.0),
        const SizedBox(height: 10),
        CustomButton(
          text: 'discover_products'.tr(),
          onPressed: () => context.go(RoutePaths.categories),
          width: 220.0,
        )
            .animate(key: ValueKey('${keyPrefix}_empty_btn'))
            .fadeIn(delay: 600.ms)
            .scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }
}
