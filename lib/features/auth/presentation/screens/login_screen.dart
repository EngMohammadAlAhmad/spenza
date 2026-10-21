import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/pattern_background.dart';
import 'package:spenza/features/auth/presentation/widgets/auth_header.dart';
import '../widgets/login_page.dart';
import '../widgets/verify_otp_page.dart';
import '../widgets/register_complete_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _phoneController = TextEditingController();
  int _currentStep = 0;
  String _phoneNumber = '';
  String _code = '';

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep == 1) {
      _phoneController.clear();
      _phoneNumber = '';
    }
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
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.backgroundLight,
      child: Stack(
        children: [
          const PatternBackground(), // full screen, not affected by the keyboard
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                AuthHeaderWidget(
                  showBackButton: _currentStep != 0,
                  onBack: _previousStep,
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) => setState(() => _currentStep = index),
                    children: [
                      LoginPage(
                        phoneController: _phoneController,
                        onNext: (phone) {
                          setState(() => _phoneNumber = phone);
                          _nextStep();
                        },
                      ),
                      VerifyOtpPage(
                        phoneNumber: _phoneNumber,
                        onEditPhone: _previousStep,
                        onUnregistered: (code) {
                          setState(() => _code = code);
                          _nextStep();
                        },
                      ),
                      RegisterCompletePage(
                        phoneNumber: _phoneNumber,
                        code: _code,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
