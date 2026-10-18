import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/data/models/checkout_options_model.dart';

abstract class CartRemoteDataSource {
  Future<CheckoutOptionsModel> getCheckoutOptions(int cityId);
  Future<CartPreviewModel> getCheckoutPreview(CheckoutPreviewParams params);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiConsumer api;

  CartRemoteDataSourceImpl({required this.api});

  @override
  Future<CheckoutOptionsModel> getCheckoutOptions(int cityId) async {
    final response = await api.get(
      EndPoints.checkoutOptions,
      queryParameters: {'city_id': cityId},
    );

    Map<String, dynamic> dataMap = {};
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        dataMap = response['data'] as Map<String, dynamic>;
      } else {
        dataMap = response;
      }
    }

    return CheckoutOptionsModel.fromJson(dataMap);
  }

  @override
  Future<CartPreviewModel> getCheckoutPreview(CheckoutPreviewParams params) async {
    final response = await api.post(
      EndPoints.checkoutPreview,
      data: params.toJson(),
    );

    Map<String, dynamic> dataMap = {};
    if (response is Map<String, dynamic>) {
      if (response['data'] is Map<String, dynamic>) {
        dataMap = response['data'] as Map<String, dynamic>;
      } else {
        dataMap = response;
      }
    }

    return CartPreviewModel.fromJson(dataMap);
  }
}
