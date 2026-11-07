import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class CheckoutStepsBottomBar extends StatelessWidget {
  final int currentStep;
  final bool isStep1Enabled;
  final VoidCallback onStep1Pressed;
  final num totalAmount;
  final VoidCallback onStep2Pressed;
  final bool isStep3Loading;
  final VoidCallback? onStep3Pressed;

  const CheckoutStepsBottomBar({
    super.key,
    required this.currentStep,
    required this.isStep1Enabled,
    required this.onStep1Pressed,
    required this.totalAmount,
    required this.onStep2Pressed,
    this.isStep3Loading = false,
    this.onStep3Pressed,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final bool showPriceInfo = currentStep > 1;

    final String buttonText;
    final VoidCallback? buttonOnPressed;

    if (currentStep == 1) {
      buttonText = 'continue_delivery_and_payment'.tr();
      buttonOnPressed = isStep1Enabled ? onStep1Pressed : null;
    } else if (currentStep == 2) {
      buttonText = 'review_your_order'.tr();
      buttonOnPressed = onStep2Pressed;
    } else {
      buttonText = 'confirm_order_btn'.tr();
      buttonOnPressed = isStep3Loading ? null : onStep3Pressed;
    }

    return AppBottomContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Price Info Column (Animates in when step > 1 & cross-fades smoothly between step 2 and 3)
          AnimatedSize(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: showPriceInfo
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 500),
                      crossFadeState: currentStep == 2
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Column(
                        key: const ValueKey('price_step_2'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'total_with_delivery'.tr(),
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
                      secondChild: Column(
                        key: const ValueKey('price_step_3'),
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
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Single Button Container
          Expanded(
            child: currentStep == 1
                ? Hero(
                    tag: 'checkout_bottom_button_hero',
                    child: Material(
                      color: Colors.transparent,
                      child: CustomButton(
                        text: buttonText,
                        height: 52.0,
                        onPressed: buttonOnPressed,
                      ),
                    ),
                  )
                : CustomButton(
                    text: buttonText,
                    height: 52.0,
                    isLoading: currentStep == 3 && isStep3Loading,
                    onPressed: buttonOnPressed,
                  ),
          ),
        ],
      ),
    );
  }
}
