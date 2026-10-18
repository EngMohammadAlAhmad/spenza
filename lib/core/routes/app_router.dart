import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/general_pages/error_page.dart';
import 'package:spenza/core/general_pages/home_shell.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/routes/animated_branch_container.dart';
import 'package:spenza/features/auth/presentation/screens/login_screen.dart';
import 'package:spenza/features/brands/presentation/blocs/brand_products_bloc/brand_products_bloc.dart';
import 'package:spenza/features/brands/presentation/screens/brand_products_screen.dart';
import 'package:spenza/features/categories/presentation/blocs/category_products_bloc/category_products_bloc.dart';
import 'package:spenza/features/home/presentation/screens/home_screen.dart';
import 'package:spenza/features/orders/presentation/screens/orders_screen.dart';
import 'package:spenza/features/orders/presentation/screens/order_success_screen.dart';
import 'package:spenza/features/orders/presentation/screens/order_details_screen.dart';
import 'package:spenza/features/orders/presentation/screens/bank_transfer_receipt_screen.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/account/presentation/screens/account_screen.dart';
import 'package:spenza/features/account/presentation/screens/settings_screen.dart';
import 'package:spenza/features/account/presentation/screens/my_info_screen.dart';
import 'package:spenza/features/account/presentation/screens/business_account_screen.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:spenza/features/addresses/presentation/screens/add_address_screen.dart';
import 'package:spenza/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:spenza/features/cart/presentation/screens/cart_screen.dart';
import 'package:spenza/features/cart/presentation/screens/checkout_screen.dart';
import 'package:spenza/features/points_market/presentation/screens/points_market_screen.dart';
import 'package:spenza/features/points_market/presentation/screens/points_history_screen.dart';
import 'package:spenza/features/points_market/presentation/screens/my_rewards_screen.dart';
import 'package:spenza/features/sections/presentation/screens/sections_screen.dart';
import 'package:spenza/features/categories/presentation/screens/category_products_screen.dart';
import 'package:spenza/features/products/presentation/blocs/product_details_bloc/product_details_bloc.dart';
import 'package:spenza/features/products/presentation/screens/product_details_screen.dart';
import 'package:spenza/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:spenza/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:spenza/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:spenza/injection_locator.dart' as di;

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: RoutePaths.splash,
    redirect: (context, state) async {
      final cacheHelper = di.sl<CacheHelper>();
      final getOnboardingStatus = di.sl<GetOnboardingStatusUseCase>();

      final bool isLoggedIn = cacheHelper.getAuthToken().isNotEmpty;
      final bool wasOnboardingSeen = await getOnboardingStatus();

      final String location = state.matchedLocation;

      // Allow splash screen to always show its animation/timer
      if (location == RoutePaths.splash) {
        return null;
      }

      // If logged in, redirect away from onboarding and login to home
      if (isLoggedIn) {
        if (location == RoutePaths.onboarding || location == RoutePaths.login) {
          return RoutePaths.home;
        }
      } else {
        // Not logged in
        // If they haven't seen onboarding, force them there unless they are already going
        if (!wasOnboardingSeen && location != RoutePaths.onboarding) {
          return RoutePaths.onboarding;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.pointsMarket,
        builder: (context, state) => const PointsMarketScreen(),
      ),
      GoRoute(
        path: RoutePaths.pointsHistory,
        builder: (context, state) => const PointsHistoryScreen(),
      ),
      GoRoute(
        path: RoutePaths.myRewards,
        builder: (context, state) => const MyRewardsScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.myInfo,
        builder: (context, state) {
          final user = state.extra as UserEntity?;
          return MyInfoScreen(user: user);
        },
      ),
      GoRoute(
        path: RoutePaths.businessAccount,
        builder: (context, state) => const BusinessAccountScreen(),
      ),
      GoRoute(
        path: RoutePaths.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RoutePaths.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: RoutePaths.addresses,
        builder: (context, state) => const AddressesScreen(),
      ),
      GoRoute(
        path: RoutePaths.addAddress,
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: RoutePaths.orderSuccess,
        builder: (context, state) {
          final order = state.extra as OrderResponseEntity?;
          final fallbackOrder = order ??
              const OrderResponseEntity(
                id: 0,
                orderNumber: '',
                status: '--------',
                statusLabel: '--------',
                paymentMethod: '--------',
                paymentMethodLabel: '--------',
                totalAmount: 0,
                pointsEarned: 0,
                deliveryAddress: '---- • ----، ---',
                expectedDelivery: 'خلال 0 ساعة',
              );
          return OrderSuccessScreen(order: fallbackOrder);
        },
      ),
      GoRoute(
        path: RoutePaths.orderDetails,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final orderNumber = state.extra as String? ?? '';
          return OrderDetailsScreen(orderNumber: orderNumber);
        },
      ),
      GoRoute(
        path: RoutePaths.bankTransferPayment,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) => RoutePaths.bankTransferReceipt,
      ),
      GoRoute(
        path: RoutePaths.bankTransferReceipt,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          num? totalAmount;
          String orderNumber = '';

          if (state.extra is OrderResponseEntity) {
            final order = state.extra as OrderResponseEntity;
            orderNumber = order.orderNumber;
            totalAmount = order.totalAmount;
          } else if (state.extra is num) {
            totalAmount = state.extra as num;
          } else if (state.extra is String) {
            orderNumber = state.extra as String;
          } else if (state.extra is Map<String, dynamic>) {
            final map = state.extra as Map<String, dynamic>;
            orderNumber = map['orderNumber'] ?? map['order_number'] ?? '';
            totalAmount = map['totalAmount'];
          }

          return BankTransferReceiptScreen(
            orderNumber: orderNumber,
            totalAmount: totalAmount,
          );
        },
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
                  return SectionsScreen(initialTab: tab);
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
                path: RoutePaths.favorites,
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.orders,
                builder: (context, state) => const OrdersScreen(),
                routes: [
                  GoRoute(
                    path: 'details',
                    parentNavigatorKey: rootNavigatorKey,
                    builder: (context, state) {
                      final orderNumber = state.extra as String? ?? '';
                      return OrderDetailsScreen(orderNumber: orderNumber);
                    },
                  ),
                ],
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
