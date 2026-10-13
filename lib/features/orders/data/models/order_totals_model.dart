import 'package:spenza/features/orders/domain/entities/order_totals_entity.dart';

class OrderTotalsModel extends OrderTotalsEntity {
  const OrderTotalsModel({
    required super.itemsSubtotal,
    required super.discountTotal,
    required super.deliveryFee,
    required super.total,
  });

  factory OrderTotalsModel.fromJson(Map<String, dynamic> json) {
    return OrderTotalsModel(
      itemsSubtotal: _parseNum(json['items_subtotal']),
      discountTotal: _parseNum(json['discount_total']),
      deliveryFee: _parseNum(json['delivery_fee']),
      total: _parseNum(json['total']),
    );
  }

  static num _parseNum(dynamic value) {
    if (value is num) return value;
    if (value is String) return num.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'items_subtotal': itemsSubtotal,
        'discount_total': discountTotal,
        'delivery_fee': deliveryFee,
        'total': total,
      };
}
