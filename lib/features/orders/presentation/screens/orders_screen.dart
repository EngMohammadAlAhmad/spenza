import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/features/orders/presentation/widgets/order_card.dart';
import 'package:spenza/features/orders/presentation/widgets/orders_header.dart';
import 'package:spenza/injection_locator.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  const OrdersHeader(
                    selectedTabIndex: 0,
                    activeCount: 0,
                    completedCount: 0,
                    onTabChanged: _dummyTabChange,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildLoginPrompt(context),
                    ),
                  ),
                ],
              );
            }

            return BlocProvider<OrdersBloc>(
              create: (context) => sl<OrdersBloc>()..add(const GetMyOrdersEvent()),
              child: const _OrdersContent(),
            );
          },
        ),
      ),
    );
  }

  static void _dummyTabChange(int index) {}

  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/orders_screen_icon.svg',
          height: 96.0,
          width: 96.0,
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
        Text(
          'تابع طلباتك بسهولة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        Text(
          'سجّل دخول حتى تشوف طلباتك الحالية والسابقة وتعيد الطلب بضغطة.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0.0),
        CustomButton(
          text: 'تسجيل الدخول',
          onPressed: () => context.push(RoutePaths.login),
          icon: SvgPicture.asset('assets/icons/login_icon.svg'),
          width: 200.0,
        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
        TextButton(
          onPressed: () => context.go(RoutePaths.home),
          child: Text(
            'تصفّح المتجر أولاً',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }
}

class _OrdersContent extends StatefulWidget {
  const _OrdersContent();

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
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 200) {
      context.read<OrdersBloc>().add(const LoadMoreOrdersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return Column(
          children: [
            // Header with Tab Switcher
            OrdersHeader(
              selectedTabIndex: state.selectedTabIndex,
              activeCount: state.activeCount,
              completedCount: state.completedCount,
              onTabChanged: (index) {
                context.read<OrdersBloc>().add(ChangeOrdersTabEvent(index));
              },
            ),

            // Orders Body View
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary500,
                onRefresh: () async {
                  //context.read<OrdersBloc>().add(const GetMyOrdersEvent(isRefresh: true));
                },
                child: _buildOrdersBody(context, state),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrdersBody(BuildContext context, OrdersState state) {
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
              const Icon(
                Icons.error_outline_rounded,
                size: 60.0,
                color: AppColors.primary500,
              ),
              const SizedBox(height: 12.0),
              const Text(
                'حدث خطأ أثناء تحميل الطلبات',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                text: 'إعادة المحاولة',
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
      return _buildEmptyOrdersState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
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
        );
      },
    );
  }

  Widget _buildEmptyOrdersState(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
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
                  'assets/icons/no_orders_icon.svg',
                  fit: BoxFit.contain,
                ),
              ],
            ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 28.0),

            // Empty Title
            const Text(
              'لسا ما عندك طلبات',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 8.0),

            // Empty Subtitle
            const Text(
              'أول ما تطلب، بتلاقي هون حالة طلبك ودفعه وفاتورته.',
              style: TextStyle(
                fontSize: 14.0,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 32.0),

            // Start Shopping CTA Button
            CustomButton(
              text: 'ابدأ التسوق',
              width: 220.0,
              height: 48.0,
              onPressed: () => context.go(RoutePaths.home),
            ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95)),
          ],
        ),
      ),
    );
  }
}
