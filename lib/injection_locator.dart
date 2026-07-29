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
import 'package:spenza/features/search/data/datasource/search_datasource.dart';
import 'package:spenza/features/search/data/repositories/search_repository_impl.dart';
import 'package:spenza/features/search/domain/repositories/search_repository.dart';
import 'package:spenza/features/search/domain/usecases/search_products_use_case.dart';
import 'package:spenza/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:spenza/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:spenza/features/theme/data/repositories/theme_repo_impl.dart';
import 'package:spenza/features/theme/domain/repositories/theme_repository.dart';
import 'package:spenza/features/theme/domain/usecases/get_theme_usecase.dart';
import 'package:spenza/features/theme/domain/usecases/save_theme_usecase.dart';
import 'package:spenza/features/theme/presentation/blocs/theme_bloc.dart';
import 'package:spenza/features/brands/data/datasource/brands_datasource.dart';
import 'package:spenza/features/brands/data/repositories/brands_repository_impl.dart';
import 'package:spenza/features/brands/domain/repositories/brands_repository.dart';
import 'package:spenza/features/brands/domain/usecases/get_brands_use_case.dart';
import 'package:spenza/features/brands/presentation/blocs/brands_bloc/brands_bloc.dart';
import 'package:spenza/features/brands/domain/usecases/get_brand_products_use_case.dart';
import 'package:spenza/features/brands/presentation/blocs/brand_products_bloc/brand_products_bloc.dart';
import 'package:spenza/features/categories/data/datasource/categories_datasource.dart';
import 'package:spenza/features/categories/data/repositories/categories_repository_impl.dart';
import 'package:spenza/features/categories/domain/repositories/categories_repository.dart';
import 'package:spenza/features/categories/domain/usecases/get_categories_use_case.dart';
import 'package:spenza/features/categories/presentation/blocs/categories_bloc/categories_bloc.dart';
import 'package:spenza/features/categories/domain/usecases/get_category_products_use_case.dart';
import 'package:spenza/features/categories/presentation/blocs/category_products_bloc/category_products_bloc.dart';
import 'package:spenza/features/home/data/datasource/home_datasource.dart';
import 'package:spenza/features/home/data/repositories/home_repo_impl.dart';
import 'package:spenza/features/home/domain/repositories/home_repository.dart';
import 'package:spenza/features/home/domain/usecases/get_home_data.dart';
import 'package:spenza/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:spenza/features/products/data/datasource/products_datasource.dart';
import 'package:spenza/features/products/data/repositories/product_details_repository_impl.dart';
import 'package:spenza/features/products/domain/repositories/product_details_repository.dart';
import 'package:spenza/features/products/domain/usecases/get_product_details_use_case.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';
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

  // Home Feature
  sl.registerFactory(() => HomeBloc(getHomeDataUseCase: sl()));
  sl.registerLazySingleton(() => GetHomeDataUseCase(homeRepository: sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(homeDatasource: sl()));
  sl.registerLazySingleton(() => HomeDatasource(api: sl(), cacheHelper: sl()));

  // Categories Feature
  sl.registerFactory(() => CategoriesBloc(getCategoriesUseCase: sl()));
  sl.registerFactory(() => CategoryProductsBloc(getCategoryProductsUseCase: sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryProductsUseCase(repository: sl()));
  sl.registerLazySingleton<CategoriesRepository>(() => CategoriesRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => CategoriesDatasource(api: sl()));

  // Brands Feature
  sl.registerFactory(() => BrandsBloc(getBrandsUseCase: sl()));
  sl.registerLazySingleton(() => GetBrandsUseCase(repository: sl()));
  sl.registerLazySingleton<BrandsRepository>(() => BrandsRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => BrandsDatasource(api: sl()));

  // Products Feature
  sl.registerFactory(() => ProductDetailsBloc(getProductDetailsUseCase: sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(repository: sl()));
  sl.registerLazySingleton<ProductDetailsRepository>(() => ProductDetailsRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => ProductsDatasource(api: sl()));

  // Search Feature
  sl.registerFactory(() => SearchBloc(searchProductsUseCase: sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: sl()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => SearchDatasource(api: sl()));

  sl.registerFactory(() => BrandProductsBloc(getBrandProductsUseCase: sl()));
  sl.registerLazySingleton(() => GetBrandProductsUseCase(repository: sl()));

  // Datasource
  sl.registerLazySingleton<ThemeLocalDatasource>(() => ThemeLocalDatasource(cacheHelper: sl()));

  // Ensure all async registrations are complete
  await sl.allReady();

}
