import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/orders/data/datasources/orders_datasource.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';
import 'package:spenza/features/orders/domain/entities/my_orders_response_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';
import 'package:spenza/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersDatasource datasource;

  OrdersRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderParams params) async {
    return handleRepositoryCall(() => datasource.createOrder(params));
  }

  @override
  Future<Either<Failure, MyOrdersResponseEntity>> getMyOrders({
    int page = 1,
    int perPage = 15,
    String? type,
  }) async {
    return handleRepositoryCall(() => datasource.getMyOrders(
          page: page,
          perPage: perPage,
          type: type,
        ));
  }

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderByNumber(String orderNumber) async {
    return handleRepositoryCall(() => datasource.getOrderByNumber(orderNumber));
  }

  @override
  Future<Either<Failure, void>> uploadTransferReceipt(UploadTransferReceiptParams params) async {
    return handleRepositoryCall(() => datasource.uploadTransferReceipt(params));
  }

  @override
  Future<Either<Failure, OrderResponseEntity>> reorder(String orderNumber) async {
    return handleRepositoryCall(() => datasource.reorder(orderNumber));
  }
}
