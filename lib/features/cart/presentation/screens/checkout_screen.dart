import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'package:spenza/core/themes/app_colors.dart';
import 'package:spenza/core/widgets/snackbar_service.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_bloc.dart';
import 'package:spenza/features/addresses/presentation/bloc/addresses_event.dart';
import 'package:spenza/features/cart/presentation/blocs/cart_bloc/cart_bloc.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_bottom_bar.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_header.dart';
import 'package:spenza/features/cart/presentation/widgets/checkout_progress_indicator.dart';
import 'package:spenza/features/cart/presentation/widgets/step1_delivery_address_view.dart';
import 'package:spenza/features/cart/presentation/widgets/step2_bottom_bar.dart';
import 'package:spenza/features/cart/presentation/widgets/step2_delivery_and_payment_view.dart';
import 'package:spenza/features/cart/presentation/widgets/step3_bottom_bar.dart';
import 'package:spenza/features/cart/presentation/widgets/step3_review_and_confirm_view.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';
import 'package:spenza/injection_locator.dart' as di;

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: di.sl<AddressesBloc>()..add(const GetAddressesEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<OrdersBloc>(),
        ),
      ],
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  int _currentStep = 1;
  final int _totalSteps = 3;

  int? _selectedAddressId;
  String _selectedDeliveryType = 'standard'; // 'standard', 'express'
  String _selectedPaymentMethod = 'cash'; // 'cash', 'bank', 'paymera'
  String _driverNote = '';

  String get stepTitle {
    switch (_currentStep) {
      case 1:
        return 'عنوان التوصيل';
      case 2:
        return 'التوصيل والدفع';
      case 3:
        return 'مراجعة وتأكيد';
      default:
        return 'عنوان التوصيل';
    }
  }

  num get deliveryFee {
    final cartState = context.watch<CartBloc>().state;
    final options = cartState.checkoutOptions;
    if (options != null && options.deliveryOptions.isNotEmpty) {
      final matches = options.deliveryOptions.where((o) => o.method == _selectedDeliveryType);
      if (matches.isNotEmpty) {
        return matches.first.fee;
      }
      return options.deliveryFee;
    }
    return 5000;
  }

  void _onAddressSelected(int id) {
    setState(() => _selectedAddressId = id);
    final addressesState = context.read<AddressesBloc>().state;
    final matches = addressesState.addresses.where((a) => a.id == id);
    if (matches.isNotEmpty) {
      final addr = matches.first;
      final cityId = addr.cityId > 0 ? addr.cityId : 1;
      context.read<CartBloc>().add(GetCheckoutOptionsEvent(cityId: cityId));
    }
  }

  void _submitOrder() {
    final cartState = context.read<CartBloc>().state;
    if (cartState.items.isEmpty) {
      SnackbarService.showError(context, message: 'السلة فارغة');
      return;
    }

    final items = cartState.items
        .map((e) => CreateOrderItemParams(
              productId: e.productId,
              productUnitId: e.unitId,
              productVariantId: e.variantId,
              quantity: e.quantity,
            ))
        .toList();

    final String mappedPaymentMethod;
    if (_selectedPaymentMethod == 'bank' || _selectedPaymentMethod == 'bank_transfer') {
      mappedPaymentMethod = 'bank_transfer';
    } else if (_selectedPaymentMethod == 'cash' || _selectedPaymentMethod == 'cash_on_delivery') {
      mappedPaymentMethod = 'cash_on_delivery';
    } else {
      mappedPaymentMethod = _selectedPaymentMethod;
    }

    final params = CreateOrderParams(
      addressId: _selectedAddressId ?? 1,
      deliveryMethod: _selectedDeliveryType,
      notes: _driverNote.isNotEmpty ? _driverNote : null,
      paymentMethod: mappedPaymentMethod,
      items: items,
    );

    context.read<OrdersBloc>().add(CreateOrderEvent(params));
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final num totalAmount = cartState.totalCartPrice + deliveryFee;

    AddressEntity? selectedAddress;
    final addressesState = context.watch<AddressesBloc>().state;
    if (_selectedAddressId != null && addressesState.addresses.isNotEmpty) {
      final matches = addressesState.addresses.where((a) => a.id == _selectedAddressId);
      selectedAddress = matches.isNotEmpty ? matches.first : addressesState.addresses.first;
    }

    return BlocListener<OrdersBloc, OrdersState>(
      listenWhen: (prev, curr) => prev.createOrderStatus != curr.createOrderStatus,
      listener: (context, state) {
        if (state.createOrderStatus == RequestStatus.success &&
            state.createdOrder != null) {
          // Clear Cart
          context.read<CartBloc>().add(const ClearCartEvent());
          final selected = _selectedPaymentMethod.toLowerCase();
          final createdMethod = (state.createdOrder?.paymentMethod ?? '').toLowerCase();
          final isBankTransfer = selected.contains('bank') ||
              selected.contains('transfer') ||
              selected.contains('حوالة') ||
              createdMethod.contains('bank') ||
              createdMethod.contains('transfer') ||
              createdMethod.contains('receipt');

          if (isBankTransfer) {
            context.go(RoutePaths.bankTransferReceipt, extra: state.createdOrder);
          } else {
            context.go(RoutePaths.orderSuccess, extra: state.createdOrder);
          }
        } else if (state.createOrderStatus == RequestStatus.error) {
          SnackbarService.showError(
            context,
            message: state.createOrderFailure.errMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            // 1. Header Widget
            CheckoutHeader(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepTitle: stepTitle,
              onBackPressed: () {
                if (_currentStep > 1) {
                  setState(() => _currentStep--);
                } else {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),

            // 2. Fixed Step Progress Indicator Immediately Under Header
            CheckoutProgressIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),

            // 3. Step Content Body
            Expanded(
              child: _currentStep == 1
                  ? Step1DeliveryAddressView(
                      selectedAddressId: _selectedAddressId,
                      onAddressSelected: _onAddressSelected,
                    )
                  : (_currentStep == 2
                      ? Step2DeliveryAndPaymentView(
                          selectedAddress: selectedAddress,
                          selectedDeliveryType: _selectedDeliveryType,
                          selectedPaymentMethod: _selectedPaymentMethod,
                          onDeliveryTypeChanged: (type) {
                            setState(() => _selectedDeliveryType = type);
                          },
                          onPaymentMethodChanged: (method) {
                            setState(() => _selectedPaymentMethod = method);
                          },
                        )
                      : Step3ReviewAndConfirmView(
                          selectedAddress: selectedAddress,
                          selectedDeliveryType: _selectedDeliveryType,
                          selectedPaymentMethod: _selectedPaymentMethod,
                          onDriverNoteChanged: (note) {
                            _driverNote = note;
                          },
                          onEditDeliveryStepPressed: () {
                            setState(() => _currentStep = 1);
                          },
                          onEditPaymentStepPressed: () {
                            setState(() => _currentStep = 2);
                          },
                          onEditCartPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(RoutePaths.cart);
                            }
                          },
                        )),
            ),
          ],
        ),
        bottomNavigationBar: _currentStep == 1
            ? CheckoutBottomBar(
                isEnabled: _selectedAddressId != null,
                onNextPressed: () {
                  setState(() => _currentStep = 2);
                },
              )
            : (_currentStep == 2
                ? Step2BottomBar(
                    totalAmount: totalAmount,
                    onReviewPressed: () {
                      setState(() => _currentStep = 3);
                    },
                  )
                : BlocBuilder<OrdersBloc, OrdersState>(
                    builder: (context, ordersState) {
                      final isLoading =
                          ordersState.createOrderStatus == RequestStatus.loading;
                      return Step3BottomBar(
                        totalAmount: totalAmount,
                        isLoading: isLoading,
                        onConfirmOrderPressed: isLoading ? null : _submitOrder,
                      );
                    },
                  )),
      ),
    );
  }
}
