import 'package:spenza/features/orders/domain/entities/order_delivery_entity.dart';

class OrderDeliveryModel extends OrderDeliveryEntity {
  const OrderDeliveryModel({
    required super.method,
    required super.methodLabel,
    required super.description,
    required super.etaHours,
    required super.etaLabel,
    required super.fee,
  });

  factory OrderDeliveryModel.fromJson(Map<String, dynamic> json) {
    return OrderDeliveryModel(
      method: json['method']?.toString() ?? '',
      methodLabel: json['method_label']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      etaHours: _parseInt(json['eta_hours']),
      etaLabel: json['eta_label']?.toString() ?? '',
      fee: _parseNum(json['fee']),
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
        'method': method,
        'method_label': methodLabel,
        'description': description,
        'eta_hours': etaHours,
        'eta_label': etaLabel,
        'fee': fee,
      };
}
