import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/home/domain/entities/home_data_entity.dart';
import 'package:spenza/features/home/presentation/blocs/home_bloc/home_bloc.dart';
import 'package:spenza/features/home/presentation/widgets/banner_slider.dart';
import 'package:spenza/features/home/presentation/widgets/best_selling_section.dart';
import 'package:spenza/features/home/presentation/widgets/home_header.dart';
import 'package:spenza/features/home/presentation/widgets/order_again_section.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_brand_section.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_category_section.dart';
import 'package:spenza/features/home/presentation/widgets/today_orders_section.dart';
import 'package:spenza/injection_locator.dart' as di;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<HomeBloc>()..add(const GetHomeDataEvent()),
      child: Scaffold(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        body: BlocBuilder<HomeBloc, BaseState<HomeDataEntity>>(
          builder: (context, state) {
            final data = state.data;
            final isLoading = state.isLoading || data == null;

            return Column(
              children: [
                const HomeHeader(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<HomeBloc>().add(const GetHomeDataEvent());
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                      child: Column(
                        spacing: 15.0,
                        children: [
                          BannerSlider(
                            banners: data?.banners ?? [],
                            isLoading: isLoading,
                          ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                          ShopByCategorySection(
                            categories: data?.categories ?? [],
                            isLoading: isLoading,
                          ).animate(delay: 80.ms).fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                          const FreeDeliveryCard()
                              .animate(delay: 160.ms)
                              .fadeIn(duration: 450.ms)
                              .scaleXY(begin: 0.94, end: 1, curve: Curves.easeOutCubic),

                          ShopByBrandSection(
                            brands: data?.brands ?? [],
                            isLoading: isLoading,
                          ).animate(delay: 240.ms).fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                          TodayOffersSection(
                            products: data?.discountedProducts ?? [],
                            isLoading: isLoading,
                          ).animate(delay: 320.ms).fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                          BestSellingSection(
                            products: data?.products ?? [],
                            isLoading: isLoading,
                          ).animate(delay: 400.ms).fadeIn(duration: 450.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),

                          OrderAgainSection()
                              .animate(delay: 480.ms)
                              .fadeIn(duration: 450.ms)
                              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FreeDeliveryCard extends StatelessWidget {
  const FreeDeliveryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.mediumMiddle,
      child: Container(
        height: 76.5,
        width: MediaQuery.sizeOf(context).width,
        color: AppColors.secondary,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/container_background.svg',
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.1), BlendMode.srcIn),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 12.75),
              child: Row(
                spacing: 25.0,
                children: [
                  Image.asset('assets/images/delivery_image.png'),
                  Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text('توصيل مجاني للطلبات فوق', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                      Text('150,000 ل.س', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary500, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
