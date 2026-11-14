import 'package:spenza/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.productId,
    super.unitId = 0,
    super.variantId,
    required super.productName,
    required super.unitName,
    required super.variantLabel,
    super.productImage,
    required super.unitPrice,
    required super.quantity,
    required super.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final rawUnitId = json['unit_id'] ??
        json['product_unit_id'] ??
        json['unit']?['id'] ??
        json['product_unit']?['id'] ??
        json['pivot']?['product_unit_id'] ??
        json['pivot']?['unit_id'] ??
        json['item_unit_id'];

    final rawVariantId = json['variant_id'] ??
        json['product_variant_id'] ??
        json['variant']?['id'] ??
        json['product_variant']?['id'] ??
        json['pivot']?['product_variant_id'] ??
        json['pivot']?['variant_id'];

    return OrderItemModel(
      id: _parseInt(json['id']),
      productId: _parseInt(json['product_id'] ?? json['product']?['id']),
      unitId: _parseInt(rawUnitId),
      variantId: rawVariantId != null ? _parseInt(rawVariantId) : null,
      productName: json['product_name']?.toString() ??
          json['product']?['name']?.toString() ??
          json['title']?.toString() ??
          '',
      unitName: json['unit_name']?.toString() ??
          json['unit']?['name']?.toString() ??
          '',
      variantLabel: json['variant_label']?.toString() ??
          json['variant']?['label']?.toString() ??
          '',
      productImage: json['product_image']?.toString() ??
          json['image']?.toString() ??
          json['thumb']?.toString() ??
          json['product']?['image']?.toString() ??
          json['product']?['main_image']?.toString(),
      unitPrice: _parseNum(json['unit_price'] ?? json['price']),
      quantity: _parseInt(json['quantity'] ?? json['qty'] ?? 1),
      lineTotal: _parseNum(json['line_total'] ?? json['total']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'product_name': productName,
        'unit_name': unitName,
        'variant_label': variantLabel,
        'product_image': productImage,
        'unit_price': unitPrice,
        'quantity': quantity,
        'line_total': lineTotal,
      };
}
