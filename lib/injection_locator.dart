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
import 'package:spenza/features/addresses/data/datasources/addresses_datasource.dart';
import 'package:spenza/features/addresses/data/repositories/addresses_repository_impl.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';
import 'package:spenza/features/addresses/domain/usecases/add_address_use_case.dart';
import 'package:spenza/features/addresses/domain/usecases/get_addresses_use_case.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/orders/data/datasources/orders_datasource.dart';
import 'package:spenza/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';
import 'package:spenza/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
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
import 'package:spenza/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:spenza/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:spenza/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:spenza/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:spenza/features/onboarding/domain/usecases/set_onboarding_status_usecase.dart';
import 'package:spenza/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:spenza/features/auth/data/datasource/auth_datasource.dart';
import 'package:spenza/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spenza/features/auth/domain/repositories/auth_repository.dart';
import 'package:spenza/features/auth/domain/usecases/register_usecase.dart';
import 'package:spenza/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:spenza/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:spenza/features/account/data/datasource/account_datasource.dart';
import 'package:spenza/features/account/data/repositories/account_repository_impl.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';
import 'package:spenza/features/account/domain/usecases/get_user_profile_use_case.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_bloc.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/favorites/data/datasource/favorites_local_datasource.dart';
import 'package:spenza/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:spenza/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:spenza/features/favorites/domain/usecases/get_favorites_use_case.dart';
import 'package:spenza/features/favorites/domain/usecases/toggle_favorite_use_case.dart';
import 'package:spenza/features/favorites/presentation/blocs/favorites_bloc/favorites_bloc.dart';
import 'package:spenza/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:spenza/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';
import 'package:spenza/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/update_cart_quantity_use_case.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/points_market/data/datasource/points_market_datasource.dart';
import 'package:spenza/features/points_market/data/repositories/points_market_repository_impl.dart';
import 'package:spenza/features/points_market/domain/repositories/points_market_repository.dart';
import 'package:spenza/features/points_market/domain/usecases/get_user_points_use_case.dart';
import 'package:spenza/features/points_market/presentation/blocs/points_market_bloc/points_market_bloc.dart';
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
    networkInfo: sl(),
  ));
  sl.registerSingletonAsync<CacheHelper>(() async {
    final cacheHelper = CacheHelper();
    await cacheHelper.init();
    return cacheHelper;
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
  sl.registerFactory(() => OnboardingBloc(
        getOnboardingStatusUseCase: sl(),
        setOnboardingStatusUseCase: sl(),
      ));

  // Use-cases
  sl.registerLazySingleton(() => GetThemeUseCase(themeRepository: sl()));
  sl.registerLazySingleton(() => SaveThemeUseCase(themeRepository: sl()));
  sl.registerLazySingleton(() => GetOnboardingStatusUseCase(repository: sl()));
  sl.registerLazySingleton(() => SetOnboardingStatusUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepositoryImpl(themeLocalDatasource: sl()));
  sl.registerLazySingleton<LanguageRepository>(() => LanguageRepositoryImpl());
  sl.registerLazySingleton<OnboardingRepository>(() => OnboardingRepositoryImpl(localDataSource: sl()));

  // Datasource
  sl.registerLazySingleton<OnboardingLocalDataSource>(() => OnboardingLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<ThemeLocalDatasource>(() => ThemeLocalDatasource(cacheHelper: sl()));
  sl.registerFactory(() => HomeBloc(getHomeDataUseCase: sl()));
  sl.registerLazySingleton(() => GetHomeDataUseCase(homeRepository: sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(homeDatasource: sl()));
  sl.registerLazySingleton(() => HomeDatasource(api: sl(), cacheHelper: sl()));

  // Categories Feature
  sl.registerFactory(() => CategoriesBloc(getCategoriesUseCase: sl()));
  sl.registerFactory(() => CategoryProductsBloc(
        getCategoryProductsUseCase: sl(),
        searchProductsUseCase: sl(),
      ));
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

  // Favorites Feature
  sl.registerFactory(() => FavoritesBloc(
        getFavoritesUseCase: sl(),
        toggleFavoriteUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(repository: sl()));
  sl.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<FavoritesLocalDataSource>(() => FavoritesLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerFactory(() => BrandProductsBloc(
        getBrandProductsUseCase: sl(),
        searchProductsUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetBrandProductsUseCase(repository: sl()));

  // Auth Feature
  sl.registerLazySingleton(() => AuthStatusBloc(cacheHelper: sl()));
  sl.registerFactory(() => AuthBloc(
        requestOtpUseCase: sl(),
        verifyOtpUseCase: sl(),
        registerUseCase: sl(),
        cacheHelper: sl(),
        authStatusBloc: sl(),
      ));
  sl.registerLazySingleton(() => RequestOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => AuthDatasource(api: sl()));

  // Account Feature
  sl.registerFactory(() => AccountBloc(getUserProfileUseCase: sl()));
  sl.registerLazySingleton(() => GetUserProfileUseCase(repository: sl()));
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => AccountDatasource(api: sl()));

  // Addresses Feature
  sl.registerFactory(() => AddressesBloc(
        getAddressesUseCase: sl(),
        addAddressUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetAddressesUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddAddressUseCase(repository: sl()));
  sl.registerLazySingleton<AddressesRepository>(() => AddressesRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton<AddressesDatasource>(() => AddressesDatasourceImpl(api: sl()));

  // Points Market Feature
  sl.registerFactory(() => PointsMarketBloc(getUserPointsUseCase: sl()));
  sl.registerLazySingleton(() => GetUserPointsUseCase(repository: sl()));
  sl.registerLazySingleton<PointsMarketRepository>(() => PointsMarketRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton(() => PointsMarketDatasource(api: sl()));

  // Orders Feature
  sl.registerFactory(() => OrdersBloc(createOrderUseCase: sl()));
  sl.registerLazySingleton(() => CreateOrderUseCase(repository: sl()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(datasource: sl()));
  sl.registerLazySingleton<OrdersDatasource>(() => OrdersDatasourceImpl(api: sl()));

  // Cart Feature
  sl.registerFactory(() => CartBloc(
        getCartUseCase: sl(),
        addToCartUseCase: sl(),
        updateCartQuantityUseCase: sl(),
        removeFromCartUseCase: sl(),
        clearCartUseCase: sl(),
      ));
  sl.registerLazySingleton(() => GetCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(repository: sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(repository: sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(localDataSource: sl()));
  sl.registerLazySingleton<CartLocalDataSource>(() => CartLocalDataSourceImpl(sharedPreferences: sl()));

  // Datasource
  //sl.registerLazySingleton<ThemeLocalDatasource>(() => ThemeLocalDatasource(cacheHelper: sl()));

  // Ensure all async registrations are complete
  await sl.allReady();

}
