import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/step3_delivery_summary_card.dart';
import 'package:spenza/features/cart/presentation/widgets/step3_items_summary_card.dart';
import 'package:spenza/features/cart/presentation/widgets/step3_payment_summary_card.dart';

class Step3ReviewAndConfirmView extends StatefulWidget {
  final AddressEntity? selectedAddress;
  final String selectedDeliveryType; // 'standard', 'express'
  final String selectedPaymentMethod; // 'cash', 'bank', 'paymera'
  final VoidCallback onEditDeliveryStepPressed;
  final VoidCallback onEditPaymentStepPressed;
  final VoidCallback onEditCartPressed;
  final ValueChanged<String>? onDriverNoteChanged;

  const Step3ReviewAndConfirmView({
    super.key,
    this.selectedAddress,
    required this.selectedDeliveryType,
    required this.selectedPaymentMethod,
    required this.onEditDeliveryStepPressed,
    required this.onEditPaymentStepPressed,
    required this.onEditCartPressed,
    this.onDriverNoteChanged,
  });

  @override
  State<Step3ReviewAndConfirmView> createState() =>
      _Step3ReviewAndConfirmViewState();
}

class _Step3ReviewAndConfirmViewState
    extends State<Step3ReviewAndConfirmView> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _driverNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _driverNoteController.addListener(() {
      widget.onDriverNoteChanged?.call(_driverNoteController.text);
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    _driverNoteController.dispose();
    super.dispose();
  }

  num get deliveryFee => widget.selectedDeliveryType == 'express' ? 10000 : 5000;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final cartState = context.watch<CartBloc>().state;
    final totalItemsCount = cartState.totalItemsCount;
    final totalCartPrice = cartState.totalCartPrice;
    final isTabletLandscape = context.isTabletLandscape;

    Widget buildFirstColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Delivery Summary
          Step3DeliverySummaryCard(
            address: widget.selectedAddress,
            deliveryType: widget.selectedDeliveryType,
            deliveryFee: deliveryFee,
            onEditPressed: widget.onEditDeliveryStepPressed,
          ),
          const SizedBox(height: 12.0),

          // 2. Payment Summary
          Step3PaymentSummaryCard(
            paymentMethod: widget.selectedPaymentMethod,
            onEditPressed: widget.onEditPaymentStepPressed,
          ),
          const SizedBox(height: 12.0),

          // 3. Items Summary
          Step3ItemsSummaryCard(
            items: cartState.items,
            onEditCartPressed: widget.onEditCartPressed,
          ),
        ],
      );
    }

    Widget buildSecondColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4. Coupon Code Input Row
          Row(
            children: [
              // Coupon Input
              Expanded(
                child: CustomTextField(
                  controller: _couponController,
                  hintText: 'write_discount_code'.tr(),
                  fillColor: Colors.white,
                  height: 52.0,
                ),
              ),
              const SizedBox(width: 10.0),

              // Apply Button using App CustomButton
              CustomButton(
                text: 'apply'.tr(),
                height: 52.0,
                width: 80.0,
                isOutlined: true,
                underlayerColor: AppColors.primaryTint,
                onPressed: () {
                  // Apply coupon logic
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // 5. Driver Note Field
          Text(
            'driver_note_optional'.tr(),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral900,
            ),
          ),
          const SizedBox(height: 8.0),
          CustomTextField(
            controller: _driverNoteController,
            hintText: 'driver_note_example'.tr(),
            fillColor: Colors.white,
          ),
          const SizedBox(height: 16.0),

          // 6. Price Summary Box
          Container(
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
              children: [
                // Products Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'products_count_title'.tr(args: ['$totalItemsCount']),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.neutral900,
                      ),
                    ),
                    Text(
                      '${formatter.format(totalCartPrice)} ${'sp_currency'.tr()}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Delivery Fee
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.selectedDeliveryType == 'express'
                          ? 'express_delivery_title'.tr()
                          : 'standard_delivery_title'.tr(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.neutral900,
                      ),
                    ),
                    Text(
                      '${formatter.format(deliveryFee)} ${'sp_currency'.tr()}',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // Points Notice
                Row(
                  spacing: 5.0,
                  children: [
                    Text(
                      'earn_points_notice'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.warningAlert,
                          ),
                    ),
                    SvgPicture.asset(
                      AppAssets.iconSmall,
                      width: 20.0,
                      height: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // 7. Terms & Conditions Notice
          Center(
            child: Text(
              'agree_terms_confirm_order'.tr(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.tertiary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    Widget bodyContent;

    if (isTabletLandscape) {
      bodyContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Child: Delivery Summary + Payment Summary + Items Summary
          Expanded(
            flex: 1,
            child: buildFirstColumn(),
          ),
          const SizedBox(width: 20.0),

          // Second Child: Coupon Code Input + Driver Note + Price Summary + Terms Notice
          Expanded(
            flex: 1,
            child: buildSecondColumn(),
          ),
        ],
      );
    } else {
      bodyContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFirstColumn(),
          const SizedBox(height: 16.0),
          buildSecondColumn(),
          const SizedBox(height: 20.0),
        ],
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
      child: bodyContent,
    );
  }
}
