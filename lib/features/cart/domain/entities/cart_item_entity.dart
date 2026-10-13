import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final int productId;
  final String productTitle;
  final String? productImage;
  final num unitPrice;
  final num originalPrice;
  final int quantity;
  final int unitId;
  final String unitTitle;
  final int? variantId;
  final String? variantLabel;

  const CartItemEntity({
    required this.productId,
    required this.productTitle,
    this.productImage,
    required this.unitPrice,
    required this.originalPrice,
    required this.quantity,
    required this.unitId,
    required this.unitTitle,
    this.variantId,
    this.variantLabel,
  });

  num get totalPrice => unitPrice * quantity;

  CartItemEntity copyWith({
    int? productId,
    String? productTitle,
    String? productImage,
    num? unitPrice,
    num? originalPrice,
    int? quantity,
    int? unitId,
    String? unitTitle,
    int? variantId,
    String? variantLabel,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      productImage: productImage ?? this.productImage,
      unitPrice: unitPrice ?? this.unitPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      unitId: unitId ?? this.unitId,
      unitTitle: unitTitle ?? this.unitTitle,
      variantId: variantId ?? this.variantId,
      variantLabel: variantLabel ?? this.variantLabel,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        productTitle,
        productImage,
        unitPrice,
        originalPrice,
        quantity,
        unitId,
        unitTitle,
        variantId,
        variantLabel,
      ];
}
