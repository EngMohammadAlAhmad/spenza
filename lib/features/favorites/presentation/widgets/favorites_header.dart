import 'package:flutter/material.dart';
import 'package:spenza/core/widgets/app_header.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      titleWidget: Center(
        child: Text(
          'المفضلة',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
        ),
      ),
      showBackButton: false,
      style: AppHeaderStyle.light,
    );
  }
}
