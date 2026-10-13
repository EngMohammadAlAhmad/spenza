import 'package:equatable/equatable.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/entities/orders_count_entity.dart';
import 'package:spenza/features/orders/domain/entities/orders_pagination_meta_entity.dart';

class MyOrdersResponseEntity extends Equatable {
  final List<OrderResponseEntity> orders;
  final OrdersCountEntity counts;
  final OrdersPaginationMetaEntity meta;

  const MyOrdersResponseEntity({
    required this.orders,
    required this.counts,
    required this.meta,
  });

  @override
  List<Object?> get props => [orders, counts, meta];
}
