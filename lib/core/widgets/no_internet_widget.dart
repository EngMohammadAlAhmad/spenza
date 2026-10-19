import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AppAssets.noWifiIcon),
            const SizedBox(height: 24),
            Text(
              'النت قاطع عندك',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.neutral900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'سلتك محفوظة. أول ما يرجع النت منكمل من وين وقفت.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'جرب مرة تانية',
              isOutlined: true,
              icon: SvgPicture.asset(AppAssets.refreshIcon),
              width: 146.0,
              height: 40.0,
              underlayerColor: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
