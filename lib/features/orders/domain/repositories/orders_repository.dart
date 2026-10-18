import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';
import 'package:spenza/features/orders/domain/entities/my_orders_response_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_details_entity.dart';
import 'package:spenza/features/orders/domain/entities/order_response_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderResponseEntity>> createOrder(CreateOrderParams params);
  Future<Either<Failure, MyOrdersResponseEntity>> getMyOrders({
    int page = 1,
    int perPage = 15,
    String? type,
  });
  Future<Either<Failure, OrderDetailsEntity>> getOrderByNumber(String orderNumber);
  Future<Either<Failure, void>> uploadTransferReceipt(UploadTransferReceiptParams params);
}
