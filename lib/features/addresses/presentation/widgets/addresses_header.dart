import 'package:flutter/material.dart';
import 'package:spenza/core/widgets/app_header.dart';

class AddressesHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;

  const AddressesHeader({
    super.key,
    this.title = 'عناويني',
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: title,
      onBackPressed: onBackPressed,
      style: AppHeaderStyle.light,
    );
  }
}
