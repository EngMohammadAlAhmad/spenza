part of 'cart_bloc.dart';

class CartState extends Equatable {
  final RequestStatus status;
  final List<CartItemEntity> items;
  final CartItemEntity? lastAddedItem;
  final String? errorMessage;

  final CheckoutOptionsEntity? checkoutOptions;
  final RequestStatus checkoutOptionsStatus;
  final Failure checkoutOptionsFailure;

  final CartPreviewEntity? cartPreview;
  final RequestStatus previewStatus;
  final Failure previewFailure;

  const CartState({
    this.status = RequestStatus.init,
    this.items = const [],
    this.lastAddedItem,
    this.errorMessage,
    this.checkoutOptions,
    this.checkoutOptionsStatus = RequestStatus.init,
    this.checkoutOptionsFailure = defaultFailure,
    this.cartPreview,
    this.previewStatus = RequestStatus.init,
    this.previewFailure = defaultFailure,
  });

  num get totalCartPrice {
    if (cartPreview != null && cartPreview!.itemsSubtotal > 0) {
      return cartPreview!.itemsSubtotal;
    }
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount => items.fold(0, (sum, item) => sum + item.quantity);

  String get currency => cartPreview?.currency ?? 'ل.س';

  CartState copyWith({
    RequestStatus? status,
    List<CartItemEntity>? items,
    CartItemEntity? lastAddedItem,
    String? errorMessage,
    CheckoutOptionsEntity? checkoutOptions,
    RequestStatus? checkoutOptionsStatus,
    Failure? checkoutOptionsFailure,
    CartPreviewEntity? cartPreview,
    RequestStatus? previewStatus,
    Failure? previewFailure,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
      errorMessage: errorMessage ?? this.errorMessage,
      checkoutOptions: checkoutOptions ?? this.checkoutOptions,
      checkoutOptionsStatus: checkoutOptionsStatus ?? this.checkoutOptionsStatus,
      checkoutOptionsFailure: checkoutOptionsFailure ?? this.checkoutOptionsFailure,
      cartPreview: cartPreview ?? this.cartPreview,
      previewStatus: previewStatus ?? this.previewStatus,
      previewFailure: previewFailure ?? this.previewFailure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        items,
        lastAddedItem,
        errorMessage,
        checkoutOptions,
        checkoutOptionsStatus,
        checkoutOptionsFailure,
        cartPreview,
        previewStatus,
        previewFailure,
      ];
}
