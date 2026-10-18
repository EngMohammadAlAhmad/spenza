import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
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

    return Column(
      children: [
        // Red Curved Header (Fixed)
        OrderDetailsHeader(order: order),

        // Cards Content (Scrollable)
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
              child: Column(
                spacing: 14.0,
                children: [
                  // 1. Stepper Card
                  OrderDetailsStepperCard(tracking: order.tracking),

                  // 2. Payment Card
                  OrderDetailsPaymentCard(
                    order: order,
                    formatter: formatter,
                  ),

                  // 3. Delivery Address Card
                  OrderDetailsDeliveryCard(order: order),

                  // 4. Products & Totals Card
                  OrderDetailsProductsCard(
                    order: order,
                    formatter: formatter,
                  ),

                  // 5. Invoice Card
                  const OrderDetailsInvoiceCard(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
