import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_header.dart';

class MyRewardsScreen extends StatelessWidget {
  const MyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralBackground,
      body: Column(
        children: [
          // Header
          AppHeader(
            title: 'مكافآتي',
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
        ],
      ),
    );
  }
}
