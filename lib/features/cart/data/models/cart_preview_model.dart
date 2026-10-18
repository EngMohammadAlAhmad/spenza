import 'package:equatable/equatable.dart';
import 'package:spenza/features/cart/domain/entities/cart_preview_entity.dart';

class CheckoutPreviewItemParam extends Equatable {
  final int productId;
  final int productUnitId;
  final int? productVariantId;
  final int quantity;

  const CheckoutPreviewItemParam({
    required this.productId,
    required this.productUnitId,
    this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'product_id': productId,
      'product_unit_id': productUnitId,
      'quantity': quantity,
    };
    if (productVariantId != null && productVariantId! > 0) {
      map['product_variant_id'] = productVariantId;
    }
    return map;
  }

  @override
  List<Object?> get props => [
        productId,
        productUnitId,
        productVariantId,
        quantity,
      ];
}

class CheckoutPreviewParams extends Equatable {
  final int? addressId;
  final String deliveryMethod;
  final String? couponCode;
  final List<CheckoutPreviewItemParam> items;

  const CheckoutPreviewParams({
    this.addressId,
    this.deliveryMethod = 'standard',
    this.couponCode,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        if (addressId != null && addressId! > 0) 'address_id': addressId,
        'delivery_method': deliveryMethod,
        if (couponCode != null && couponCode!.trim().isNotEmpty)
          'coupon_code': couponCode!.trim(),
        'items': items.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        addressId,
        deliveryMethod,
        couponCode,
        items,
      ];
}

class CartPreviewItemModel extends CartPreviewItemEntity {
  const CartPreviewItemModel({
    required super.productId,
    required super.unitId,
    super.variantId,
    required super.productName,
    required super.unitName,
    super.variantLabel,
    super.productImage,
    required super.unitPrice,
    required super.quantity,
    required super.lineTotal,
    required super.availableQuantity,
    required super.isInStock,
  });

  factory CartPreviewItemModel.fromJson(Map<String, dynamic> json) {
    return CartPreviewItemModel(
      productId: json['product_id'] is num
          ? (json['product_id'] as num).toInt()
          : (int.tryParse(json['product_id']?.toString() ?? '') ?? 0),
      unitId: json['product_unit_id'] is num
          ? (json['product_unit_id'] as num).toInt()
          : (int.tryParse(json['product_unit_id']?.toString() ?? '') ?? 0),
      variantId: json['product_variant_id'] is num
          ? (json['product_variant_id'] as num).toInt()
          : int.tryParse(json['product_variant_id']?.toString() ?? ''),
      productName: json['product_name']?.toString() ?? '',
      unitName: json['unit_name']?.toString() ?? '',
      variantLabel: json['variant_label']?.toString(),
      productImage: json['product_image']?.toString(),
      unitPrice: json['unit_price'] is num
          ? json['unit_price'] as num
          : (num.tryParse(json['unit_price']?.toString() ?? '') ?? 0),
      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toInt()
          : (int.tryParse(json['quantity']?.toString() ?? '') ?? 1),
      lineTotal: json['line_total'] is num
          ? json['line_total'] as num
          : (num.tryParse(json['line_total']?.toString() ?? '') ?? 0),
      availableQuantity: json['available_quantity'] is num
          ? (json['available_quantity'] as num).toInt()
          : (int.tryParse(json['available_quantity']?.toString() ?? '') ?? 0),
      isInStock: json['is_in_stock'] == true,
    );
  }
}

class CartPreviewModel extends CartPreviewEntity {
  const CartPreviewModel({
    required super.items,
    required super.itemsCount,
    required super.unitsCount,
    required super.itemsSubtotal,
    required super.discountTotal,
    required super.deliveryFee,
    required super.total,
    required super.currency,
    required super.pointsEarned,
    required super.freeDeliveryIsEnabled,
    required super.freeDeliveryThreshold,
    required super.freeDeliveryRemaining,
    required super.freeDeliveryIsQualified,
    required super.freeDeliveryProgress,
    required super.isOrderable,
  });

  factory CartPreviewModel.fromJson(Map<String, dynamic> json) {
    List<CartPreviewItemModel> parsedItems = [];
    if (json['items'] is List) {
      parsedItems = (json['items'] as List)
          .map((e) => CartPreviewItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final freeDeliveryMap = json['free_delivery'] as Map<String, dynamic>?;

    final threshold = freeDeliveryMap?['threshold'] is num
        ? freeDeliveryMap!['threshold'] as num
        : (num.tryParse(freeDeliveryMap?['threshold']?.toString() ?? '') ?? 0);

    final remaining = freeDeliveryMap?['remaining'] is num
        ? freeDeliveryMap!['remaining'] as num
        : (num.tryParse(freeDeliveryMap?['remaining']?.toString() ?? '') ?? 0);

    final progressVal = freeDeliveryMap?['progress'] is num
        ? (freeDeliveryMap!['progress'] as num).toDouble()
        : (double.tryParse(freeDeliveryMap?['progress']?.toString() ?? '') ?? 0.0);

    return CartPreviewModel(
      items: parsedItems,
      itemsCount: json['items_count'] is num
          ? (json['items_count'] as num).toInt()
          : (int.tryParse(json['items_count']?.toString() ?? '') ?? 0),
      unitsCount: json['units_count'] is num
          ? (json['units_count'] as num).toInt()
          : (int.tryParse(json['units_count']?.toString() ?? '') ?? 0),
      itemsSubtotal: json['items_subtotal'] is num
          ? json['items_subtotal'] as num
          : (num.tryParse(json['items_subtotal']?.toString() ?? '') ?? 0),
      discountTotal: json['discount_total'] is num
          ? json['discount_total'] as num
          : (num.tryParse(json['discount_total']?.toString() ?? '') ?? 0),
      deliveryFee: json['delivery_fee'] is num
          ? json['delivery_fee'] as num
          : (num.tryParse(json['delivery_fee']?.toString() ?? '') ?? 0),
      total: json['total'] is num
          ? json['total'] as num
          : (num.tryParse(json['total']?.toString() ?? '') ?? 0),
      currency: json['currency']?.toString() ?? 'USD',
      pointsEarned: json['points_earned'] is num
          ? (json['points_earned'] as num).toInt()
          : (int.tryParse(json['points_earned']?.toString() ?? '') ?? 0),
      freeDeliveryIsEnabled: freeDeliveryMap?['is_enabled'] == true,
      freeDeliveryThreshold: threshold,
      freeDeliveryRemaining: remaining,
      freeDeliveryIsQualified: freeDeliveryMap?['qualified'] == true,
      freeDeliveryProgress: progressVal.clamp(0.0, 1.0),
      isOrderable: json['is_orderable'] == true,
    );
  }
}
