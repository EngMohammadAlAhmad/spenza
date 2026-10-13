import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_event.dart';
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
        BlocProvider<FavoritesBloc>(
          create: (context) => di.sl<FavoritesBloc>()..add(GetFavoritesEvent()),
        ),
        BlocProvider<AuthStatusBloc>(
          create: (context) => di.sl<AuthStatusBloc>(),
        ),
        BlocProvider<PointsMarketBloc>(
          create: (context) => di.sl<PointsMarketBloc>()..add(const GetMyPointsEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => di.sl<CartBloc>()..add(const GetCartEvent()),
        ),
      ],
      child: child,
    );
  }
}
