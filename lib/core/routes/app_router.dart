import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/general_pages/error_page.dart';
import 'package:spenza/core/general_pages/home_shell.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/routes/animated_branch_container.dart';
import 'package:spenza/features/brands/presentation/blocs/brand_products_bloc/brand_products_bloc.dart';
import 'package:spenza/features/brands/presentation/screens/brand_products_screen.dart';
import 'package:spenza/features/categories/presentation/blocs/category_products_bloc/category_products_bloc.dart';
import 'package:spenza/features/home/presentation/screens/home_screen.dart';
import 'package:spenza/features/orders/presentation/screens/orders_screen.dart';
import 'package:spenza/features/account/presentation/screens/account_screen.dart';
import 'package:spenza/features/shopping/presentation/screens/shopping_screen.dart';
import 'package:spenza/features/categories/presentation/screens/category_products_screen.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:spenza/features/products/presentation/screens/product_details_screen.dart';
import 'package:spenza/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:spenza/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:spenza/injection_locator.dart' as di;

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          return AnimatedBranchContainer(
            currentIndex: navigationShell.currentIndex,
            children: children,
          );
        },
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.categories,
                builder: (context, state) {
                  final tab = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
                  return ShoppingScreen(initialTab: tab);
                },
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                      return BlocProvider(
                        create: (context) => di.sl<CategoryProductsBloc>()
                          ..add(GetCategoryProductsEvent(categoryId: id, isRefresh: true)),
                        child: CategoryProductsScreen(categoryId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'brand/:brandId',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['brandId'] ?? '') ?? 0;
                      return BlocProvider(
                        create: (context) => di.sl<BrandProductsBloc>()
                          ..add(GetBrandProductsEvent(brandId: id, isRefresh: true)),
                        child: BrandProductsScreen(brandId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'product/:productId',
                    builder: (context, state) {
                      final id = int.tryParse(state.pathParameters['productId'] ?? '') ?? 0;
                      return BlocProvider(
                        create: (context) => di.sl<ProductDetailsBloc>()
                          ..add(GetProductDetailsEvent(productId: id)),
                        child: ProductDetailsScreen(productId: id),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.orders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorPage(message: state.error?.toString()),
  );
}
