import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsDeliveryCard extends StatelessWidget {
  final OrderDetailsEntity order;

  const OrderDetailsDeliveryCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
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
}
