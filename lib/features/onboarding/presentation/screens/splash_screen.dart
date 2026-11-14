import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/app_size.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:spenza/injection_locator.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _markKey = GlobalKey();
  final GlobalKey _underlineKey = GlobalKey();

  Rect? _markRect;
  Rect? _underlineRect;

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Wait for 2 seconds as requested by the user
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final cacheHelper = di.sl<CacheHelper>();
    final getOnboardingStatus = di.sl<GetOnboardingStatusUseCase>();

    final bool isLoggedIn = cacheHelper.getAuthToken().isNotEmpty;
    final bool wasOnboardingSeen = await getOnboardingStatus();

    if (!wasOnboardingSeen) {
      context.go(RoutePaths.onboarding);
    } else if (isLoggedIn) {
      context.go(RoutePaths.home);
    } else {
      context.go(RoutePaths.login);
    }
  }

  void _measureAnchors() {
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.attached) return;

    final markCtx = _markKey.currentContext;
    if (markCtx != null) {
      final box = markCtx.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
      final rect = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
      if (_markRect != rect) {
        setState(() => _markRect = rect);
      }
    }

    final underlineCtx = _underlineKey.currentContext;
    if (underlineCtx != null) {
      final box = underlineCtx.findRenderObject() as RenderBox;
      final offset = box.localToGlobal(Offset.zero, ancestor: stackBox);
      final rect = Rect.fromLTWH(offset.dx, offset.dy, box.size.width, box.size.height);
      if (_underlineRect != rect) {
        setState(() => _underlineRect = rect);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTabletLandscape = context.isTabletLandscape;
    final isTabletPortrait = context.isTabletPortrait;
    final isTablet = context.isTablet || isTabletLandscape || isTabletPortrait;

    // Determine background asset based on device type and orientation
    final String bgAsset = isTabletLandscape
        ? AppAssets.splashScreenTabletLandscape
        : (isTabletPortrait
            ? AppAssets.splashScreenTabletPortrait
            : AppAssets.splashScreen);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _measureAnchors();
    });

    final double fontSize = 18.0;

    /*final double logoHeight = isTabletLandscape
        ? 150.0
        : (isTabletPortrait ? 130.0 : 95.0);*/

    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF383839),
        ) ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF383839),
        );

    final isRtl = context.locale.languageCode == 'ar';

    return Scaffold(
      body: Stack(
        key: _stackKey,
        fit: StackFit.expand,
        children: [
          // Background Image covering the screen
          Image.asset(
            bgAsset,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Vector 2 (sparkle / mark) placed near the mark word
          if (_markRect != null)
            Positioned(
              right: isRtl
                  ? _markRect!.right - (isTablet ? context.width * 0.008 : context.width * 0.025)
                  : _markRect!.left - (isTablet ? 16.0 : 12.0),
              top: _markRect!.top - 14.0,
              width: 20.0,
              height: 20.0,
              child: RotatedBox(
                quarterTurns: context.locale.languageCode == 'ar' ? 2 : 3,
                child: Image.asset(
                  AppAssets.vector2,
                ),
              ),
            ),

          // Vector 1 (underline) placed under the highlight word ("أقرب" / "closer")
          if (_underlineRect != null)
            Positioned(
              left: _underlineRect!.left - (_underlineRect!.width * 0.08),
              top: _underlineRect!.bottom - (isTablet ? -8.0 : -5.0),
              width: _underlineRect!.width,
              child: Image.asset(
                AppAssets.vector1,
                fit: BoxFit.contain,
              ),
            ),

          // Center content: Vertical Logo (Icon + SPENZA) and Slogan
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Vertical Logo
                  SvgPicture.asset(
                    AppAssets.logoIcon,
                    width: 185.0,
                    height: 145.0,
                  ),

                  SizedBox(height: 30.0),

                  // Localized Slogan with Vector 1 and Vector 2 anchors
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'splash_slogan_mark_word'.tr(),
                        key: _markKey,
                        style: textStyle,
                      ),
                      Text(
                        'splash_slogan_part1_rest'.tr(),
                        style: textStyle,
                      ),
                      Text(
                        'splash_slogan_highlight_word'.tr(),
                        key: _underlineKey,
                        style: textStyle.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'splash_slogan_part2_rest'.tr(),
                        style: textStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
