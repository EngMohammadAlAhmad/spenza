import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/orders/domain/usecases/create_order_use_case.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_event.dart';
import 'package:spenza/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CreateOrderUseCase createOrderUseCase;

  OrdersBloc({
    required this.createOrderUseCase,
  }) : super(const OrdersState()) {
    on<CreateOrderEvent>(_onCreateOrder);
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
}
