import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderParams params);
}
