import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/routes/app_router.dart';
import 'package:spenza/core/themes/app_theme.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/presentation/blocs/theme_bloc.dart';
import 'package:spenza/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProviders(
      child: BlocBuilder<ThemeBloc, BaseState<ThemeEntity>>(
        buildWhen: (previous, current) => previous.data?.themeType != current.data?.themeType,
        builder: (context, state) {
          final themeType = state.data?.themeType ?? ThemeType.light;

          return MaterialApp.router(
            title: 'Spenza Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(
              isDark: themeType == ThemeType.dark,
              locale: context.locale,
            ),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}