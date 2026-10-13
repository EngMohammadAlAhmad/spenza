import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/orders/data/models/create_order_params.dart';
import 'package:spenza/features/orders/data/models/my_orders_response_model.dart';
import 'package:spenza/features/orders/data/models/order_details_model.dart';
import 'package:spenza/features/orders/data/models/order_response_model.dart';

abstract class OrdersDatasource {
  Future<OrderResponseModel> createOrder(CreateOrderParams params);
  Future<MyOrdersResponseModel> getMyOrders({
    int page = 1,
    int perPage = 15,
    String? type,
  });
  Future<OrderDetailsModel> getOrderByNumber(String orderNumber);
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
}
