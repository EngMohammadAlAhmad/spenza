import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import '../bloc/onboarding_bloc.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;


  final List<String> images = [
    'assets/images/onboarding_1.png',
    'assets/images/onboarding_2.png',
    'assets/images/onboarding_3.png',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  void _complete() {
    context.read<OnboardingBloc>().add(CompleteOnboardingEvent());
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xCCF9EFDF),
      body: Material(
        color: const Color(0xCCF9EFDF),
        child: Stack(
          children: [
            // Content
            Column(
              children: [
                const SizedBox(height: 20.0),
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return Image.asset(image);
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const .symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: images.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 7.0,
                            dotWidth: 7.0,
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                        if (_currentIndex < images.length - 1) ...[
                          _buildPrimaryButton('التالي', _onNext),
                          const SizedBox(height: 10.0),
                          _buildTextButton('تخطي', _complete),
                        ] else ...[
                          _buildPrimaryButton('بلّش تسوّق كزائر', _complete),
                          const SizedBox(height: 12),
                          _buildSecondaryButton('إنشاء حساب جديد', () {
                            _complete();
                          }),
                          SizedBox(height: MediaQuery.sizeOf(context).height * 0.015),
                          _buildFooterText(),
                        ],
                        //SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: MediaQuery.sizeOf(context).width * 0.05,
              top: MediaQuery.sizeOf(context).height * 0.055,
              child: _currentIndex !=0 ? CircleActionButton(
                icon: Icons.arrow_back_ios_rounded,
                  shareButton: true,
                  withShadow: false,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  onTap: () => _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
              ) : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0.0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.extra4Large,
          ),
        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                height: 1.1, // Adjust for font baseline if necessary
              ),
            ),
            const SizedBox(width: 8.0),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48.0,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.extra4Large,
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Zain'),
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Zain',
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'عندك حساب؟ ',
          style: TextStyle(color: Color(0xFF777777), fontFamily: 'Zain'),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Navigate to Login
            _complete();
          },
          child: const Text(
            'تسجيل الدخول',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Zain',
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}
