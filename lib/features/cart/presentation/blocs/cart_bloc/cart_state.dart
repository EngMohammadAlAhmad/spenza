part of 'cart_bloc.dart';

class CartState extends Equatable {
  final RequestStatus status;
  final List<CartItemEntity> items;
  final CartItemEntity? lastAddedItem;
  final String? errorMessage;

  const CartState({
    this.status = RequestStatus.init,
    this.items = const [],
    this.lastAddedItem,
    this.errorMessage,
  });

  num get totalCartPrice => items.fold(0, (sum, item) => sum + item.totalPrice);
  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  CartState copyWith({
    RequestStatus? status,
    List<CartItemEntity>? items,
    CartItemEntity? lastAddedItem,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, lastAddedItem, errorMessage];
}
