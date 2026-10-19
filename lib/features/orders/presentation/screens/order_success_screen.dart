import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
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
    SnackbarService.showSuccess(context, message: 'تم نسخ رقم الطلب');
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');

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
                        'assets/images/pattern.png',
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
                                children: const [
                                  Text(
                                    'وصلنا طلبك',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6.0),
                                  Text(
                                    'عم نجهزه، وبنخبرك بكل خطوة.',
                                    style: TextStyle(
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
                                  'assets/images/rounded_icon_white.svg',
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'بتكسب ${order.pointsEarned} نقطة لما يوصلك الطلب',
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
                child: Column(
                  children: [
                    // Order Info Card
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
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
                              const Text(
                                'رقم الطلب',
                                style: TextStyle(
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
                                      'assets/icons/copy_icon.svg',
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
                              const Text(
                                'حالة الطلب',
                                style: TextStyle(
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
                                  style: TextStyle(
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
                              const Text(
                                'بتدفع',
                                style: TextStyle(
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
                              const Text(
                                'الإجمالي',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.neutral,
                                ),
                              ),
                              Text(
                                '${formatter.format(order.totalAmount)} ل.س',
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
                              const Text(
                                'التوصيل لـ',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.neutral,
                                ),
                              ),
                              Text(
                                order.deliveryAddress.isNotEmpty
                                    ? order.deliveryAddress
                                    : 'المنزل • المزة، دمشق',
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
                              const Text(
                                'الموعد المتوقع',
                                style: TextStyle(
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
                    ),
                    const SizedBox(height: 16.0),

                    // Preparation Notice Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.thirdAccent,
                        borderRadius: BorderRadius.circular(18.0),
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
                              children: const [
                                Text(
                                  'جهز المبلغ',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E3A8A),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'المندوب بيتصل فيك قبل ما يوصل. الفاتورة بتظهر بطلباتي بعد ما تصدر.',
                                  style: TextStyle(
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
                    ),
                  ],
                ),
              ),
            ),

            // 3. Bottom Sticky Action Buttons
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 20.0),
                  child: Row(
                    spacing: 12.0,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'تابع طلبك',
                          height: 48.0,
                          onPressed: () {
                            // Order tracking action
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          text: 'كمل تسوق',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
