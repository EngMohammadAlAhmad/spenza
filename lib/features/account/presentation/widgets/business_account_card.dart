import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';

class BusinessAccountCard extends StatelessWidget {
  final VoidCallback? onTap;

  const BusinessAccountCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FF),
        borderRadius: AppRadius.upMedium,
        border: Border.all(
          color: const Color(0xFFD6E2FB),
          width: 1.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.upMedium,
          border: .all(
            color: AppColors.blue,
            width: 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.upMedium,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                SvgPicture.asset(AppAssets.enterpriseIcon),
                const SizedBox(width: 12.0),

                // Middle: Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'بتشتري لشركة أو مؤسسة أو مكتبة؟',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        'افتح حساب أعمال واشتري بالجملة وبالكرتونة.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF4361EE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
