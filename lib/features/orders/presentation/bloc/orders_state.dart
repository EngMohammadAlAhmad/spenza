import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/entities/orders_count_entity.dart';
import 'package:spenza/features/orders/domain/entities/orders_pagination_meta_entity.dart';

class OrdersState extends Equatable {
  final RequestStatus createOrderStatus;
  final Failure createOrderFailure;
  final OrderResponseEntity? createdOrder;

  final RequestStatus getMyOrdersStatus;
  final Failure getMyOrdersFailure;
  final List<OrderResponseEntity> orders;
  final OrdersCountEntity counts;
  final OrdersPaginationMetaEntity? meta;
  final int selectedTabIndex;
  final bool isLoadingMore;
  final bool hasMore;

  final RequestStatus getOrderDetailsStatus;
  final Failure getOrderDetailsFailure;
  final OrderDetailsEntity? orderDetails;

  const OrdersState({
    this.createOrderStatus = RequestStatus.init,
    this.createOrderFailure = defaultFailure,
    this.createdOrder,
    this.getMyOrdersStatus = RequestStatus.init,
    this.getMyOrdersFailure = defaultFailure,
    this.orders = const [],
    this.counts = const OrdersCountEntity(total: 0, active: 0, completed: 0),
    this.meta,
    this.selectedTabIndex = 0,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.getOrderDetailsStatus = RequestStatus.init,
    this.getOrderDetailsFailure = defaultFailure,
    this.orderDetails,
  });

  List<OrderResponseEntity> get activeOrders =>
      orders.where((o) => !o.isCompleted).toList();

  List<OrderResponseEntity> get completedOrders =>
      orders.where((o) => o.isCompleted).toList();

  List<OrderResponseEntity> get currentTabOrders =>
      selectedTabIndex == 0 ? activeOrders : completedOrders;

  int get activeCount =>
      counts.active > 0 ? counts.active : activeOrders.length;

  int get completedCount =>
      counts.completed > 0 ? counts.completed : completedOrders.length;

  OrdersState copyWith({
    RequestStatus? createOrderStatus,
    Failure? createOrderFailure,
    OrderResponseEntity? createdOrder,
    RequestStatus? getMyOrdersStatus,
    Failure? getMyOrdersFailure,
    List<OrderResponseEntity>? orders,
    OrdersCountEntity? counts,
    OrdersPaginationMetaEntity? meta,
    int? selectedTabIndex,
    bool? isLoadingMore,
    bool? hasMore,
    RequestStatus? getOrderDetailsStatus,
    Failure? getOrderDetailsFailure,
    OrderDetailsEntity? orderDetails,
  }) {
    return OrdersState(
      createOrderStatus: createOrderStatus ?? this.createOrderStatus,
      createOrderFailure: createOrderFailure ?? this.createOrderFailure,
      createdOrder: createdOrder ?? this.createdOrder,
      getMyOrdersStatus: getMyOrdersStatus ?? this.getMyOrdersStatus,
      getMyOrdersFailure: getMyOrdersFailure ?? this.getMyOrdersFailure,
      orders: orders ?? this.orders,
      counts: counts ?? this.counts,
      meta: meta ?? this.meta,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      getOrderDetailsStatus: getOrderDetailsStatus ?? this.getOrderDetailsStatus,
      getOrderDetailsFailure: getOrderDetailsFailure ?? this.getOrderDetailsFailure,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  @override
  List<Object?> get props => [
        createOrderStatus,
        createOrderFailure,
        createdOrder,
        getMyOrdersStatus,
        getMyOrdersFailure,
        orders,
        counts,
        meta,
        selectedTabIndex,
        isLoadingMore,
        hasMore,
        getOrderDetailsStatus,
        getOrderDetailsFailure,
        orderDetails,
      ];
}
