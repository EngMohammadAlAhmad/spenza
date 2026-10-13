import 'package:spenza/features/orders/domain/entities/orders_count_entity.dart';

class OrdersCountModel extends OrdersCountEntity {
  const OrdersCountModel({
    required super.total,
    required super.active,
    required super.completed,
  });

  factory OrdersCountModel.fromJson(Map<String, dynamic> json) {
    return OrdersCountModel(
      total: _parseInt(json['total']),
      active: _parseInt(json['active']),
      completed: _parseInt(json['completed']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'active': active,
        'completed': completed,
      };
}
