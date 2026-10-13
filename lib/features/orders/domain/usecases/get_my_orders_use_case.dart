import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/domain/entities/my_orders_response_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class GetMyOrdersUseCase {
  final OrdersRepository repository;

  GetMyOrdersUseCase({required this.repository});

  Future<Either<Failure, MyOrdersResponseEntity>> call({
    int page = 1,
    int perPage = 15,
    String? type,
  }) async {
    return await repository.getMyOrders(
      page: page,
      perPage: perPage,
      type: type,
    );
  }
}
