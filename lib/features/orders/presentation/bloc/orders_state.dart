import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

class OrdersState extends Equatable {
  final RequestStatus createOrderStatus;
  final Failure createOrderFailure;
  final OrderResponseEntity? createdOrder;

  const OrdersState({
    this.createOrderStatus = RequestStatus.init,
    this.createOrderFailure = defaultFailure,
    this.createdOrder,
  });

  OrdersState copyWith({
    RequestStatus? createOrderStatus,
    Failure? createOrderFailure,
    OrderResponseEntity? createdOrder,
  }) {
    return OrdersState(
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      createOrderFailure: createOrderFailure ?? this.createOrderFailure,
      createdOrder: createdOrder ?? this.createdOrder,
    );
  }

  @override
  List<Object?> get props => [
        createOrderStatus,
        createOrderFailure,
        createdOrder,
      ];
}
