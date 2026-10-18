import 'package:equatable/equatable.dart';

class CartPreviewItemEntity extends Equatable {
  final int productId;
  final int unitId;
  final int? variantId;
  final String productName;
  final String unitName;
  final String? variantLabel;
  final String? productImage;
  final num unitPrice;
  final int quantity;
  final num lineTotal;
  final int availableQuantity;
  final bool isInStock;

  const CartPreviewItemEntity({
    required this.productId,
    required this.unitId,
    this.variantId,
    required this.productName,
    required this.unitName,
    this.variantLabel,
    this.productImage,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    required this.availableQuantity,
    required this.isInStock,
  });

  @override
  List<Object?> get props => [
        productId,
        unitId,
        variantId,
        productName,
        unitName,
        variantLabel,
        productImage,
        unitPrice,
        quantity,
        lineTotal,
        availableQuantity,
        isInStock,
      ];
}

class CartPreviewEntity extends Equatable {
  final List<CartPreviewItemEntity> items;
  final int itemsCount;
  final int unitsCount;
  final num itemsSubtotal;
  final num discountTotal;
  final num deliveryFee;
  final num total;
  final String currency;
  final int pointsEarned;
  final bool freeDeliveryIsEnabled;
  final num freeDeliveryThreshold;
  final num freeDeliveryRemaining;
  final bool freeDeliveryIsQualified;
  final double freeDeliveryProgress;
  final bool isOrderable;

  const CartPreviewEntity({
    required this.items,
    required this.itemsCount,
    required this.unitsCount,
    required this.itemsSubtotal,
    required this.discountTotal,
    required this.deliveryFee,
    required this.total,
    required this.currency,
    required this.pointsEarned,
    required this.freeDeliveryIsEnabled,
    required this.freeDeliveryThreshold,
    required this.freeDeliveryRemaining,
    required this.freeDeliveryIsQualified,
    required this.freeDeliveryProgress,
    required this.isOrderable,
  });

  @override
  List<Object?> get props => [
        items,
        itemsCount,
        unitsCount,
        itemsSubtotal,
        discountTotal,
        deliveryFee,
        total,
        currency,
        pointsEarned,
        freeDeliveryIsEnabled,
        freeDeliveryThreshold,
        freeDeliveryRemaining,
        freeDeliveryIsQualified,
        freeDeliveryProgress,
        isOrderable,
      ];
}
