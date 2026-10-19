/*
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'package:spenza/features/orders/presentation/widgets/orders_header.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        StatefulNavigationShell.of(context).goBranch(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.neutralBackground,
        body: Column(
          children: [
            const OrdersHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BlocBuilder<AuthStatusBloc, AuthStatusState>(
                  builder: (context, state) {
                    return state.isLoggedIn ? _buildNoOrdersState(context) : _buildLoginPrompt(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppAssets.ordersScreenIcon,
          height: 96.0,
          width: 96.0,
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
        Text(
          'تابع طلباتك بسهولة',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
        Text(
          'سجّل دخول حتى تشوف طلباتك الحالية والسابقة وتعيد الطلب بضغطة.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0.0),
        CustomButton(
          text: 'تسجيل الدخول',
          onPressed: () => context.push(RoutePaths.login),
          icon: SvgPicture.asset(AppAssets.loginIcon),
          width: 200.0,
        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
        TextButton(
          onPressed: () => context.go(RoutePaths.home),
          child: Text(
            'تصفّح المتجر أولاً',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ).animate().fadeIn(delay: 800.ms),
      ],
    );
  }

  Widget _buildNoOrdersState(BuildContext context) {
    return Column(
      spacing: 15.0,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Creative Empty State Illustration
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 0.9, end: 1.1, duration: 2.seconds, curve: Curves.easeInOut),

            Icon(
              Icons.shopping_basket_outlined,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.5),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .moveY(begin: -5, end: 5, duration: 1.5.seconds, curve: Curves.easeInOut),

            Positioned(
              bottom: 20,
              right: 20,
              child: const Icon(Icons.search, size: 40, color: AppColors.secondary)
                  .animate(onPlay: (c) => c.repeat())
                  .rotate(duration: 3.seconds),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Text(
          'سلتك عم تستناك!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.neutral900,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

        Text(
          'لسه ما عندك طلبات، شو ناطر؟ بلّش تسوّق واختار أحسن العروض والمنتجات اللي بتحبها.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0.0),

        const SizedBox(height: 10),

        CustomButton(
          text: 'ابدأ التسوق الآن',
          onPressed: () => context.go(RoutePaths.categories),
          width: 220.0,
        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.95, 0.95)),
      ],
    );
  }
}
*/
