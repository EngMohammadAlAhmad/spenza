import 'package:dio/dio.dart';
import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/data/models/my_orders_response_model.dart';
import 'package:spenza/features/orders/data/models/order_details_model.dart';
import 'package:spenza/features/orders/data/models/order_response_model.dart';
import 'package:spenza/features/orders/data/models/upload_transfer_receipt_params.dart';

abstract class OrdersDatasource {
  Future<OrderResponseModel> createOrder(CreateOrderParams params);
  Future<MyOrdersResponseModel> getMyOrders({
    int page = 1,
    int perPage = 15,
    String? type,
  });
  Future<OrderDetailsModel> getOrderByNumber(String orderNumber);
  Future<void> uploadTransferReceipt(UploadTransferReceiptParams params);
  Future<OrderResponseModel> reorder(String orderNumber);
}

class OrdersDatasourceImpl implements OrdersDatasource {
  final ApiConsumer api;

  OrdersDatasourceImpl({required this.api});

  @override
  Future<OrderResponseModel> createOrder(CreateOrderParams params) async {
    final response = await api.post(EndPoints.createOrder, data: params.toJson());

    Map<String, dynamic> orderJson = {};
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        orderJson = data;
      } else {
        orderJson = response;
      }
    }

    return OrderResponseModel.fromJson(orderJson);
  }

  @override
  Future<MyOrdersResponseModel> getMyOrders({
    int page = 1,
    int perPage = 15,
    String? type,
  }) async {
    final Map<String, dynamic> queryParameters = {
      'page': page,
      'per_page': perPage,
    };
    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }

    final response = await api.get(
      EndPoints.getMyOrders,
      queryParameters: queryParameters,
    );

    return MyOrdersResponseModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<OrderDetailsModel> getOrderByNumber(String orderNumber) async {
    final response = await api.get(
      '${EndPoints.createOrder}/$orderNumber',
    );

    return OrderDetailsModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> uploadTransferReceipt(UploadTransferReceiptParams params) async {
    final fileName = params.image.path.split('/').last;
    final Map<String, dynamic> mapData = {
      'image': await MultipartFile.fromFile(
        params.image.path,
        filename: fileName,
      ),
    };

    if (params.reference != null && params.reference!.isNotEmpty) {
      mapData['reference'] = params.reference;
    }
    if (params.amount != null && params.amount!.isNotEmpty) {
      mapData['amount'] = params.amount;
    }
    if (params.transferredAt != null && params.transferredAt!.isNotEmpty) {
      mapData['transferred_at'] = params.transferredAt;
    }
    if (params.note != null && params.note!.isNotEmpty) {
      mapData['note'] = params.note;
    }

    await api.post(
      '${EndPoints.createOrder}/${params.orderNumber}/transfer-receipt',
      data: mapData,
      isFormData: true,
    );
  }

  @override
  Future<OrderResponseModel> reorder(String orderNumber) async {
    final response = await api.post(
      '${EndPoints.createOrder}/$orderNumber/reorder',
    );

    Map<String, dynamic> orderJson = {};
    if (response is Map<String, dynamic>) {
      final data = response['data'];
      if (data is Map<String, dynamic>) {
        orderJson = data;
      } else {
        orderJson = response;
      }
    }

    return OrderResponseModel.fromJson(orderJson);
  }
}
