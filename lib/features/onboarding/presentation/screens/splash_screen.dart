import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import '../bloc/onboarding_bloc.dart';

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
    
    // Trigger the check event to decide where to go next
    context.read<OnboardingBloc>().add(CheckOnboardingStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          context.go(RoutePaths.home);
        } else if (state is OnboardingRequired) {
          context.go(RoutePaths.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use your app logo here
              Image.asset(
                'assets/images/app_icon.png',
                width: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
