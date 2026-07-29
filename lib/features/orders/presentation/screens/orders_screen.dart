import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RoutePaths.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Zain',
                    ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'طلباتك قادمة قريباً',
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 50),
                      textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Zain',
                        color: AppColors.primary,
                      ),
                    ),
                    TypewriterAnimatedText(
                      'نعمل على تجهيز هذه الصفحة',
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 50),
                      textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Zain',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText(
                      'تتبع جميع طلباتك السابقة والحالية في مكان واحد بمجرد إطلاق الميزة',
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.neutral,
                            fontFamily: 'Zain',
                          ),
                      duration: const Duration(seconds: 4),
                    ),
                  ],
                  repeatForever: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
