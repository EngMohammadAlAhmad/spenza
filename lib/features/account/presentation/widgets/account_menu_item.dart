import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';

class AccountMenuItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? badgeText;
  final VoidCallback? onTap;

  const AccountMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.badgeText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
              ),
              const SizedBox(width: 14.0),

              // Title
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Optional badge text (e.g. "2 عنوان" or "2 جديد")
              if (badgeText != null) ...[
                Text(
                  badgeText!,
                  style: const TextStyle(
                    fontSize: 13.0,
                    color: AppColors.neutral,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8.0),
              ],

              // Chevron arrow
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
