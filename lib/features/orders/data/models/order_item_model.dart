import 'package:spenza/features/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.unitName,
    required super.variantLabel,
    super.productImage,
    required super.unitPrice,
    required super.quantity,
    required super.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: _parseInt(json['id']),
      productId: _parseInt(json['product_id']),
      productName: json['product_name']?.toString() ?? '',
      unitName: json['unit_name']?.toString() ?? '',
      variantLabel: json['variant_label']?.toString() ?? '',
      productImage: json['product_image']?.toString() ??
          json['image']?.toString() ??
          json['thumb']?.toString(),
      unitPrice: _parseNum(json['unit_price']),
      quantity: _parseInt(json['quantity']),
      lineTotal: _parseNum(json['line_total']),
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
