import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/core/widgets/view_all_button.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/injection_locator.dart' as di;

class OrderAgainSection extends StatelessWidget {
  const OrderAgainSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<OrdersBloc>()..add(const GetMyOrdersEvent(page: 1)),
      child: const _OrderAgainContent(),
    );
  }
}

class _OrderAgainContent extends StatelessWidget {
  const _OrderAgainContent();

  void _goToOrdersTab(BuildContext context) {
    try {
      StatefulNavigationShell.of(context).goBranch(3);
    } catch (_) {
      context.go(RoutePaths.orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final isLoading =
            state.getMyOrdersStatus == RequestStatus.loading && state.orders.isEmpty;
        final isEmpty = state.orders.isEmpty;

        return Column(
          spacing: 12.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اطلبها من جديد',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                ViewAllButton(
                  onPressed: () => _goToOrdersTab(context),
                  text: 'طلباتي',
                ),
              ],
            ),
            if (isLoading)
              SizedBox(
                height: 214.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (_, _) => const SizedBox(width: 12.0),
                  itemBuilder: (context, index) => const ShimmerPlaceholder(
                    width: 156.0,
                    height: 214.0,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              )
            else if (isEmpty)
              _EmptyOrderAgainCard(
                onOrdersPressed: () => _goToOrdersTab(context),
              )
            else
              SizedBox(
                height: 214.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.orders.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12.0),
                  itemBuilder: (context, index) {
                    final order = state.orders[index];
                    return OrderAgainCard(order: order)
                        .animate(delay: (60 * index).ms)
                        .fadeIn(duration: 400.ms)
                        .slideX(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EmptyOrderAgainCard extends StatelessWidget {
  final VoidCallback onOrdersPressed;

  const _EmptyOrderAgainCard({required this.onOrdersPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.overMedium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        spacing: 14.0,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.orderAgainIcon,
              width: 28.0,
              height: 28.0,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لا توجد طلبات سابقة لإعادة طلبها',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  'اطلب منتجاتك الأولى وستظهر هنا لإعادة طلبها بضغطة زر.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutral,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderAgainCard extends StatefulWidget {
  final OrderResponseEntity order;

  const OrderAgainCard({super.key, required this.order});

  @override
  State<OrderAgainCard> createState() => _OrderAgainCardState();
}

class _OrderAgainCardState extends State<OrderAgainCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final formatter = NumberFormat('#,##0');

    final String imagePath = order.itemImages.isNotEmpty
        ? order.itemImages.first
        : AppAssets.tempOrderAgain1;

    final String title = order.orderNumber.isNotEmpty
        ? 'طلب #${order.orderNumber}'
        : 'طلب سابق';

    final String dateStr = order.placedAt.isNotEmpty
        ? 'طلبته ${order.placedAt}'
        : (order.createdAt != null && order.createdAt!.isNotEmpty
            ? 'طلبته ${order.createdAt}'
            : 'طلب سابق');

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        context.push(RoutePaths.orderDetails, extra: order.orderNumber);
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          width: 156.0,
          height: 214.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.large,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12.0,
                spreadRadius: 0.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
                child: SizedBox(
                  width: 156.0,
                  height: 110.0,
                  child: imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          width: 156.0,
                          height: 110.0,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Image.asset(
                            AppAssets.tempOrderAgain1,
                            width: 156.0,
                            height: 110.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          width: 156.0,
                          height: 110.0,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Image.asset(
                            AppAssets.tempOrderAgain1,
                            width: 156.0,
                            height: 110.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              // Bottom Details Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.neutral900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            dateStr,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.neutral,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${formatter.format(order.totalAmount)} ل.س',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.0,
                                  color: AppColors.neutral900,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              SnackbarService.showSuccess(
                                context,
                                message: 'تمت إضافة طلبك لإعادة الطلب',
                              );
                            },
                            borderRadius: AppRadius.large,
                            child: Container(
                              width: 36.0,
                              height: 36.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDB6C60),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 22.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
