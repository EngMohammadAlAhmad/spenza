import 'package:equatable/equatable.dart';
import 'package:spenza/features/orders/domain/entities/order_tracking_stage_entity.dart';

class OrderTrackingEntity extends Equatable {
  final String status;
  final String statusLabel;
  final String message;
  final int step;
  final int stepsTotal;
  final bool isCancelled;
  final bool isDelivered;
  final bool isAwaitingPaymentReview;
  final List<OrderTrackingStageEntity> stages;

  const OrderTrackingEntity({
    required this.status,
    required this.statusLabel,
    required this.message,
    required this.step,
    required this.stepsTotal,
    required this.isCancelled,
    required this.isDelivered,
    required this.isAwaitingPaymentReview,
    this.stages = const [],
  });

  @override
  List<Object?> get props => [
        status,
        statusLabel,
        message,
        step,
        stepsTotal,
        isCancelled,
        isDelivered,
        isAwaitingPaymentReview,
        stages,
      ];
}
