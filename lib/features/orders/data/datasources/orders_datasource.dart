import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/data/models/order_response_model.dart';

abstract class OrdersDatasource {
  Future<OrderResponseModel> createOrder(CreateOrderParams params);
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
}
