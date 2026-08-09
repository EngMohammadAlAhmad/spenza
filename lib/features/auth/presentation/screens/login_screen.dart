import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/features/auth/presentation/widgets/auth_header.dart';
import '../widgets/login_step_1.dart';
import '../widgets/signup_step_3.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  String _phoneNumber = '';

  void _nextStep() {
    if (_currentStep < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          AuthHeaderWidget(
            showBackButton: true,
            onBack: _previousStep,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                LoginStep1(
                  onNext: (phone) {
                    setState(() => _phoneNumber = phone);
                    _nextStep();
                  },
                  onSignup: () => context.pushReplacement(RoutePaths.signup),
                ),
                SignupStep3(
                  phoneNumber: _phoneNumber,
                  onEditPhone: _previousStep,
                  onComplete: () {
                    context.go(RoutePaths.home);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
