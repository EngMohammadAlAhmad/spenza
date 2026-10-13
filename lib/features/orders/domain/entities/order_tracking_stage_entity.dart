import 'package:equatable/equatable.dart';

class OrderTrackingStageEntity extends Equatable {
  final String key;
  final int step;
  final String title;
  final String description;
  final bool isReached;
  final bool isCurrent;

  const OrderTrackingStageEntity({
    required this.key,
    required this.step,
    required this.title,
    required this.description,
    required this.isReached,
    required this.isCurrent,
  });

  @override
  List<Object?> get props => [
        key,
        step,
        title,
        description,
        isReached,
        isCurrent,
      ];
}
