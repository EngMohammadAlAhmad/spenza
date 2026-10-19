import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class Step3DeliverySummaryCard extends StatelessWidget {
  final AddressEntity? address;
  final String deliveryType; // 'standard', 'express'
  final num deliveryFee;
  final VoidCallback onEditPressed;

  const Step3DeliverySummaryCard({
    super.key,
    required this.address,
    required this.deliveryType,
    required this.deliveryFee,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final title = address != null ? address!.fullTitle : 'المنزل • المزة، دمشق';
    final details = address != null && address!.fullAddressLine.isNotEmpty
        ? '${address!.fullAddressLine} • ${address!.formattedPhone}'
        : 'شارع الجلاء، بناء 12، طابق 3 • 0944 123 456';
    final isExpress = deliveryType == 'express';
    final deliveryText = isExpress
        ? 'توصيل مستعجل • خلال ساعتين'
        : 'توصيل عادي • خلال 48 ساعة';

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.upMedium,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.deliveryLocationIcon,
                  ),
                  const SizedBox(width: 6.0),
                  const Text(
                    'التوصيل',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEditPressed,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.editIcon,
                      colorFilter: .mode(AppColors.primary, .srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    const Text(
                      'تعديل',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 4.0),

          // Address Details
          Text(
            details,
            style: const TextStyle(
              fontSize: 13.0,
              color: AppColors.neutral,
            ),
          ),
          const SizedBox(height: 8.0),

          // Delivery Type & Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                deliveryText,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.neutral,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                deliveryFee == 0 ? "مجاني" : "$deliveryFee ل.س",
                style: const TextStyle(
                  fontSize: 14.0,
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
}
