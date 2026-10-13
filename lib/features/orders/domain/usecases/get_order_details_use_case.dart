import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  final OrdersRepository repository;

  GetOrderDetailsUseCase({required this.repository});

  Future<Either<Failure, OrderDetailsEntity>> call(String orderNumber) async {
    return await repository.getOrderByNumber(orderNumber);
  }
}
