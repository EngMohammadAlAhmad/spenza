import 'package:spenza/features/orders/data/models/order_response_model.dart';
import 'package:spenza/features/orders/data/models/orders_count_model.dart';
import 'package:spenza/features/orders/data/models/orders_pagination_meta_model.dart';
import 'package:spenza/features/orders/domain/entities/my_orders_response_entity.dart';

class MyOrdersResponseModel extends MyOrdersResponseEntity {
  const MyOrdersResponseModel({
    required super.orders,
    required super.counts,
    required super.meta,
  });

  factory MyOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> data = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      data = json['data'] as Map<String, dynamic>;
    }

    final rawOrders = data['orders'];
    List<OrderResponseModel> ordersList = [];
    if (rawOrders is List) {
      ordersList = rawOrders
          .whereType<Map<String, dynamic>>()
          .map((item) => OrderResponseModel.fromJson(item))
          .toList();
    }

    OrdersCountModel countsModel;
    if (data['counts'] is Map<String, dynamic>) {
      countsModel = OrdersCountModel.fromJson(data['counts'] as Map<String, dynamic>);
    } else {
      final activeCount = ordersList.where((o) => !o.isCompleted).length;
      final completedCount = ordersList.where((o) => o.isCompleted).length;
      countsModel = OrdersCountModel(
        total: ordersList.length,
        active: activeCount,
        completed: completedCount,
      );
    }

    OrdersPaginationMetaModel metaModel;
    if (data['meta'] is Map<String, dynamic>) {
      metaModel = OrdersPaginationMetaModel.fromJson(data['meta'] as Map<String, dynamic>);
    } else {
      metaModel = OrdersPaginationMetaModel(
        currentPage: 1,
        lastPage: 1,
        perPage: ordersList.isNotEmpty ? ordersList.length : 15,
        total: ordersList.length,
      );
    }

    return MyOrdersResponseModel(
      orders: ordersList,
      counts: countsModel,
      meta: metaModel,
    );
  }
}
