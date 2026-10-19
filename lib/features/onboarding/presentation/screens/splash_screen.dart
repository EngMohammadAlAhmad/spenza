import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:spenza/injection_locator.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(AppAssets.splashScreen),
      ),
    );
  }
}
