import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class SortOption {
  final String key;
  final String titleKey;
  final String iconPath;

  const SortOption({
    required this.key,
    required this.titleKey,
    required this.iconPath,
  });

  String get title => titleKey.tr();

  static const List<SortOption> defaultOptions = [
    SortOption(
      key: 'popular',
      titleKey: 'sort_popular',
      iconPath: AppAssets.trendIcon,
    ),
    SortOption(
      key: 'newest',
      titleKey: 'sort_newest',
      iconPath: AppAssets.newestIcon,
    ),
    SortOption(
      key: 'price_asc',
      titleKey: 'sort_price_low',
      iconPath: AppAssets.priceFromDownIcon,
    ),
    SortOption(
      key: 'price_desc',
      titleKey: 'sort_price_high',
      iconPath: AppAssets.priceFromTopIcon,
    ),
    SortOption(
      key: 'rating',
      titleKey: 'sort_rating',
      iconPath: AppAssets.rateIcon,
    ),
  ];
}

class SortBottomSheet extends StatelessWidget {
  final String selectedKey;
  final ValueChanged<String> onOptionSelected;
  final List<SortOption> options;

  const SortBottomSheet({
    super.key,
    required this.selectedKey,
    required this.onOptionSelected,
    this.options = SortOption.defaultOptions,
  });

  static Future<void> show({
    required BuildContext context,
    required String selectedKey,
    required ValueChanged<String> onOptionSelected,
    List<SortOption>? options,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        selectedKey: selectedKey,
        onOptionSelected: onOptionSelected,
        options: options ?? SortOption.defaultOptions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.neutralBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle Bar
              Container(
                width: 40.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.5),
                  borderRadius: AppRadius.micro,
                ),
              ),
              const SizedBox(height: 16.0),

              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'sort_by'.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 24.0,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Options Cards List
              for (int i = 0; i < options.length; i++) ...[
                _SortOptionCard(
                  option: options[i],
                  isSelected: options[i].key == selectedKey,
                  onTap: () {
                    Navigator.pop(context);
                    onOptionSelected(options[i].key);
                  },
                ),
                if (i < options.length - 1) const SizedBox(height: 12.0),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOptionCard extends StatelessWidget {
  final SortOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTint : Colors.white,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.neutralBorderDefault,
            width: isSelected ? 1.2 : 1.0,
          ),
        ),
        child: Row(
          spacing: 12.0,
          children: [
            // Radio Button Dot
            Container(
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey,
                  width: 1.8,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 12.0,
                      height: 12.0,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),

            // SVG Icon Container
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : AppColors.neutralBackground,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                option.iconPath,
                width: 20.0,
                height: 20.0,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.primary : AppColors.textBody,
                  BlendMode.srcIn,
                ),
              ),
            ),

            // Option Label Text
            Expanded(
              child: Text(
                option.title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductSortButton extends StatelessWidget {
  final String selectedKey;
  final ValueChanged<String> onSortChanged;
  final List<SortOption> options;

  const ProductSortButton({
    super.key,
    required this.selectedKey,
    required this.onSortChanged,
    this.options = SortOption.defaultOptions,
  });

  @override
  Widget build(BuildContext context) {
    final currentOption = options.firstWhere(
      (opt) => opt.key == selectedKey,
      orElse: () => options.first,
    );

    return GestureDetector(
      onTap: () {
        SortBottomSheet.show(
          context: context,
          selectedKey: selectedKey,
          onOptionSelected: onSortChanged,
          options: options,
        );
      },
      child: Container(
        width: 150.0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: AppRadius.large,
          border: Border.all(color: AppColors.fillColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.swap_vert, size: 18, color: Colors.black),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                currentOption.title,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
