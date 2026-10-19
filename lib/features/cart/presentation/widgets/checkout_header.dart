import 'package:flutter/material.dart';
import 'package:spenza/core/widgets/app_header.dart';

class CheckoutHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final VoidCallback? onBackPressed;

  const CheckoutHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    required this.stepTitle,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: 'إتمام الطلب',
      subtitle: '$currentStep من $totalSteps · $stepTitle',
      onBackPressed: onBackPressed,
      style: AppHeaderStyle.light,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28.0)),
    );
  }
}
