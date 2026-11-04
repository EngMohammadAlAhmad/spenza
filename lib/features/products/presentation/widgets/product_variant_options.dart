import 'package:flutter/material.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';

class SelectionItem {
  final int id;
  final String label;

  const SelectionItem({required this.id, required this.label});
}

class ProductVariantOptions extends StatelessWidget {
  final List<SelectionItem> options;
  final int selectedId;
  final ValueChanged<int> onSelected;

  const ProductVariantOptions({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      direction: Axis.horizontal,
      alignment: WrapAlignment.end,
      children: options.map((opt) {
        final isSelected = opt.id == selectedId;
        return GestureDetector(
          onTap: () => onSelected(opt.id),
          child: AnimatedContainer(
            constraints: const BoxConstraints(minHeight: 40.0),
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryTint : AppColors.neutral200,
              borderRadius: AppRadius.extraLarge,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.fillColor,
                width: 2.0,
              ),
            ),
            child: Text(
              opt.label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isSelected ? AppColors.primary : null,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
