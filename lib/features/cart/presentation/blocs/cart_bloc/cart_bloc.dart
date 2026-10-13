import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:spenza/features/cart/domain/usecases/update_cart_quantity_use_case.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.updateCartQuantityUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState()) {
    on<GetCartEvent>(_onGetCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
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
}
