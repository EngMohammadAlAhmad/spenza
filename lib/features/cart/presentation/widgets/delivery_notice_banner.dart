import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';

class DeliveryNoticeBanner extends StatelessWidget {
  final AddressEntity? selectedAddress;

  const DeliveryNoticeBanner({
    super.key,
    this.selectedAddress,
  });

  @override
  Widget build(BuildContext context) {
    final cityName = selectedAddress?.cityName.isNotEmpty == true
        ? selectedAddress!.cityName
        : 'Damascus';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: AppRadius.upMedium,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF3B82F6),
            size: 22.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'delivery_to_city'.tr(args: [cityName]),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'delivery_notice_desc'.tr(),
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: Color(0xFF3B82F6),
                    height: 1.3,
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
