import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

class SelectionOption<T> {
  final T id;
  final String title;
  final String subtitle;
  final String iconPath;

  const SelectionOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconPath,
  });
}

class SelectionBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<SelectionOption<T>> options;
  final T selectedValue;
  final ValueChanged<T>? onOptionSelected;

  const SelectionBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF9F6F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top Drag Handle
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 16.0),

          // Title Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  size: 24.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 24.0),
            ],
          ),
          const SizedBox(height: 24.0),

          // Options List
          for (int i = 0; i < options.length; i++) ...[
            _SelectionOptionCard<T>(
              option: options[i],
              isSelected: options[i].id == selectedValue,
              onTap: () {
                onOptionSelected?.call(options[i].id);
              },
            ),
            if (i < options.length - 1) const SizedBox(height: 12.0),
          ],
        ],
      ),
    );
  }
}

class _SelectionOptionCard<T> extends StatelessWidget {
  final SelectionOption<T> option;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionOptionCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFDE8E8) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(color: const Color(0xFFC74436), width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            // Radio Button Dot
            Container(
              width: 22.0,
              height: 22.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFC74436) : Colors.grey[300]!,
                  width: 2.0,
                ),
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC74436),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),

            // Icon Container
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : AppColors.neutral200.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                option.iconPath,
                colorFilter: .mode(
                  isSelected ? const Color(0xFFC74436) : AppColors.neutral700,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 14.0),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    option.subtitle,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
