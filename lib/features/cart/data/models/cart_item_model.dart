import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.productTitle,
    super.productImage,
    required super.unitPrice,
    required super.originalPrice,
    required super.quantity,
    required super.unitId,
    required super.unitTitle,
    super.variantId,
    super.variantLabel,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] as int? ?? 0,
      productTitle: json['product_title'] as String? ?? '',
      productImage: json['product_image'] as String?,
      unitPrice: json['unit_price'] as num? ?? 0,
      originalPrice: json['original_price'] as num? ?? 0,
      quantity: json['quantity'] as int? ?? 1,
      unitId: json['unit_id'] as int? ?? 0,
      unitTitle: json['unit_title'] as String? ?? '',
      variantId: json['variant_id'] as int? ?? json['product_variant_id'] as int?,
      variantLabel: json['variant_label'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_title': productTitle,
      'product_image': productImage,
      'unit_price': unitPrice,
      'original_price': originalPrice,
      'quantity': quantity,
      'unit_id': unitId,
      'unit_title': unitTitle,
      'variant_id': variantId,
      'variant_label': variantLabel,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      productId: entity.productId,
      productTitle: entity.productTitle,
      productImage: entity.productImage,
      unitPrice: entity.unitPrice,
      originalPrice: entity.originalPrice,
      quantity: entity.quantity,
      unitId: entity.unitId,
      unitTitle: entity.unitTitle,
      variantId: entity.variantId,
      variantLabel: entity.variantLabel,
    );
  }
}
