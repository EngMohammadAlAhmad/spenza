import 'package:flutter/material.dart';
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
        : 'دمشق';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(18.0),
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
                  'التوصيل لـ $cityName',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'رسوم وطرق التوصيل والدفع بتبين بالخطوة الجاية حسب العنوان.',
                  style: TextStyle(
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
