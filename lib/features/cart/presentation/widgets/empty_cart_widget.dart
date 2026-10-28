import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class EmptyCartWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showShoppingButton;
  final VoidCallback? onShoppingPressed;
  final String? buttonText;
  final String? imagePath;

  const EmptyCartWidget({
    super.key,
    this.title,
    this.subtitle,
    this.showShoppingButton = true,
    this.onShoppingPressed,
    this.buttonText,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title ?? 'empty_cart_title'.tr();
    final effectiveSubtitle = subtitle ?? 'empty_cart_subtitle'.tr();
    final effectiveAsset = imagePath ?? AppAssets.cartEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            effectiveAsset,
            width: 220,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32.0),
          Text(
            effectiveTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          if (effectiveSubtitle.isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              effectiveSubtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const Spacer(),
          if (showShoppingButton)
            CustomButton(
              text: buttonText ?? 'start_shopping'.tr(),
              height: 52.0,
              onPressed: onShoppingPressed ??
                  () {
                    context.go(RoutePaths.home);
                  },
            ),
        ],
      ),
    );
  }
}
