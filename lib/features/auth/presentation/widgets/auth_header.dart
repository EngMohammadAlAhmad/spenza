import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/app_header.dart';

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
    return AppHeader(
      showBackButton: showBackButton,
      onBackPressed: onBack,
      style: AppHeaderStyle.transparent,
      backButtonIcon: SvgPicture.asset(AppAssets.backButton),
      titleWidget: Center(
        child: SvgPicture.asset(AppAssets.slogan),
      ),
      trailingWidget: const SizedBox(width: 40.0),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 25.0,
        left: 20.0,
        right: 20.0,
      ),
    );
  }
}
