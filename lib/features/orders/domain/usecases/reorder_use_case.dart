import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class ReorderUseCase {
  final OrdersRepository repository;

  ReorderUseCase({required this.repository});

  Future<Either<Failure, OrderResponseEntity>> call(String orderNumber) {
    return repository.reorder(orderNumber);
  }
}
