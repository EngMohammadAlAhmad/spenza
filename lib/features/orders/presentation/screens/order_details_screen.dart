import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_back_button.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_delivery_card.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_header.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_invoice_card.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_payment_card.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_products_card.dart';
import 'package:spenza/features/orders/presentation/widgets/order_details_stepper_card.dart';
import 'package:spenza/injection_locator.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderNumber;

  const OrderDetailsScreen({
    super.key,
    required this.orderNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>.value(
      value: sl<OrdersBloc>()..add(GetOrderDetailsEvent(orderNumber)),
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
                  leading: const Center(child: AppBackButton()),
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
                      Text(
                        'failed_to_load_order_details'.tr(),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      CustomButton(
                        text: 'retry'.tr(),
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
    final isTabletLandscape = context.isTabletLandscape;

    final stepperCard = OrderDetailsStepperCard(
      tracking: order.tracking,
      orderStatus: order.status,
      statusLabel: order.statusLabel,
      rejectionReason: order.rejectionReason,
    );

    final paymentCard = OrderDetailsPaymentCard(
      order: order,
      formatter: formatter,
    ).animate(delay: 250.ms).fadeIn(duration: 500.ms).slideY(
          begin: 0.08,
          end: 0.0,
          curve: Curves.easeOutCubic,
        );

    final deliveryCard = OrderDetailsDeliveryCard(order: order)
        .animate(delay: 380.ms)
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.08,
          end: 0.0,
          curve: Curves.easeOutCubic,
        );

    final productsCard = OrderDetailsProductsCard(
      order: order,
      formatter: formatter,
    ).animate(delay: 510.ms).fadeIn(duration: 500.ms).slideY(
          begin: 0.08,
          end: 0.0,
          curve: Curves.easeOutCubic,
        );

    final invoiceCard = OrderDetailsInvoiceCard(
      orderNumber: order.orderNumber,
      orderStatus: order.statusLabel,
    )
        .animate(delay: 640.ms)
        .fadeIn(duration: 500.ms)
        .slideY(
          begin: 0.08,
          end: 0.0,
          curve: Curves.easeOutCubic,
        );

    final Widget cardsContent;
    if (isTabletLandscape) {
      cardsContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Stepper Card -> Products & Totals Card
          Expanded(
            child: Column(
              spacing: 14.0,
              children: [
                stepperCard,
                productsCard,
              ],
            ),
          ),
          const SizedBox(width: 16.0),

          // Right Side: Payment Card -> Delivery Address Card -> Invoice Card
          Expanded(
            child: Column(
              spacing: 14.0,
              children: [
                paymentCard,
                deliveryCard,
                invoiceCard,
              ],
            ),
          ),
        ],
      );
    } else {
      cardsContent = Column(
        spacing: 14.0,
        children: [
          stepperCard,
          paymentCard,
          deliveryCard,
          productsCard,
          invoiceCard,
        ],
      );
    }

    return Column(
      children: [
        // Red Curved Header (Fixed)
        OrderDetailsHeader(order: order)
            .animate()
            .fadeIn(duration: 400.ms)
            .slideY(begin: -0.05, end: 0, curve: Curves.easeOutCubic),

        // appCards Content (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, context.height * 0.1),
              child: cardsContent,
            ),
          ),
        ),
      ],
    );
  }
}
