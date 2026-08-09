import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_images.dart';
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


  final List<OnboardingData> onboardingData = [
    OnboardingData(
      image: AppAssets.onboarding1,
      title: 'كل احتياجاتك، بمكان واحد',
      description: 'منتجات مختارة من تصنيفات متنوعة،\nمرتبة بوضوح حتى تلاقي احتياجك\nبسرعة وبثقة.',
    ),
    OnboardingData(
      image: AppAssets.onboarding2,
      title: 'توصيل على كيفك',
      description: 'اختار اللي بناسبك من خيارات التوصيل المتاحة بمنطقتك، ونحن منوصل\nطلبك لعندك.',
    ),
    OnboardingData(
      image: AppAssets.onboarding3,
      title: 'كل طلب بيزيد نقاطك',
      description: 'اجمع نقاط مع كل طلب، واستبدلها\nبكوبونات وخصومات ومكافآت حلوة.\n',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentIndex < onboardingData.length - 1) {
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
            Padding(
              padding: .fromLTRB(24.0, MediaQuery.sizeOf(context).height * 0.11, 24.0, 0.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        final data = onboardingData[index];
                        return Column(
                          children: [
                            Expanded(child: Image.asset(data.image)),
                            const SizedBox(height: 20.0),
                            _buildTitle(index),
                            const SizedBox(height: 12.0),
                            Text(
                              data.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: AppColors.neutral,
                                fontWeight: .normal,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const SizedBox(height: 20.0),
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: onboardingData.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 7.0,
                            dotWidth: 7.0,
                            activeDotColor: AppColors.primary,
                            dotColor: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        SizedBox(height: MediaQuery.sizeOf(context).height * 0.03),
                        if (_currentIndex < onboardingData.length - 1) ...[
                          _buildPrimaryButton(text: 'التالي',onPressed: _onNext),
                          const SizedBox(height: 10.0),
                          _buildTextButton('تخطي', _complete),
                        ] else ...[
                          _buildPrimaryButton(
                            text: 'إنشاء حساب جديد',
                            onPressed: () => context.push(RoutePaths.signup),
                            showArrow: false,
                            decreaseFont: true,
                          ),
                          const SizedBox(height: 12),
                          _buildSecondaryButton('عندي حساب — تسجيل الدخول', () {
                            context.push(RoutePaths.login);
                          }),
                          SizedBox(height: MediaQuery.sizeOf(context).height * 0.015),
                          _buildFooterText(),
                        ],
                        //SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
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
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.06,
              left: MediaQuery.sizeOf(context).width * 0.06,
              child: Text(
                '${_currentIndex + 1}/${onboardingData.length}',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(int index) {
    String firstPart = '';
    String coloredPart = '';
    String lastPart = '';

    if (index == 0) {
      firstPart = 'كل احتياجاتك، ';
      coloredPart = 'بمكان';
      lastPart = ' واحد';
    } else if (index == 1) {
      firstPart = 'توصيل على ';
      coloredPart = 'كيفك';
    } else if (index == 2) {
      firstPart = 'كل طلب بيزيد ';
      coloredPart = 'نقاطك';
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: firstPart,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: AppColors.neutral900,
            ),
          ),
          TextSpan(
            text: coloredPart,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: AppColors.primary,
            ),
          ),
          if (lastPart.isNotEmpty) TextSpan(
            text: lastPart,
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: AppColors.neutral900,
            ),
          ),
        ],
      ),
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
      textAlign: TextAlign.center,
    );
  }
  Widget _buildPrimaryButton({required String text, required VoidCallback onPressed, bool showArrow = true, bool decreaseFont = false}) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      height: 48.0,
      showArrow: showArrow,
      fontSize: decreaseFont ? 14.0 : null,
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      height: 48.0,
      isOutlined: true,
    );
  }

  Widget _buildTextButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildFooterText() {
    return Text(
      'كمل تصفّح كضيف',
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
        fontWeight: FontWeight.w700,
      ),
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
