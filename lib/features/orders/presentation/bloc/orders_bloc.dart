import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:spenza/features/orders/domain/usecases/get_my_orders_use_case.dart';
import 'package:spenza/features/orders/domain/usecases/get_order_details_use_case.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetMyOrdersUseCase getMyOrdersUseCase;
  final GetOrderDetailsUseCase getOrderDetailsUseCase;

  OrdersBloc({
    required this.createOrderUseCase,
    required this.getMyOrdersUseCase,
    required this.getOrderDetailsUseCase,
  }) : super(const OrdersState()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetMyOrdersEvent>(_onGetMyOrders);
    on<LoadMoreOrdersEvent>(_onLoadMoreOrders);
    on<ChangeOrdersTabEvent>(_onChangeOrdersTab);
    on<GetOrderDetailsEvent>(_onGetOrderDetails);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(
      createOrderStatus: RequestStatus.loading,
      createdOrder: null,
    ));

    final result = await createOrderUseCase(event.params);

    result.fold(
      (failure) => emit(state.copyWith(
        createOrderStatus: RequestStatus.error,
        createOrderFailure: failure,
      )),
      (order) => emit(state.copyWith(
        createOrderStatus: RequestStatus.success,
        createdOrder: order,
      )),
    );
  }

  Future<void> _onGetMyOrders(
    GetMyOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(state.copyWith(getMyOrdersStatus: RequestStatus.loading));
    }

    final result = await getMyOrdersUseCase(
      page: event.page,
      type: event.type,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        getMyOrdersStatus: RequestStatus.error,
        getMyOrdersFailure: failure,
      )),
      (data) {
        final hasMore = data.meta.currentPage < data.meta.lastPage;
        emit(state.copyWith(
          getMyOrdersStatus: RequestStatus.success,
          orders: data.orders,
          counts: data.counts,
          meta: data.meta,
          hasMore: hasMore,
        ));
      },
    );
  }

  Future<void> _onLoadMoreOrders(
    LoadMoreOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore || state.meta == null) return;

    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.meta!.currentPage + 1;
    final result = await getMyOrdersUseCase(
      page: nextPage,
      type: event.type,
    );

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false)),
      (data) {
        final updatedOrders = List.of(state.orders)..addAll(data.orders);
        final hasMore = data.meta.currentPage < data.meta.lastPage;

        emit(state.copyWith(
          isLoadingMore: false,
          orders: updatedOrders,
          counts: data.counts,
          meta: data.meta,
          hasMore: hasMore,
        ));
      },
    );
  }

  void _onChangeOrdersTab(
    ChangeOrdersTabEvent event,
    Emitter<OrdersState> emit,
  ) {
    emit(state.copyWith(selectedTabIndex: event.tabIndex));
  }

  Future<void> _onGetOrderDetails(
    GetOrderDetailsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(
      getOrderDetailsStatus: RequestStatus.loading,
      orderDetails: null,
    ));

    final result = await getOrderDetailsUseCase(event.orderNumber);

    result.fold(
      (failure) => emit(state.copyWith(
        getOrderDetailsStatus: RequestStatus.error,
        getOrderDetailsFailure: failure,
      )),
      (data) => emit(state.copyWith(
        getOrderDetailsStatus: RequestStatus.success,
        orderDetails: data,
      )),
    );
  }
}
