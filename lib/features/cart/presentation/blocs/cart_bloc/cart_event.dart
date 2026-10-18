part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class GetCartEvent extends CartEvent {
  const GetCartEvent();
}

class AddToCartEvent extends CartEvent {
  final CartItemEntity item;
  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateCartQuantityEvent extends CartEvent {
  final int productId;
  final int unitId;
  final int quantity;

  const UpdateCartQuantityEvent({
    required this.productId,
    required this.unitId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, unitId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  final int unitId;

  const RemoveFromCartEvent({
    required this.productId,
    required this.unitId,
  });

  @override
  List<Object?> get props => [productId, unitId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

class GetCheckoutOptionsEvent extends CartEvent {
  final int cityId;

  const GetCheckoutOptionsEvent({required this.cityId});

  @override
  List<Object?> get props => [cityId];
}

class GetCheckoutPreviewEvent extends CartEvent {
  final CheckoutPreviewParams params;

  const GetCheckoutPreviewEvent({required this.params});

  @override
  List<Object?> get props => [params];
}
