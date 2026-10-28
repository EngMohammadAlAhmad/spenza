import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class CheckoutBottomBar extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onNextPressed;

  const CheckoutBottomBar({
    super.key,
    required this.isEnabled,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
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
          child: Hero(
            tag: 'checkout_bottom_button_hero',
            child: Material(
              color: Colors.transparent,
              child: CustomButton(
                text: 'continue_delivery_and_payment'.tr(),
                height: 52.0,
                onPressed: isEnabled ? onNextPressed : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
