import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

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
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person_outline,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 60,
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'أهلاً بك في سبينزا',
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Zain',
                            fontSize: 36,
                          ),
                      colors: [
                        AppColors.primary,
                        AppColors.blue,
                        AppColors.secondary,
                        AppColors.primary,
                      ],
                      speed: const Duration(milliseconds: 500),
                    ),
                    ColorizeAnimatedText(
                      'إدارة حسابك قريباً',
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Zain',
                            fontSize: 36,
                          ),
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                        AppColors.blue,
                        AppColors.primary,
                      ],
                      speed: const Duration(milliseconds: 500),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),
              ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      'قريباً ستتمكن من تعديل بياناتك الشخصية، إدارة حسابك، والتحكم في إعدادات التطبيق بكل سهولة.',
                      textAlign: TextAlign.center,
                      textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.neutral,
                            fontFamily: 'Zain',
                          ),
                      speed: const Duration(milliseconds: 60),
                    ),
                  ],
                  totalRepeatCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
