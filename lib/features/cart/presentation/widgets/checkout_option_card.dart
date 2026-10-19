import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class CheckoutOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? priceText;
  final String iconPath;
  final bool isSelected;
  final bool isShipping;
  final bool isEnabled;
  final VoidCallback onTap;

  const CheckoutOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.priceText,
    required this.iconPath,
    required this.isSelected,
    this.isShipping = false,
    this.isEnabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = isShipping
        ? AppColors.textBody
        : (isSelected ? AppColors.primary500 : AppColors.textBody);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: AppRadius.upMedium,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFDF2F2) : Colors.white,
              borderRadius: AppRadius.upMedium,
              border: Border.all(
                color: isSelected ? AppColors.primary500 : Colors.transparent,
                width: 1.5,
              ),
              boxShadow: [
                if (!isSelected)
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                // Radio Indicator
                Icon(
                  isSelected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: isSelected ? AppColors.primary500 : AppColors.disabledLight,
                  size: 22.0,
                ),
                const SizedBox(width: 12.0),

                // Circle Icon Box
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : AppColors.neutralBackground,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: 22.0,
                    height: 22.0,
                    colorFilter: ColorFilter.mode(
                      effectiveIconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: AppColors.neutral900,
                            ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.neutral,
                              fontSize: 12.0,
                            ),
                      ),
                    ],
                  ),
                ),

                // Price Text (Far left in RTL)
                if (priceText != null && priceText!.isNotEmpty) ...[
                  const SizedBox(width: 8.0),
                  Text(
                    priceText!,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: AppColors.neutral900,
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
