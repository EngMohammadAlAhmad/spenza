import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/general_error_widget.dart';
import 'package:spenza/core/widgets/shimmer_placeholder.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_option_card.dart';

class Step2DeliveryAndPaymentView extends StatelessWidget {
  final AddressEntity? selectedAddress;
  final String selectedDeliveryType;
  final String selectedPaymentMethod;
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
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.checkoutOptionsStatus == RequestStatus.loading) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 12.0),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 90,
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                SizedBox(height: 12.0),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 90,
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
                SizedBox(height: 24.0),
                ShimmerPlaceholder(
                  width: double.infinity,
                  height: 90,
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ],
            ),
          );
        }

        if (state.checkoutOptionsStatus == RequestStatus.error) {
          return Center(
            child: GeneralErrorWidget(
              message: state.checkoutOptionsFailure.errMessage,
              onRetry: () {
                if (selectedAddress != null) {
                  final cityId = selectedAddress!.cityId > 0
                      ? selectedAddress!.cityId
                      : 1;
                  context
                      .read<CartBloc>()
                      .add(GetCheckoutOptionsEvent(cityId: cityId));
                }
              },
            ),
          );
        }

        final options = state.checkoutOptions;
        final deliveryOptions = options?.deliveryOptions ?? [];
        final paymentMethods = options?.paymentMethods ?? [];

        final areaName = selectedAddress?.area.isNotEmpty == true
            ? selectedAddress!.area
            : (options?.paymentZoneLabel ?? 'المزة');
        final cityName = selectedAddress?.cityName.isNotEmpty == true
            ? selectedAddress!.cityName
            : (options?.paymentZoneLabel ?? 'دمشق');
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

              // Dynamic Delivery Options List
              if (deliveryOptions.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'لا توجد خيارات توصيل متاحة لهذه المنطقة حالياً',
                    style: TextStyle(fontSize: 14.0, color: AppColors.neutral),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: deliveryOptions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12.0),
                  itemBuilder: (context, index) {
                    final opt = deliveryOptions[index];
                    final isSelected = selectedDeliveryType == opt.method;
                    final icon = opt.method == 'express'
                        ? 'assets/icons/instant_icon.svg'
                        : 'assets/icons/truck_icon.svg';

                    final subtitle = opt.isAvailable
                        ? opt.description
                        : (opt.unavailableReason ?? opt.description);

                    final priceText = opt.isFree
                        ? 'مجاني'
                        : '${opt.fee} ${options?.currency ?? 'ل.س'}';

                    return CheckoutOptionCard(
                      title: opt.methodLabel,
                      subtitle: subtitle,
                      priceText: priceText,
                      iconPath: icon,
                      isSelected: isSelected,
                      isEnabled: opt.isAvailable,
                      isShipping: true,
                      onTap: opt.isAvailable
                          ? () => onDeliveryTypeChanged(opt.method)
                          : () {},
                    );
                  },
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

              // Dynamic Payment Methods List
              if (paymentMethods.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'لا توجد وسائل دفع متاحة لهذه المنطقة حالياً',
                    style: TextStyle(fontSize: 14.0, color: AppColors.neutral),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paymentMethods.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12.0),
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    final isSelected = selectedPaymentMethod == method.key ||
                        (selectedPaymentMethod == 'cash' &&
                            method.key == 'cash_on_delivery') ||
                        (selectedPaymentMethod == 'bank' &&
                            method.key == 'bank_transfer');

                    String icon = 'assets/icons/cash_icon.svg';
                    String subtitle = 'دفع عند الاستلام';

                    if (method.key == 'bank_transfer' || method.key == 'bank') {
                      icon = 'assets/icons/bank_icon.svg';
                      subtitle =
                          'بتحول وبترفع صورة الوصل، ومنتأكد الدفع بعد المراجعة';
                    } else if (method.key == 'cash_on_delivery' ||
                        method.key == 'cash') {
                      icon = 'assets/icons/cash_icon.svg';
                      subtitle = 'بتدفع للمندوب وقت يوصلك الطلب';
                    } else {
                      icon = 'assets/icons/card_icon.svg';
                      subtitle = 'دفع إلكتروني مباشر';
                    }

                    return CheckoutOptionCard(
                      title: method.label,
                      subtitle: subtitle,
                      iconPath: icon,
                      isSelected: isSelected,
                      isEnabled: method.enabled,
                      onTap: method.enabled
                          ? () => onPaymentMethodChanged(method.key)
                          : () {},
                    );
                  },
                ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }
}
