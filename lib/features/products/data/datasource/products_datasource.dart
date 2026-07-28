import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/features/products/data/models/product_details_model.dart';

class ProductsDatasource {
  final ApiConsumer api;

  ProductsDatasource({required this.api});

  Future<ProductDetailsModel> getProductDetails({required int productId}) async {
    final response = await api.get(
      '/api/products/$productId',
      queryParameters: {
        'related_limit': 10,
      },
    );
    return ProductDetailsModel.fromJson(response);
  }
}
