import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import '../bloc/onboarding_bloc.dart';

enum _VectorType { none, mark, underline }

class _WordSpec {
  final String text;
  final bool isPrimary;
  final _VectorType vector;

  const _WordSpec(this.text, this.isPrimary, this.vector);
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // ---- Overlay-animation plumbing ----------------------------------------
  final GlobalKey _stackKey = GlobalKey();
  final List<GlobalKey> _markKeys = List.generate(3, (_) => GlobalKey());
  final List<GlobalKey> _underlineKeys = List.generate(3, (_) => GlobalKey());
  final Map<int, Rect> _markRects = {};
  final Map<int, Rect> _underlineRects = {};

  static const double _popScale = 0.12;

  // ---- Per-page tuning ----------------------------------------------------
  // Each of these has one entry per page (index 0,1,2). They get lerped by
  // `t` between the current and next page, exactly like the position rects,
  // so size/offset/rotation all glide together instead of jump-cutting.

  // How far ABOVE the mark word's top edge the mark (vector2) sits.
  // Bigger number = higher up.
  final List<double> _markVerticalOffsetPerPage = [-20.0, 20.0, -20.0];

  // How far to the RIGHT the mark (vector2) is shifted from its centered position.
  final List<double> _markHorizontalOffsetPerPage = [30.0, -40.0, 30.0];

  // Width multiplier for the mark relative to the word it sits over.
  // Smaller number = smaller mark.
  final List<double> _markWidthFactorPerPage = [0.7, 0.4, 0.7];

  // Rotation (in degrees) applied to the mark on each page.
  // Page 1 -> Page 2 transition sweeps 0deg -> 180deg.
  // Page 2 -> Page 3 sweeps 180deg -> 0deg (mirrors back).
  final List<double> _markRotationDegPerPage = [0.0, 180.0, 0.0];

  // How far BELOW the underline word's bottom edge the underline (vector1)
  // sits. Smaller (or negative) number = sits lower on screen.
  final List<double> _underlineVerticalOffsetPerPage = [2.0, -6.0, 2.0];

  final List<double> _underlineWidthFactorPerPage = [0.8, 0.8, 0.8];

  final List<List<_WordSpec>> _pageWords = const [
    // Page 1: كل (mark) احتياجاتك، بمكان (underline) واحد
    [
      _WordSpec('كل', false, _VectorType.mark),
      _WordSpec(' احتياجاتك، ', false, _VectorType.none),
      _WordSpec('بمكان', true, _VectorType.underline),
      _WordSpec(' واحد', false, _VectorType.none),
    ],
    // Page 2: توصيل (underline) على كيفك (mark)
    [
      _WordSpec('توصيل', true, _VectorType.underline),
      _WordSpec(' على ', false, _VectorType.none),
      _WordSpec('كيفك', false, _VectorType.mark),
    ],
    // Page 3: كل (mark) طلب بيزيد نقاطك (underline)
    [
      _WordSpec('كل', false, _VectorType.mark),
      _WordSpec(' طلب بيزيد ', false, _VectorType.none),
      _WordSpec('نقاطك', true, _VectorType.underline),
    ],
  ];

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      image: AppAssets.onboarding1,
      title: 'كل احتياجاتك، بمكان واحد',
      description:
      'منتجات مختارة من تصنيفات متنوعة،\nمرتبة بوضوح حتى تلاقي احتياجك\nبسرعة وبثقة.',
    ),
    OnboardingData(
      image: AppAssets.onboarding2,
      title: 'توصيل على كيفك',
      description:
      'اختار اللي بناسبك من خيارات التوصيل المتاحة بمنطقتك، ونحن منوصل\nطلبك لعندك.',
    ),
    OnboardingData(
      image: AppAssets.onboarding3,
      title: 'كل طلب بيزيد نقاطك',
      description:
      'اجمع نقاط مع كل طلب، واستبدلها\nبكوبونات وخصومات ومكافآت حلوة.\n',
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

  void _measureAnchors(int index) {
    final stackBox =
    _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.attached) return;

    final markCtx = _markKeys[index].currentContext;
    if (markCtx != null) {
      final box = markCtx.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
      final rect =
      Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
      if (_markRects[index] != rect) {
        setState(() => _markRects[index] = rect);
      }
    }

    final underlineCtx = _underlineKeys[index].currentContext;
    if (underlineCtx != null) {
      final box = underlineCtx.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
      final rect =
      Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
      if (_underlineRects[index] != rect) {
        setState(() => _underlineRects[index] = rect);
      }
    }
  }

  Rect? _lerpRect(Rect? a, Rect? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b;
    if (b == null) return a;
    return Rect.lerp(a, b, t);
  }

  double _lerpD(List<double> list, int base, int next, double t) {
    return lerpDouble(list[base], list[next], t) ?? list[base];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: const Color(0xCCF9EFDF),
        child: Stack(
          key: _stackKey,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                24.0,
                MediaQuery.sizeOf(context).height * 0.11,
                24.0,
                0.0,
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentIndex = index),
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        final data = onboardingData[index];

                        WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _measureAnchors(index),
                        );

                        return Column(
                          children: [
                            Expanded(child: Image.asset(data.image)),
                            const SizedBox(height: 20.0),
                            _buildTitle(index),
                            const SizedBox(height: 20.0),
                            Text(
                              data.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                color: AppColors.neutral,
                                fontWeight: FontWeight.normal,
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
                          _buildPrimaryButton(text: 'التالي', onPressed: _onNext),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),

            IgnorePointer(
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, _) {
                  double page = _currentIndex.toDouble();
                  if (_pageController.hasClients &&
                      _pageController.position.haveDimensions) {
                    page = _pageController.page ?? _currentIndex.toDouble();
                  }

                  final base = page.floor().clamp(0, onboardingData.length - 1);
                  final next = (base + 1).clamp(0, onboardingData.length - 1);
                  final t = (page - base).clamp(0.0, 1.0);

                  final markRect =
                  _lerpRect(_markRects[base], _markRects[next], t);
                  final underlineRect = _lerpRect(
                    _underlineRects[base],
                    _underlineRects[next],
                    t,
                  );

                  final markVerticalOffset =
                  _lerpD(_markVerticalOffsetPerPage, base, next, t);
                  final markHorizontalOffset =
                  _lerpD(_markHorizontalOffsetPerPage, base, next, t);
                  final markWidthFactor =
                  _lerpD(_markWidthFactorPerPage, base, next, t);
                  final markRotationDeg =
                  _lerpD(_markRotationDegPerPage, base, next, t);
                  final underlineVerticalOffset =
                  _lerpD(_underlineVerticalOffsetPerPage, base, next, t);
                  final underlineWidthFactor =
                  _lerpD(_underlineWidthFactorPerPage, base, next, t);

                  final pop = 1.0 + _popScale * sin(t * pi);

                  return Stack(
                    children: [
                      if (markRect != null)
                        Positioned(
                          left: markRect.left -
                              (markRect.width * (markWidthFactor - 1) / 2) +
                              markHorizontalOffset,
                          top: markRect.top - markVerticalOffset,
                          width: markRect.width * markWidthFactor,
                          child: Transform.rotate(
                            angle: markRotationDeg * pi / 180.0,
                            child: Transform.scale(
                              scale: pop,
                              child: Image.asset(
                                AppAssets.vector2,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      if (underlineRect != null)
                        Positioned(
                          left: underlineRect.left -
                              (underlineRect.width *
                                  (underlineWidthFactor - 1) /
                                  2),
                          top: underlineRect.bottom - underlineVerticalOffset,
                          width: underlineRect.width * underlineWidthFactor,
                          child: Transform.scale(
                            scale: pop,
                            child: Image.asset(
                              AppAssets.vector1,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            Positioned(
              right: MediaQuery.sizeOf(context).width * 0.05,
              top: MediaQuery.sizeOf(context).height * 0.055,
              child: _currentIndex != 0
                  ? CircleActionButton(
                icon: Icons.arrow_back_ios_rounded,
                shareButton: true,
                withShadow: false,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
              )
                  : const SizedBox(),
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
    final style = Theme.of(context).textTheme.headlineLarge!;
    final words = _pageWords[index];

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: words.map((w) {
        GlobalKey? key;
        if (w.vector == _VectorType.mark) key = _markKeys[index];
        if (w.vector == _VectorType.underline) key = _underlineKeys[index];

        return Text(
          w.text,
          key: key,
          style: style.copyWith(
            color: w.isPrimary ? AppColors.primary : AppColors.neutral900,
            fontWeight: FontWeight.bold,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onPressed,
    bool showArrow = true,
    bool decreaseFont = false,
  }) {
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