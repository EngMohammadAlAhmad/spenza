import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spenza/features/theme/presentation/blocs/theme_bloc.dart';
import 'package:spenza/injection_locator.dart' as di;
import 'package:flutter/material.dart';

/// This widget wraps [child] with all the global app BlocProviders.
class AppBlocProviders extends StatelessWidget {
  final Widget child;

  const AppBlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => di.sl<ThemeBloc>()..add(GetThemeEvent()),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => di.sl<LanguageBloc>(),
        ),
        BlocProvider<OnboardingBloc>(
          create: (context) => di.sl<OnboardingBloc>(),
        ),
      ],
      child: child,
    );
  }
}
