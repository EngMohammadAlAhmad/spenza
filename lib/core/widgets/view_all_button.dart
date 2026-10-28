import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class ViewAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ViewAllButton({
    super.key,
    required this.onPressed,
    this.text = 'view_all',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.medium,
      onTap: onPressed,
      child: Row(
        spacing: 5.0,
        children: [
          Text(
            text.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary,
            size: 13.0,
          ),
        ],
      ),
    );
  }
}
