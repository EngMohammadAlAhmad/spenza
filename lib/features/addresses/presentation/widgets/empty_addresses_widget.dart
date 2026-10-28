import 'package:easy_localization/easy_localization.dart';
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
          Text(
            'no_addresses_yet'.tr(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'add_address_desc'.tr(),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.neutral,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          if (onAddAddressPressed != null) ...[
            CustomButton(
              text: 'add_new_address'.tr(),
              height: 52.0,
              onPressed: onAddAddressPressed,
            ),
          ],
        ],
      ),
    );
  }
}
