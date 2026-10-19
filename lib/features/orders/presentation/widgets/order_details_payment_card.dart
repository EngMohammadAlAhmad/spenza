import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/widgets/ripple_button_wrapper.dart';

class OrderDetailsPaymentCard extends StatelessWidget {
  final OrderDetailsEntity order;
  final NumberFormat formatter;

  const OrderDetailsPaymentCard({
    super.key,
    required this.order,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final method = order.paymentMethod.toLowerCase();
    final status = order.paymentStatus.toLowerCase();
    final isBankTransfer = method.contains('bank') ||
        method.contains('transfer') ||
        method == 'bank_transfer';
    final isPending = status == 'pending' /*|| order.needsPaymentReview*/;

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
                  borderRadius: AppRadius.medium,
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
            order.paymentMethod == 'cash_on_delivery'
                ? '${order.paymentMethodLabel} · جهّز ${formatter.format(order.total)} ل.س للمندوب'
                : order.paymentMethodLabel,
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (isBankTransfer && isPending) ...[
            const SizedBox(height: 14.0),
            const Divider(height: 1, color: Color(0xFFF3F4F6)),
            const SizedBox(height: 12.0),
            RippleButtonWrapper(
              child: CustomButton(
                text: 'ارفعلنا صورة وصل الحوالة',
                isOutlined: true,
                height: 48.0,
                icon: const Icon(
                  Icons.file_upload_outlined,
                  color: AppColors.primary,
                  size: 20.0,
                ),
                onPressed: () {
                  context.push(
                    RoutePaths.bankTransferReceipt,
                    extra: {
                      'orderNumber': order.orderNumber,
                      'totalAmount': order.total,
                    },
                  ).then((uploaded) {
                    if (uploaded == true && context.mounted) {
                      context.read<OrdersBloc>().add(GetOrderDetailsEvent(order.orderNumber));
                    }
                  });
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
