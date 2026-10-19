import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';

class EmptyAddressesWidget extends StatelessWidget {
  final VoidCallback? onAddAddressPressed;

  const EmptyAddressesWidget({
    super.key,
    this.onAddAddressPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            AppAssets.noAddresses,
            width: 220.0,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32.0),
          const Text(
            'ما في عناوين مضافة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          const Text(
            'أضف عنوانك لحتى تصلك طلباتك بسرعة وسهولة.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (onAddAddressPressed != null) ...[
            CustomButton(
              text: 'ضيف عنوان جديد',
              height: 52.0,
              onPressed: onAddAddressPressed,
            ),
          ],
        ],
      ),
    );
  }
}
