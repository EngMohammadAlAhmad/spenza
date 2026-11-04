import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFiltered;
  final bool onlyIcon;

  const FilterButton({
    super.key,
    required this.onTap,
    this.isFiltered = false,
    this.onlyIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onlyIcon) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(13.0),
          decoration: BoxDecoration(
            color: isFiltered ? AppColors.primary : AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.tune,
            size: 25.0,
            color: isFiltered ? Colors.white : AppColors.primary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: isFiltered ? AppColors.primary : Colors.white,
          borderRadius: AppRadius.extraLarge,
          border: Border.all(
            color: isFiltered ? AppColors.primary : AppColors.neutralBorderStrong,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune,
              size: 20.0,
              color: isFiltered ? Colors.white : AppColors.neutral900,
            ),
            const SizedBox(width: 6.0),
            Text(
              'filter'.tr(),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: isFiltered ? Colors.white : AppColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
