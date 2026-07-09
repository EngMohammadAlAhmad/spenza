import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/dimens.dart';
import 'package:spenza/core/widgets/custom_text_field.dart';
import 'package:spenza/features/home/presentation/widgets/banner_slider.dart';
import 'package:spenza/features/home/presentation/widgets/best_selling_section.dart';
import 'package:spenza/features/home/presentation/widgets/dummy_banner_slider_data.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_brand_section.dart';
import 'package:spenza/features/home/presentation/widgets/shop_by_category_section.dart';
import 'package:spenza/features/home/presentation/widgets/today_orders_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 186.44,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16.0,
              right: 16.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(34.0),
                bottomRight: Radius.circular(34.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: .spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    SvgPicture.asset('assets/icons/location_icon.svg'),
                    Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text('التوصيل إلى', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.neutral)),
                        Text('المنزل - دمشق', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        )),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/icons/temp.svg'),
                    ),
                  ],
                ),
                CustomTextField(
                  controller: TextEditingController(),
                  fillColor: AppColors.fillColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsetsGeometry.directional(start: 16.0, end: 5.0),
                    child: SvgPicture.asset('assets/icons/search_icon.svg'),
                  ),
                  hintText: 'ابحث عن قلم، دفتر، حقيبة...',
                ),
                SizedBox(height: AppDimens.spaceS),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              physics:  const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                spacing: 15.0,
                children: [
                  BannerSlider(banners: dummyBanners),
                  ShopByCategorySection(),
                  FreeDeliveryCard(),
                  ShopByBrandSection(),
                  TodayOffersSection(),
                  BestSellingSection(),
                ],
              ),
            ),
          ),
        ],
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
                colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.1), .srcIn),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 17.0,
                vertical: 12.75,
              ),
              child: Row(
                spacing: 25.0,
                children: [
                  Image.asset('assets/images/delivery_image.png'),
                  Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .center,
                    children: [
                      Text('توصيل مجاني للطلبات فوق', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: .bold)),
                      Text('1,500 ل.س', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.primary500, fontWeight: .bold)),
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
