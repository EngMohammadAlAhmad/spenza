import 'package:spenza/features/orders/domain/entities/order_tracking_stage_entity.dart';

class OrderTrackingStageModel extends OrderTrackingStageEntity {
  const OrderTrackingStageModel({
    required super.key,
    required super.step,
    required super.title,
    required super.description,
    required super.isReached,
    required super.isCurrent,
  });

  factory OrderTrackingStageModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingStageModel(
      key: json['key']?.toString() ?? '',
      step: _parseInt(json['step']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      isReached: json['is_reached'] == true,
      isCurrent: json['is_current'] == true,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'step': step,
        'title': title,
        'description': description,
        'is_reached': isReached,
        'is_current': isCurrent,
      };
}
