import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class Step3BottomBar extends StatelessWidget {
  final num totalAmount;
  final bool isLoading;
  final VoidCallback? onConfirmOrderPressed;

  const Step3BottomBar({
    super.key,
    required this.totalAmount,
    this.isLoading = false,
    this.onConfirmOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            spacing: 20.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Amount Label
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'total'.tr(),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.neutral,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${formatter.format(totalAmount)} ${'sp_currency'.tr()}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Hero(
                  tag: 'checkout_bottom_button_hero',
                  child: Material(
                    color: Colors.transparent,
                    child: CustomButton(
                      text: 'confirm_order_btn'.tr(),
                      height: 52.0,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : onConfirmOrderPressed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
