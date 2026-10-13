import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/orders/data/datasources/orders_datasource.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDatasource datasource;

  OrdersRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderParams params) async {
    return handleRepositoryCall(() => datasource.createOrder(params));
  }
}
