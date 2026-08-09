import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/utils/app_images.dart';

class AuthHeaderWidget extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthHeaderWidget({
    super.key,
    this.showBackButton = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 25.0,
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBack ?? () => Navigator.of(context).pop(),
              child: SvgPicture.asset(AppAssets.backButton),
            )
          else
            const SizedBox(width: 40.0),
          SvgPicture.asset(
            AppAssets.slogan,
          ),
          const SizedBox(width: 40.0),
        ],
      ),
    );
  }
}
