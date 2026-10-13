import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_option_card.dart';

class Step2DeliveryAndPaymentView extends StatelessWidget {
  final AddressEntity? selectedAddress;
  final String selectedDeliveryType; // 'standard', 'express'
  final String selectedPaymentMethod; // 'cash', 'bank', 'paymera'
  final ValueChanged<String> onDeliveryTypeChanged;
  final ValueChanged<String> onPaymentMethodChanged;

  const Step2DeliveryAndPaymentView({
    super.key,
    this.selectedAddress,
    required this.selectedDeliveryType,
    required this.selectedPaymentMethod,
    required this.onDeliveryTypeChanged,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final areaName = selectedAddress?.area.isNotEmpty == true
        ? selectedAddress!.area
        : 'المزة';
    final cityName = selectedAddress?.cityName.isNotEmpty == true
        ? selectedAddress!.cityName
        : 'دمشق';
    final locationLabel = '$areaName، $cityName';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Delivery Method Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'طريقة التوصيل',
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral900,
                ),
              ),
              Text(
                locationLabel,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Standard Delivery Option
          CheckoutOptionCard(
            title: 'توصيل عادي',
            subtitle: 'خلال 48 ساعة',
            priceText: '5,000 ل.س',
            iconPath: 'assets/icons/truck_icon.svg',
            isSelected: selectedDeliveryType == 'standard',
            isShipping: true,
            onTap: () => onDeliveryTypeChanged('standard'),
          ),
          const SizedBox(height: 12.0),

          // Express Delivery Option
          CheckoutOptionCard(
            title: 'توصيل مستعجل',
            subtitle: 'خلال ساعتين ضمن ساعات التوصيل',
            priceText: '10,000 ل.س',
            iconPath: 'assets/icons/instant_icon.svg',
            isSelected: selectedDeliveryType == 'express',
            isShipping: true,
            onTap: () => onDeliveryTypeChanged('express'),
          ),
          const SizedBox(height: 24.0),

          // 2. Payment Method Section Header
          const Text(
            'طريقة الدفع',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 12.0),

          // Cash on Delivery Option
          CheckoutOptionCard(
            title: 'كاش عند الاستلام',
            subtitle: 'بتدفع للمندوب وقت يوصلك الطلب',
            iconPath: 'assets/icons/cash_icon.svg',
            isSelected: selectedPaymentMethod == 'cash',
            onTap: () => onPaymentMethodChanged('cash'),
          ),
          const SizedBox(height: 12.0),

          // Bank Transfer Option (Disabled for now)
          CheckoutOptionCard(
            title: 'حوالة بنكية',
            subtitle: 'بتحول وبترفع صورة الوصل، ومنتأكد الدفع بعد المراجعة',
            iconPath: 'assets/icons/bank_icon.svg',
            isSelected: selectedPaymentMethod == 'bank',
            isEnabled: false,
            onTap: () => onPaymentMethodChanged('bank'),
          ),
          const SizedBox(height: 12.0),

          // Paymera / Card Option (Disabled for now)
          CheckoutOptionCard(
            title: 'بيميرا',
            subtitle: 'دفع إلكتروني مباشر',
            iconPath: 'assets/icons/card_icon.svg',
            isSelected: selectedPaymentMethod == 'paymera',
            isEnabled: false,
            onTap: () => onPaymentMethodChanged('paymera'),
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
