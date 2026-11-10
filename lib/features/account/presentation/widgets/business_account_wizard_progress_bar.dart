import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';

class BusinessAccountWizardProgressBar extends StatelessWidget {
  final int currentStep;

  const BusinessAccountWizardProgressBar({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          // Step 1 Segment
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              height: 6.0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
          const SizedBox(width: 10.0),
          // Step 2 Segment
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              height: 6.0,
              decoration: BoxDecoration(
                color: currentStep == 2
                    ? AppColors.primary
                    : AppColors.neutralBorderStrong,
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
