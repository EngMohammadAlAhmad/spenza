import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository repository;

  CreateOrderUseCase({required this.repository});

  Future<Either<Failure, OrderResponseEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(params);
  }
}
