import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/entities/cart_preview_entity.dart';
import 'package:spenza/features/cart/domain/entities/checkout_options_entity.dart';
import 'package:spenza/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/get_checkout_options_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/get_checkout_preview_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/update_cart_quantity_use_case.dart';
import 'package:spenza/injection_locator.dart' as di;

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;
  final GetCheckoutOptionsUseCase getCheckoutOptionsUseCase;
  final GetCheckoutPreviewUseCase getCheckoutPreviewUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
    required this.getCheckoutOptionsUseCase,
    required this.getCheckoutPreviewUseCase,
  }) : super(const CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<GetCheckoutOptionsEvent>(_onGetCheckoutOptions);
    on<GetCheckoutPreviewEvent>(_onGetCheckoutPreview);
  }

  Future<void> _onGetCart(GetCartEvent event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await getCartUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.errMessage,
      )),
      (items) => emit(state.copyWith(
        status: RequestStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final isLoggedIn = di.sl<CacheHelper>().getAuthToken().isNotEmpty;
    if (!isLoggedIn) {
      return;
    }
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await addToCartUseCase(event.item);
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.errMessage,
      )),
      (items) => emit(state.copyWith(
        status: RequestStatus.success,
        items: items,
        lastAddedItem: event.item,
      )),
    );
  }

  Future<void> _onUpdateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    final result = await updateCartQuantityUseCase(
      productId: event.productId,
      unitId: event.unitId,
      quantity: event.quantity,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.errMessage,
      )),
      (items) => emit(state.copyWith(
        status: RequestStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final result = await removeFromCartUseCase(
      productId: event.productId,
      unitId: event.unitId,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.errMessage,
      )),
      (items) => emit(state.copyWith(
        status: RequestStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    final result = await clearCartUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        status: RequestStatus.error,
        errorMessage: failure.errMessage,
      )),
      (items) => emit(state.copyWith(
        status: RequestStatus.success,
        items: items,
      )),
    );
  }

  Future<void> _onGetCheckoutOptions(
    GetCheckoutOptionsEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(checkoutOptionsStatus: RequestStatus.loading));

    final result = await getCheckoutOptionsUseCase(event.cityId);

    result.fold(
      (failure) => emit(state.copyWith(
        checkoutOptionsStatus: RequestStatus.error,
        checkoutOptionsFailure: failure,
      )),
      (options) => emit(state.copyWith(
        checkoutOptionsStatus: RequestStatus.success,
        checkoutOptions: options,
      )),
    );
  }

  Future<void> _onGetCheckoutPreview(
    GetCheckoutPreviewEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(previewStatus: RequestStatus.loading));

    final result = await getCheckoutPreviewUseCase(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        previewStatus: RequestStatus.error,
        previewFailure: failure,
      )),
      (preview) {
        // Sync updated unit prices from preview to local cart items
        final updatedItems = state.items.map((cartItem) {
          final matches = preview.items.where((p) =>
              p.productId == cartItem.productId && p.unitId == cartItem.unitId);
          if (matches.isNotEmpty) {
            final previewItem = matches.first;
            if (previewItem.unitPrice != cartItem.unitPrice) {
              return cartItem.copyWith(unitPrice: previewItem.unitPrice);
            }
          }
          return cartItem;
        }).toList();

        emit(state.copyWith(
          previewStatus: RequestStatus.success,
          cartPreview: preview,
          items: updatedItems,
        ));
      },
    );
  }
}
