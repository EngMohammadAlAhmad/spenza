import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/app_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          AppHeader(
            title: 'الإشعارات',
            onBackPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(RoutePaths.home);
              }
            },
          ),
          const Expanded(
            child: Center(
              child: Text('لا يوجد إشعارات حالياً'),
            ),
          ),
        ],
      ),
    );
  }
}
