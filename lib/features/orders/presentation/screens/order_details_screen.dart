import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_stage_entity.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/injection_locator.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailsScreen({
    super.key,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => sl<OrdersBloc>()..add(GetOrderDetailsEvent(orderNumber)),
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state.getOrderDetailsStatus == RequestStatus.loading) {
              return const Scaffold(
                backgroundColor: Color(0xFFF9F6F2),
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.primary500),
                ),
              );
            }

            if (state.getOrderDetailsStatus == RequestStatus.error ||
                state.orderDetails == null) {
              return Scaffold(
                backgroundColor: AppColors.neutralBackground,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.neutral900),
                    onPressed: () => context.pop(),
                  ),
                ),
                body: Center(
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
                        'تعذر تحميل تفاصيل الطلب',
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
                          context.read<OrdersBloc>().add(GetOrderDetailsEvent(orderNumber));
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            final order = state.orderDetails!;
            return _OrderDetailsContent(order: order);
          },
        ),
      ),
    );
  }
}

class _OrderDetailsContent extends StatelessWidget {
  final OrderDetailsEntity order;

  const _OrderDetailsContent({required this.order});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Red Curved Header
          _buildHeader(context),

          // Cards Content
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
            child: Column(
              spacing: 14.0,
              children: [
                // 1. Stepper Card
                _buildStepperCard(context),

                // 2. Payment Card
                _buildPaymentCard(context, formatter),

                // 3. Delivery Address Card
                _buildDeliveryCard(context),

                // 4. Products & Totals Card
                _buildProductsCard(context, formatter),

                // 5. Invoice Card
                _buildInvoiceCard(context),

                // 6. Help Card
                _buildHelpCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFC74436),
            Color(0xFFA62D22),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28.0)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Navigation Row
              InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(8.0),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.0,
                  children: [
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    Text(
                      'تفاصيل الطلب',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20.0),

              // Status and Order Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order Details Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_formatDate(order.placedAt)} · ${order.orderNumber}',
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        order.statusLabel.isNotEmpty
                            ? order.statusLabel
                            : 'قيد الانتظار',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Red Package Icon Box
                  Container(
                    width: 52.0,
                    height: 52.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/no_orders_icon.svg',
                      width: 28.0,
                      height: 28.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepperCard(BuildContext context) {
    final tracking = order.tracking;
    final stages = _getTrackingStages(tracking);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Horizontal Stepper Row (RTL: Step 1 on Right -> Step 4 on Left)
          Row(
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isEven) {
                final stageIndex = index ~/ 2;
                final stage = stages[stageIndex];
                return _buildStepNode(stage);
              } else {
                final leftStageIndex = (index - 1) ~/ 2;
                final rightStage = stages[leftStageIndex];
                final isReached = rightStage.isReached;
                return Expanded(
                  child: Container(
                    height: 3.0,
                    color: isReached
                        ? const Color(0xFFC74436)
                        : const Color(0xFFE5E7EB),
                  ),
                );
              }
            }),
          ),

          const SizedBox(height: 12.0),

          // Step Titles Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stages.map((stage) {
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      stage.title,
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: stage.isCurrent || stage.isReached
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: stage.isCurrent
                            ? const Color(0xFFC74436)
                            : (stage.isReached
                                ? AppColors.neutral900
                                : AppColors.textSecondary),
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(OrderTrackingStageEntity stage) {
    if (stage.isCurrent) {
      return Container(
        width: 44.0,
        height: 44.0,
        decoration: const BoxDecoration(
          color: Color(0xFFFDE8E8),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 32.0,
          height: 32.0,
          decoration: const BoxDecoration(
            color: Color(0xFFC74436),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            _getStageIcon(stage.key),
            size: 16.0,
            color: Colors.white,
          ),
        ),
      );
    } else if (stage.isReached) {
      return Container(
        width: 28.0,
        height: 28.0,
        decoration: const BoxDecoration(
          color: Color(0xFFC74436),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.check_rounded,
          size: 16.0,
          color: Colors.white,
        ),
      );
    } else {
      return Container(
        width: 28.0,
        height: 28.0,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFFD1D5DB),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          _getStageIcon(stage.key),
          size: 14.0,
          color: const Color(0xFF9CA3AF),
        ),
      );
    }
  }

  Widget _buildPaymentCard(BuildContext context, NumberFormat formatter) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الدفع',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  order.paymentMethodLabel.isNotEmpty
                      ? order.paymentMethodLabel
                      : 'بتدفع عند الاستلام',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            '${order.paymentMethodLabel} · جهّز ${formatter.format(order.total)} ل.س للمندوب',
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard(BuildContext context) {
    final addr = order.deliveryAddress;
    final del = order.delivery;

    final addressTitle = addr != null && addr.label.isNotEmpty
        ? '${addr.label} · ${addr.area.isNotEmpty ? addr.area : addr.cityName}، ${addr.countryName}'
        : 'المنزل · ${order.cityName}، ${order.countryName}';

    final addressDetails = addr != null && addr.line.isNotEmpty
        ? '${addr.line} · ${addr.phone}'
        : order.address;

    final deliveryInfo = del != null && del.methodLabel.isNotEmpty
        ? '${del.methodLabel} · ${del.etaLabel}'
        : '${order.deliveryMethodLabel} · خلال 48 ساعة';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'التوصيل لـ',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            addressTitle,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          if (addressDetails.isNotEmpty) ...[
            const SizedBox(height: 4.0),
            Text(
              addressDetails,
              style: const TextStyle(
                fontSize: 12.0,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 6.0),
          Text(
            deliveryInfo,
            style: const TextStyle(
              fontSize: 12.0,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsCard(BuildContext context, NumberFormat formatter) {
    final deliveryFee = order.totals?.deliveryFee ?? order.delivery?.fee ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المنتجات (${order.items.length > 0 ? order.items.length : order.itemsCount})',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 12.0),

          // Items List
          if (order.items.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12.0),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Row(
                  children: [
                    // Product Image Thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: item.productImage != null && item.productImage!.isNotEmpty
                          ? Image.network(
                              item.productImage!,
                              width: 44.0,
                              height: 44.0,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildItemPlaceholder(),
                            )
                          : _buildItemPlaceholder(),
                    ),
                    const SizedBox(width: 12.0),

                    // Details Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neutral900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            item.variantLabel.isNotEmpty
                                ? '${item.variantLabel} × ${item.quantity}'
                                : '${item.unitName} × ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8.0),

                    // Price
                    Text(
                      '${formatter.format(item.lineTotal)} ل.س',
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                );
              },
            ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          // Subtotals & Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'التوصيل',
                style: TextStyle(
                  fontSize: 13.0,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${formatter.format(deliveryFee)} ل.س',
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                '${formatter.format(order.total)} ل.س',
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemPlaceholder() {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        size: 22.0,
        color: AppColors.neutral,
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 20.0,
                  color: AppColors.neutral900,
                ),
              ),
              const Text(
                'الفاتورة',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
          const Row(
            spacing: 4.0,
            children: [
              Text(
                'بتصدر بعد التسليم',
                style: TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18.0,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 10.0,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  size: 20.0,
                  color: AppColors.neutral900,
                ),
              ),
              const Text(
                'مساعدة بهالطلب',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.chevron_right_rounded,
            size: 20.0,
            color: AppColors.neutral900,
          ),
        ],
      ),
    );
  }

  List<OrderTrackingStageEntity> _getTrackingStages(OrderTrackingEntity? tracking) {
    if (tracking != null && tracking.stages.isNotEmpty) {
      return tracking.stages;
    }

    final currentStep = tracking?.step ?? 1;

    return [
      OrderTrackingStageEntity(
        key: 'received',
        step: 1,
        title: 'استلمنا طلبك',
        description: 'تأكدنا من طلبك',
        isReached: currentStep >= 1,
        isCurrent: currentStep == 1,
      ),
      OrderTrackingStageEntity(
        key: 'preparing',
        step: 2,
        title: 'عم نجهزو',
        description: 'نجهّز منتجاتك',
        isReached: currentStep >= 2,
        isCurrent: currentStep == 2,
      ),
      OrderTrackingStageEntity(
        key: 'with_courier',
        step: 3,
        title: 'مع المندوب',
        description: 'في الطريق إليك',
        isReached: currentStep >= 3,
        isCurrent: currentStep == 3,
      ),
      OrderTrackingStageEntity(
        key: 'delivered',
        step: 4,
        title: 'وصل لسا',
        description: 'تم التسليم',
        isReached: currentStep >= 4,
        isCurrent: currentStep == 4,
      ),
    ];
  }

  IconData _getStageIcon(String key) {
    switch (key.toLowerCase()) {
      case 'received':
        return Icons.inventory_2_outlined;
      case 'preparing':
      case 'processing':
        return Icons.soup_kitchen_outlined;
      case 'with_courier':
      case 'out_for_delivery':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'اليوم';
    try {
      final dt = DateTime.parse(dateStr).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final itemDate = DateTime(dt.year, dt.month, dt.day);

      final timeStr = DateFormat('h:mm a').format(dt).replaceAll('AM', 'ص').replaceAll('PM', 'م');

      if (itemDate == today) {
        return 'اليوم $timeStr';
      } else if (itemDate == yesterday) {
        return 'أمس $timeStr';
      } else {
        return '${DateFormat('yyyy/MM/dd').format(dt)} $timeStr';
      }
    } catch (_) {
      return 'اليوم';
    }
  }
}
