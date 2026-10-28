import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/routes/app_router.dart';
import 'package:spenza/core/themes/app_theme.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/language/domain/entities/language_entity.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/presentation/blocs/theme_bloc.dart';
import 'package:spenza/providers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProviders(
      child: BlocBuilder<LanguageBloc, BaseState<LanguageEntity>>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeBloc, BaseState<ThemeEntity>>(
            buildWhen: (previous, current) => previous.data?.themeType != current.data?.themeType,
            builder: (context, themeState) {
              final themeType = themeState.data?.themeType ?? ThemeType.light;
              final currentLocale = context.locale;

              return MaterialApp.router(
                title: 'Spenza Store',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.getTheme(
                  isDark: themeType == ThemeType.dark,
                  locale: currentLocale,
                ),
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: currentLocale,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.noScaling,
                    ),
                    child: KeyedSubtree(
                      key: ValueKey('${currentLocale.languageCode}_${languageState.data?.code ?? ''}'),
                      child: child!,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}