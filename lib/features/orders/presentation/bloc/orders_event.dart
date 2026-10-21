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

class GetMyOrdersEvent extends OrdersEvent {
  final int page;
  final bool isRefresh;
  final String? type;

  const GetMyOrdersEvent({
    this.page = 1,
    this.isRefresh = false,
    this.type,
  });

  @override
  List<Object?> get props => [page, isRefresh, type];
}

class LoadMoreOrdersEvent extends OrdersEvent {
  final String? type;

  const LoadMoreOrdersEvent({this.type});

  @override
  List<Object?> get props => [type];
}

class ChangeOrdersTabEvent extends OrdersEvent {
  final int tabIndex;

  const ChangeOrdersTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class GetOrderDetailsEvent extends OrdersEvent {
  final String orderNumber;

  const GetOrderDetailsEvent(this.orderNumber);

  @override
  List<Object?> get props => [orderNumber];
}

class ReorderOrderEvent extends OrdersEvent {
  final String orderNumber;

  const ReorderOrderEvent(this.orderNumber);

  @override
  List<Object?> get props => [orderNumber];
}
