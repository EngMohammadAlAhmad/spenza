import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/utils/responsive_utils.dart';
import 'package:spenza/core/widgets/app_bottom_container.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderResponseEntity order;

  const OrderSuccessScreen({
    super.key,
    required this.order,
  });

  void _copyOrderNumber(BuildContext context) {
    Clipboard.setData(ClipboardData(text: order.orderNumber));
    SnackbarService.showSuccess(context, message: 'copied_order_number'.tr());
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final isTabletLandscape = context.isTabletLandscape;

    Widget buildOrderInfoCard() {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.upMedium,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Order Number Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_number'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                GestureDetector(
                  onTap: () => _copyOrderNumber(context),
                  child: Row(
                    spacing: 4.0,
                    children: [
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                      SvgPicture.asset(
                        AppAssets.copyIcon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Order Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'order_status'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: AppRadius.medium,
                  ),
                  child: Text(
                    order.statusLabel,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Payment Method Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'paying'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral200,
                    borderRadius: AppRadius.medium,
                  ),
                  child: Text(
                    order.paymentMethodLabel,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, color: AppColors.neutral200),
            ),

            // Total Amount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'total'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                Text(
                  '${formatter.format(order.totalAmount)} ${'sp_currency'.tr()}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Delivery Address Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'deliver_to'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                Text(
                  order.deliveryAddress.isNotEmpty
                      ? order.deliveryAddress
                      : '',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),

            // Expected Delivery Time Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'expected_time'.tr(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: AppColors.neutral,
                  ),
                ),
                Text(
                  order.expectedDelivery,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neutral900,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget buildPreparationNoticeBanner() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.thirdAccent,
          borderRadius: AppRadius.upMedium,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF3B82F6),
              size: 22.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'prepare_cash'.tr(),
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'prepare_cash_desc'.tr(),
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: AppColors.textBody,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget bodyContent;

    if (isTabletLandscape) {
      bodyContent = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Child: Order Info Card (Right side in RTL)
          Expanded(
            flex: 1,
            child: buildOrderInfoCard(),
          ),
          const SizedBox(width: 20.0),

          // Second Child: Preparation Notice Banner (Left side in RTL)
          Expanded(
            flex: 1,
            child: buildPreparationNoticeBanner(),
          ),
        ],
      );
    } else {
      bodyContent = Column(
        children: [
          buildOrderInfoCard(),
          const SizedBox(height: 16.0),
          buildPreparationNoticeBanner(),
        ],
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.go(RoutePaths.home);
      },
      child: Scaffold(
        backgroundColor: AppColors.neutral200,
        body: Column(
          children: [
            // 1. Top Red Gradient Header Banner
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF91292B),
                    Color(0xFFC74436),
                    Color(0xFFD46B60),
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32.0),
                ),
              ),
              child: Stack(
                children: [
                  // Pattern overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32.0),
                      ),
                      child: Image.asset(
                        AppAssets.pattern,
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.08),
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title & Checkmark Badge Row
                          Row(
                            spacing: 20.0,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: AppRadius.large,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: AppColors.primary500,
                                  size: 30.0,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'order_received'.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                  Text(
                                    'preparing_order'.tr(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),

                          // Points Earned Translucent Banner
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: AppRadius.upMedium,
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.roundedIconWhite,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'earn_points_on_delivery'.tr(args: ['${order.pointsEarned}']),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Order Info Details Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 24.0),
                child: bodyContent,
              ),
            ),

            // 3. Bottom Sticky Action Buttons
            AppBottomContainer(
              maxContentWidth: 550.0,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                spacing: 12.0,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'track_your_order'.tr(),
                      height: 48.0,
                      onPressed: () {
                        context.push(RoutePaths.orderDetails, extra: order.orderNumber);
                      },
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'continue_shopping'.tr(),
                      isOutlined: true,
                      height: 48.0,
                      onPressed: () {
                        context.go(RoutePaths.home);
                      },
                    ),
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
