import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/widgets/app_header.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: 'favorites'.tr(),
      showBackButton: false,
      style: AppHeaderStyle.light,
    );
  }
}
