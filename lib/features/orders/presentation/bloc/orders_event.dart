import 'package:equatable/equatable.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrdersEvent {
  final CreateOrderParams params;

  const CreateOrderEvent(this.params);

  @override
  List<Object?> get props => [params];
}
