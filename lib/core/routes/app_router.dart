import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/general_pages/error_page.dart';
import 'package:spenza/core/general_pages/home_shell.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/features/home/presentation/screens/home_screen.dart';
import 'package:spenza/features/categories/presentation/screens/categories_screen.dart';
import 'package:spenza/features/orders/presentation/screens/orders_screen.dart';
import 'package:spenza/features/account/presentation/screens/account_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
  GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RoutePaths.home,
    routes: [
      // Use .indexedStack instead of the default constructor
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return your HomeShell here, passing only the navigationShell
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
                builder: (context, state) => const CategoriesScreen(),
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