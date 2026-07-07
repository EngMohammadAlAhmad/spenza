import 'package:equatable/equatable.dart';

class UpdateOrderStatusParams extends Equatable {
  final int orderId;
  final int restaurantId;
  final String sortDirection;
  final String newStatus;

  const UpdateOrderStatusParams({
    required this.orderId,
    required this.restaurantId,
    required this.sortDirection,
    required this.newStatus,
  });

  Map<String, dynamic> toJson() {
    final map = {
      "order_id": orderId,
      "newstatus": newStatus,
    };
    return map;
  }

  @override
  List<Object?> get props => [orderId, newStatus, restaurantId, sortDirection];
}
