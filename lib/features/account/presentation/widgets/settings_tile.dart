import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showChevron;

  const SettingsTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.value,
    this.trailing,
    this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: Row(
            children: [
              // 1. Icon Container (First on the right in RTL)
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AppColors.neutralBackground,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(iconPath, width: 20.0, height: 20.0),
              ),
              const SizedBox(width: 12.0),

              // 2. Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const Spacer(),

              // 3. Subtitle / Value text
              if (value != null) ...[
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                if (showChevron || trailing != null) const SizedBox(width: 6.0),
              ],

              // 4. Trailing widget or Chevron (Far left in RTL)
              if (trailing != null)
                trailing!
              else if (showChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.neutral,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
