import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';

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
    return Container(
      height: MediaQuery.of(context).padding.top + 60.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0.0, 5.0),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.0,
        right: 16.0,
      ),
      child: Row(
        spacing: 12.0,
        children: [
          GestureDetector(
            onTap: onBackPressed ??
                    () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
            child: SvgPicture.asset(
              'assets/icons/back_button_2.svg',
              width: 40,
              height: 40,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إتمام الطلب',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 2.0),
              Text(
                '$currentStep من $totalSteps · $stepTitle',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.neutral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
