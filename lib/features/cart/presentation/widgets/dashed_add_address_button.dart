import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_dashed_container.dart';

class DashedAddAddressButton extends StatelessWidget {
  final VoidCallback onTap;

  const DashedAddAddressButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppDashedContainer(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      borderRadius: 18.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            color: AppColors.primary500,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Text(
            'add_new_address'.tr(),
            style: const TextStyle(
              color: AppColors.primary500,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
