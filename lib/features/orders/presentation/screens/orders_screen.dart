import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/utils/tab_index_notifier.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/features/orders/presentation/widgets/order_card.dart';
import 'package:spenza/features/orders/presentation/widgets/orders_header.dart';
import 'package:spenza/injection_locator.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  /// Index of the Orders branch in the bottom navigation bar.
  static const int _tabIndex = 3;

  /// Changing this value changes the animation keys, which restarts them.
  int _animTrigger = 0;
  int _lastIndex = navTabIndex.value;
  int _guestTabIndex = 0;

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
    final keyPrefix = 'orders_anim_$_animTrigger';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        StatefulNavigationShell.of(context).goBranch(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        body: BlocBuilder<AuthStatusBloc, AuthStatusState>(
          builder: (context, authState) {
            if (!authState.isLoggedIn) {
              return Column(
                children: [
                  OrdersHeader(
                    key: ValueKey('${keyPrefix}_guest_header'),
                    selectedTabIndex: _guestTabIndex,
                    activeCount: 0,
                    completedCount: 0,
                    onTabChanged: (index) {
                      setState(() => _guestTabIndex = index);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildLoginPrompt(context, keyPrefix),
                    ),
                  ),
                ],
              );
            }

            return BlocProvider<OrdersBloc>.value(
              value: sl<OrdersBloc>()..add(const GetMyOrdersEvent()),
              child: _OrdersContent(
                key: ValueKey('${keyPrefix}_content'),
                animTrigger: _animTrigger,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, String keyPrefix) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppAssets.ordersScreenIcon,
          height: 96.0,
          width: 96.0,
        )
            .animate(key: ValueKey('${keyPrefix}_login_icon'))
            .scale(duration: 600.ms, curve: Curves.easeOutBack),
        Text(
          'track_orders_easily'.tr(),
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
          'login_orders_desc'.tr(),
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
}

class _OrdersContent extends StatefulWidget {
  final int animTrigger;
  const _OrdersContent({super.key, required this.animTrigger});

  @override
  State<_OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<_OrdersContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200) {
      context.read<OrdersBloc>().add(const LoadMoreOrdersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyPrefix = 'user_orders_${widget.animTrigger}';

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Column(
          children: [
            // Header with Tab Switcher
            OrdersHeader(
              key: ValueKey('${keyPrefix}_header'),
              selectedTabIndex: state.selectedTabIndex,
              activeCount: state.activeCount,
              completedCount: state.completedCount,
              onTabChanged: (index) {
                context.read<OrdersBloc>().add(ChangeOrdersTabEvent(index));
              },
            ),

            // Orders Body View with Smooth Section Transition
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  final isRtl = Directionality.of(context) == TextDirection.rtl;
                  final isFirstTab = state.selectedTabIndex == 0;
                  final beginOffset = isFirstTab
                      ? (isRtl ? const Offset(-0.12, 0.0) : const Offset(0.12, 0.0))
                      : (isRtl ? const Offset(0.12, 0.0) : const Offset(-0.12, 0.0));

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: beginOffset,
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<String>('${keyPrefix}_tab_${state.selectedTabIndex}'),
                  child: RefreshIndicator(
                    color: AppColors.primary500,
                    onRefresh: () async {
                      context
                          .read<OrdersBloc>()
                          .add(const GetMyOrdersEvent(isRefresh: true));
                    },
                    child: _buildOrdersBody(context, state, keyPrefix),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersBody(BuildContext context, OrdersState state, String keyPrefix) {
    if (state.getMyOrdersStatus == RequestStatus.loading && state.orders.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary500),
      );
    }

    if (state.getMyOrdersStatus == RequestStatus.error && state.orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppAssets.errorOccurred),
              const SizedBox(height: 12.0),
              Text(
                'orders_load_error'.tr(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'try_again'.tr(),
                icon: SvgPicture.asset(
                  AppAssets.refreshIcon,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                width: 160.0,
                onPressed: () {
                  context.read<OrdersBloc>().add(const GetMyOrdersEvent());
                },
              ),
            ],
          ),
        ),
      );
    }

    final currentOrders = state.currentTabOrders;

    if (currentOrders.isEmpty) {
      return _buildEmptyOrdersState(context, keyPrefix);
    }

    final isTabletLandscape = context.isTabletLandscape;

    if (isTabletLandscape) {
      return GridView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.only(
          left: 24.0,
          top: 16.0,
          right: 24.0,
          bottom: context.screenPadding.bottom + 10.0,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          mainAxisExtent: 210.0,
        ),
        itemCount: currentOrders.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= currentOrders.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary500),
              ),
            );
          }

          final order = currentOrders[index];
          return OrderCard(
            order: order,
            margin: EdgeInsets.zero,
            onTap: () => context.push(RoutePaths.orderDetails, extra: order.orderNumber),
          )
              .animate(key: ValueKey('${keyPrefix}_card_${order.id}'))
              .fadeIn(
                duration: 250.ms,
                delay: (index * 40).clamp(0, 240).ms,
              )
              .slideY(
                begin: 0.08,
                end: 0,
                curve: Curves.easeOutCubic,
              );
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
        bottom: context.screenPadding.bottom + 10.0,
      ),
      itemCount: currentOrders.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= currentOrders.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary500),
            ),
          );
        }

        final order = currentOrders[index];
        return OrderCard(
          order: order,
          onTap: () => context.push(RoutePaths.orderDetails, extra: order.orderNumber),
        )
            .animate(key: ValueKey('${keyPrefix}_card_${order.id}'))
            .fadeIn(
              duration: 250.ms,
              delay: (index * 40).clamp(0, 240).ms,
            )
            .slideY(
              begin: 0.08,
              end: 0,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }

  Widget _buildEmptyOrdersState(BuildContext context, String keyPrefix) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.height * 0.6,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Double Soft Circle Icon Background
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDE8E8),
                    shape: BoxShape.circle,
                  ),
                ),
                SvgPicture.asset(
                  AppAssets.noOrdersIcon,
                  fit: BoxFit.contain,
                ),
              ],
            )
                .animate(key: ValueKey('${keyPrefix}_empty_icon'))
                .scale(duration: 500.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 28.0),

            // Empty Title
            Text(
              'no_orders_yet'.tr(),
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
            )
                .animate(key: ValueKey('${keyPrefix}_empty_title'))
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 8.0),

            // Empty Subtitle
            Text(
              'orders_empty_desc'.tr(),
              style: const TextStyle(
                fontSize: 14.0,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            )
                .animate(key: ValueKey('${keyPrefix}_empty_desc'))
                .fadeIn(delay: 350.ms)
                .slideY(begin: 0.2, end: 0),

            const SizedBox(height: 32.0),

            // Start Shopping CTA Button
            CustomButton(
              text: 'start_shopping'.tr(),
              width: context.isTabletLandscape ? context.width * 0.35 : 220.0,
              height: 48.0,
              onPressed: () => context.go(RoutePaths.home),
            )
                .animate(key: ValueKey('${keyPrefix}_empty_btn'))
                .fadeIn(delay: 500.ms)
                .scale(begin: const Offset(0.95, 0.95)),
          ],
        ),
      ),
    );
  }
}
