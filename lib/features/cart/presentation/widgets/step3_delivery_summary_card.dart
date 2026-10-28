import 'package:easy_localization/easy_localization.dart';
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
    final title = address != null ? address!.fullTitle : '';
    final details = address != null && address!.fullAddressLine.isNotEmpty
        ? '${address!.fullAddressLine} • ${address!.formattedPhone}'
        : '';
    final isExpress = deliveryType == 'express';
    final deliveryText = isExpress
        ? 'express_delivery_desc'.tr()
        : 'standard_delivery_desc'.tr();

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
                  Text(
                    'delivery_title'.tr(),
                    style: const TextStyle(
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
                      colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      'edit'.tr(),
                      style: const TextStyle(
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
          if (title.isNotEmpty)
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
          if (details.isNotEmpty)
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
                deliveryFee == 0 ? 'free'.tr() : '$deliveryFee ${'sp_currency'.tr()}',
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
