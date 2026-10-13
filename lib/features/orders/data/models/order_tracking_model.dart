import 'package:spenza/features/orders/data/models/order_tracking_stage_model.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_entity.dart';

class OrderTrackingModel extends OrderTrackingEntity {
  const OrderTrackingModel({
    required super.status,
    required super.statusLabel,
    required super.message,
    required super.step,
    required super.stepsTotal,
    required super.isCancelled,
    required super.isDelivered,
    required super.isAwaitingPaymentReview,
    super.stages = const [],
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    List<OrderTrackingStageModel> parsedStages = [];
    if (json['stages'] is List) {
      parsedStages = (json['stages'] as List)
          .whereType<Map<String, dynamic>>()
          .map((stageJson) => OrderTrackingStageModel.fromJson(stageJson))
          .toList();
    }

    return OrderTrackingModel(
      status: json['status']?.toString() ?? '',
      statusLabel: json['status_label']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      step: _parseInt(json['step']),
      stepsTotal: _parseInt(json['steps_total']),
      isCancelled: json['is_cancelled'] == true,
      isDelivered: json['is_delivered'] == true,
      isAwaitingPaymentReview: json['is_awaiting_payment_review'] == true,
      stages: parsedStages,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_label': statusLabel,
        'message': message,
        'step': step,
        'steps_total': stepsTotal,
        'is_cancelled': isCancelled,
        'is_delivered': isDelivered,
        'is_awaiting_payment_review': isAwaitingPaymentReview,
        'stages': stages
            .map((s) => (s as OrderTrackingStageModel).toJson())
            .toList(),
      };
}
