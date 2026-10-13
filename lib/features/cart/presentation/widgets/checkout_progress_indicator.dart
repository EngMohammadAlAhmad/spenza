import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class CheckoutProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CheckoutProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final stepNumber = index + 1;
          final isActive = stepNumber <= currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index < totalSteps - 1 ? 6.0 : 0.0,
              ),
              height: 6.0,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.neutralBorderStrong,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
