import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/cart_header.dart';
import 'package:spenza/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:spenza/features/cart/presentation/widgets/empty_cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final isEmpty = state.items.isEmpty;

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Column(
            children: [
              const CartHeader(),
              Expanded(
                child: isEmpty
                    ? const EmptyCartWidget()
                    : _buildNonEmptyCart(context, state),
              ),
            ],
          ),
          bottomNavigationBar: isEmpty
              ? null
              : _buildCheckoutFooter(context, state),
        );
      },
    );
  }

  // ================= Non-Empty Cart View =================
  Widget _buildNonEmptyCart(BuildContext context, CartState state) {
    final formatter = NumberFormat('#,##0');
    const freeDeliveryThreshold = 1500;
    final totalCartPrice = state.totalCartPrice;
    final remainingForFree = freeDeliveryThreshold - totalCartPrice;
    final isFreeDelivery = remainingForFree <= 0;
    final progress = (totalCartPrice / freeDeliveryThreshold).clamp(0.0, 1.0);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Free Delivery Progress Card
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80.0,
                  child: Row(
                    spacing: 10.0,
                    children: [
                      Expanded(
                        child: Text(
                          isFreeDelivery
                              ? 'مبروك!حصلت على توصيل عادي مجاني'
                              : 'ضيف بـ ${formatter.format(remainingForFree)} ل.س وبيصير التوصيل العادي مجاني',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                      ),
                      SvgPicture.asset('assets/icons/truck_icon.svg'),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: progress.toDouble(),
                    minHeight: 8.0,
                    backgroundColor: AppColors.neutral200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFF2B211),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // 2. Product Items List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12.0),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemCard(item: item, formatter: formatter);
            },
          ),
          const SizedBox(height: 24.0),

          // 3. Discount / Coupon / Reward Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'كود خصم أو مكافأة',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Text(
                            'اختار من مكافآتي',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    // Code Input
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'اكتب كود الخصم',
                            hintStyle: const TextStyle(
                              color: AppColors.neutral,
                              fontSize: 13,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),

                    // Apply button
                    SizedBox(
                      height: 48,
                      width: 80,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'طبق',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // 4. Order Price Summary
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المنتجات (${state.totalItemsCount})',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${formatter.format(state.totalCartPrice)} ل.س',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'التوصيل',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'بعد اختيار العنوان',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'الأسعار شاملة الضريبة.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.neutral,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
        ],
      ),
    );
  }

  // ================= Sticky Checkout Footer =================
  Widget _buildCheckoutFooter(BuildContext context, CartState state) {
    final formatter = NumberFormat('#,##0');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16.0,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total price info (Right side in RTL)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'المجموع قبل التوصيل',
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AppColors.neutral,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${formatter.format(state.totalCartPrice)} ل.س',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              // "كمل الطلب" Button (Left side in RTL)
              SizedBox(
                width: 150.0,
                child: CustomButton(
                  text: 'كمل الطلب',
                  height: 48.0,
                  onPressed: () {
                    context.push(RoutePaths.checkout);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
