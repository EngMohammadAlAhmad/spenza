import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:spenza/core/connection/network_info.dart';
import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/dio_consumer.dart';
import 'package:spenza/core/databases/api/language_interpretation.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/services/crash_reporter.dart';
import 'package:spenza/core/services/firebase_crash_reporter.dart';
import 'package:spenza/features/language/data/repositories/language_repo_impl.dart';
import 'package:spenza/features/language/domain/repositories/language_repository.dart';
import 'package:spenza/features/language/presentation/blocs/language_bloc.dart';
import 'package:spenza/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:spenza/features/theme/data/repositories/theme_repo_impl.dart';
import 'package:spenza/features/theme/domain/repositories/theme_repository.dart';
import 'package:spenza/features/theme/domain/usecases/get_theme_usecase.dart';
import 'package:spenza/features/theme/domain/usecases/save_theme_usecase.dart';
import 'package:spenza/features/theme/presentation/blocs/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> init() async {
  //! External
  final dio = Dio();
  sl.registerLazySingleton(() => dio);


  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<LanguageInterceptor>(() => LanguageInterceptor());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(
    dio: sl(),
    languageInterceptor: sl(),
    cacheHelper: sl(),
    navigatorKey: navigatorKey,
  ));
  sl.registerSingletonAsync<CacheHelper>(() {
    final cacheHelper = CacheHelper();
    cacheHelper.init();
    return Future.value(cacheHelper);
  });
  sl.registerLazySingleton<CrashReporter>(() => FirebaseCrashReporter());

  //! External

  //final sharedPreferences = await SharedPreferences.getInstance();
  //sl.registerLazySingleton(() => sharedPreferences);
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  sl.registerLazySingleton(() => InternetConnection());


  //! Features - (Feature name)

  // Bloc
  sl.registerFactory(() => ThemeBloc(getThemeUseCase: sl(), saveThemeUseCase: sl()));
  sl.registerFactory(() => LanguageBloc());

  // Use-cases
  sl.registerLazySingleton(() => GetThemeUseCase(themeRepository: sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(themeRepository: sl()));

  // Repository
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(themeLocalDatasource: sl()));
  sl.registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl());

  // Datasource
  sl.registerLazySingleton<ThemeLocalDatasource>(() => ThemeLocalDatasource(cacheHelper: sl()));

  // Ensure all async registrations are complete
  await sl.allReady();

}
