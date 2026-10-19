import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/themes/app_radius.dart';
import 'package:spenza/core/utils/app_assets.dart';
import 'package:spenza/core/widgets/custom_button.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_state.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/cart_header.dart';
import 'package:spenza/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:spenza/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:spenza/injection_locator.dart' as di;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: di.sl<AddressesBloc>()..add(const GetAddressesEvent()),
      child: const _CartView(),
    );
  }
}

class _CartView extends StatefulWidget {
  const _CartView();

  @override
  State<_CartView> createState() => _CartViewState();
}

class _CartViewState extends State<_CartView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCheckoutPreview(context);
    });
  }

  void _fetchCheckoutPreview(BuildContext context) {
    final cartState = context.read<CartBloc>().state;
    if (cartState.items.isEmpty) return;

    int? addressId;
    final addressesState = context.read<AddressesBloc>().state;
    if (addressesState.addresses.isNotEmpty) {
      final defaultMatches = addressesState.addresses.where((a) => a.isDefault);
      final defaultAddr = defaultMatches.isNotEmpty
          ? defaultMatches.first
          : addressesState.addresses.first;
      addressId = defaultAddr.id;
    }

    final previewItems = cartState.items
        .map((e) => CheckoutPreviewItemParam(
              productId: e.productId,
              productUnitId: e.unitId,
              productVariantId: e.variantId,
              quantity: e.quantity,
            ))
        .toList();

    final params = CheckoutPreviewParams(
      addressId: addressId,
      deliveryMethod: 'standard',
      items: previewItems,
    );

    context.read<CartBloc>().add(GetCheckoutPreviewEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressesBloc, AddressesState>(
      listenWhen: (prev, curr) =>
          prev.getAddressesStatus != curr.getAddressesStatus ||
          prev.addresses != curr.addresses,
      listener: (context, addressesState) {
        if (addressesState.getAddressesStatus == RequestStatus.success) {
          _fetchCheckoutPreview(context);
        }
      },
      child: BlocBuilder<CartBloc, CartState>(
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
            bottomNavigationBar:
                isEmpty ? null : _buildCheckoutFooter(context, state),
          );
        },
      ),
    );
  }

  // ================= Non-Empty Cart View =================
  Widget _buildNonEmptyCart(BuildContext context, CartState state) {
    final formatter = NumberFormat('#,##0');
    final preview = state.cartPreview;
    final currency = state.currency;

    bool isFreeDelivery = false;
    num remainingForFree = 1500;
    double progress = 0.0;

    if (preview != null && preview.freeDeliveryIsEnabled) {
      isFreeDelivery = preview.freeDeliveryIsQualified;
      remainingForFree = preview.freeDeliveryRemaining;
      progress = preview.freeDeliveryProgress;
    } else {
      const freeDeliveryThreshold = 1500;
      final totalCartPrice = state.totalCartPrice;
      remainingForFree = freeDeliveryThreshold - totalCartPrice;
      isFreeDelivery = remainingForFree <= 0;
      progress = (totalCartPrice / freeDeliveryThreshold).clamp(0.0, 1.0);
    }

    final isLoadingPreview = state.previewStatus == RequestStatus.loading;

    return RefreshIndicator(
      onRefresh: () async {
        _fetchCheckoutPreview(context);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Free Delivery Progress Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.upMedium,
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
                      children: [
                        Expanded(
                          child: Text(
                            isFreeDelivery
                                ? 'مبروك! حصلت على توصيل عادي مجاني'
                                : 'ضيف بـ ${formatter.format(remainingForFree)} $currency وبيصير التوصيل العادي مجاني',
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        SvgPicture.asset(AppAssets.truckIcon),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: AppRadius.ordinary,
                    child: LinearProgressIndicator(
                      value: progress,
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

            if (isLoadingPreview) ...[
              const LinearProgressIndicator(
                minHeight: 2.0,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: 8.0),
            ],

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
                borderRadius: AppRadius.upMedium,
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
                        child: const Row(
                          children: [
                            Text(
                              'اختار من مكافآتي',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: AppColors.primary),
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.medium,
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.medium,
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: AppRadius.medium,
                                borderSide:
                                    const BorderSide(color: AppColors.primary),
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
                            side: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.medium,
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
                borderRadius: AppRadius.upMedium,
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
                        '${formatter.format(state.totalCartPrice)} $currency',
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
      ),
    );
  }

  // ================= Sticky Checkout Footer =================
  Widget _buildCheckoutFooter(BuildContext context, CartState state) {
    final formatter = NumberFormat('#,##0');
    final currency = state.currency;

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
              // Total price info
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
                    '${formatter.format(state.totalCartPrice)} $currency',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              // "كمل الطلب" Button
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
