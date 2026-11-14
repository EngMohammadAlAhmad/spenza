import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/utils/tab_index_notifier.dart';
import 'package:spenza/core/widgets/no_internet_widget.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/features/cart/presentation/widgets/cart_bar.dart';
import 'package:spenza/features/home/domain/entities/home_data_entity.dart';
import 'package:spenza/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:spenza/features/home/presentation/widgets/banner_slider.dart';
import 'package:spenza/features/home/presentation/widgets/free_delivery_card.dart';
import 'package:spenza/features/home/presentation/widgets/points_card.dart';
import 'package:spenza/features/home/presentation/widgets/best_selling_section.dart';
import 'package:spenza/features/home/presentation/widgets/home_header.dart';
import 'package:spenza/features/home/presentation/widgets/order_again_section.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_brand_section.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_category_section.dart';
import 'package:spenza/features/home/presentation/widgets/today_orders_section.dart';
import 'package:spenza/features/language/domain/entities/language_entity.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/injection_locator.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Index of the Home branch in the bottom navigation bar.
  static const int _tabIndex = 0;

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
    final bottomInset = context.screenPadding.bottom;
    final keyPrefix = 'home_anim_$_animTrigger';
    final isTablet = context.isTablet;

    return BlocProvider(
      create: (context) => di.sl<HomeBloc>()..add(const GetHomeDataEvent()),
      child: BlocListener<LanguageBloc, BaseState<LanguageEntity>>(
        listenWhen: (previous, current) =>
            previous.data?.code != current.data?.code,
        listener: (context, state) {
          context.read<HomeBloc>().add(const GetHomeDataEvent());
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
          backgroundColor: AppColors.neutralBackgroundCanvasColor(context),
          body: BlocBuilder<HomeBloc, BaseState<HomeDataEntity>>(
            builder: (context, state) {
              if (state.isError && state.data == null) {
                if (state.failure is OfflineFailure) {
                  return Column(
                    children: [
                      HomeHeader(key: ValueKey('${keyPrefix}_header')),
                      Expanded(
                        child: NoInternetWidget(
                          onRetry: () {
                            context.read<HomeBloc>().add(const GetHomeDataEvent());
                          },
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: Text(state.errorMessage));
              }

              final data = state.data;
              final isLoading = state.isLoading || data == null;
              final isLoggedIn = di.sl<CacheHelper>().getAuthToken().isNotEmpty;

              return Stack(
                children: [
                  Column(
                    children: [
                      HomeHeader(key: ValueKey('${keyPrefix}_header')),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<HomeBloc>().add(const GetHomeDataEvent());
                          },
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 170.0),
                            child: Column(
                              spacing: 25.0,
                              children: [
                                BannerSlider(
                                  banners: data?.banners ?? [],
                                  isLoading: isLoading,
                                )
                                    .animate(key: ValueKey('${keyPrefix}_banner'))
                                    .fadeIn(duration: 500.ms)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                                if (isTablet && isLoggedIn)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: const PointsCard()
                                                .animate(key: ValueKey('${keyPrefix}_points'), delay: 60.ms)
                                                .fadeIn(duration: 450.ms)
                                                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                                          ),
                                          const SizedBox(width: 16.0),
                                          Expanded(
                                            child: const FreeDeliveryCard()
                                                .animate(key: ValueKey('${keyPrefix}_free_delivery'), delay: 160.ms)
                                                .fadeIn(duration: 450.ms)
                                                .scaleXY(begin: 0.94, end: 1, curve: Curves.easeOutCubic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (!isTablet && isLoggedIn)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: const PointsCard()
                                        .animate(key: ValueKey('${keyPrefix}_points'), delay: 60.ms)
                                        .fadeIn(duration: 450.ms)
                                        .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                                  ),

                                ShopByCategorySection(
                                  categories: data?.categories ?? [],
                                  isLoading: isLoading,
                                )
                                    .animate(key: ValueKey('${keyPrefix}_categories'), delay: 80.ms)
                                    .fadeIn(duration: 450.ms)
                                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                                if (isLoggedIn)
                                  const OrderAgainSection()
                                      .animate(key: ValueKey('${keyPrefix}_order_again'), delay: 120.ms)
                                      .fadeIn(duration: 450.ms)
                                      .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                                if (!isTablet || !isLoggedIn)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: const FreeDeliveryCard()
                                        .animate(key: ValueKey('${keyPrefix}_free_delivery'), delay: 160.ms)
                                        .fadeIn(duration: 450.ms)
                                        .scaleXY(begin: 0.94, end: 1, curve: Curves.easeOutCubic),
                                  ),

                                TodayOffersSection(
                                  products: data?.discountedProducts ?? [],
                                  isLoading: isLoading,
                                )
                                    .animate(key: ValueKey('${keyPrefix}_today_offers'), delay: 320.ms)
                                    .fadeIn(duration: 450.ms)
                                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                                ShopByBrandSection(
                                  brands: data?.brands ?? [],
                                  isLoading: isLoading,
                                )
                                    .animate(key: ValueKey('${keyPrefix}_brands'), delay: 400.ms)
                                    .fadeIn(duration: 450.ms)
                                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                                BestSellingSection(
                                  products: data?.products ?? [],
                                  isLoading: isLoading,
                                )
                                    .animate(key: ValueKey('${keyPrefix}_best_selling'), delay: 480.ms)
                                    .fadeIn(duration: 450.ms)
                                    .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20.0 + bottomInset,
                    child: const CartBar(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
}
}
