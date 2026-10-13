import 'package:equatable/equatable.dart';

class OrdersCountEntity extends Equatable {
  final int total;
  final int active;
  final int completed;

  const OrdersCountEntity({
    required this.total,
    required this.active,
    required this.completed,
  });

  @override
  List<Object?> get props => [total, active, completed];
}
