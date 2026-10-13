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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
          child: CustomButton(
            text: 'كمل للتوصيل والدفع',
            onPressed: isEnabled ? onNextPressed : null,
          ),
        ),
      ),
    );
  }
}
