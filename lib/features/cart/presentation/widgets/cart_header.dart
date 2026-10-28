import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/widgets/app_header.dart';

class CartHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const CartHeader({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: 'shopping_cart'.tr(),
      onBackPressed: onBackPressed ??
          () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.home);
            }
          },
      style: AppHeaderStyle.light,
    );
  }
}
