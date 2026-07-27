import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/general_pages/error_page.dart';
import 'package:spenza/core/general_pages/home_shell.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/routes/animated_branch_container.dart';
import 'package:spenza/features/home/presentation/screens/home_screen.dart';
import 'package:spenza/features/orders/presentation/screens/orders_screen.dart';
import 'package:spenza/features/account/presentation/screens/account_screen.dart';
import 'package:spenza/features/shopping/presentation/screens/shopping_screen.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
  GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RoutePaths.home,
    routes: [
      // Use StatefulShellRoute instead of .indexedStack
      StatefulShellRoute(
        navigatorContainerBuilder: (context, navigationShell, children) {
          // This wraps the branch navigators in our custom animated container
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