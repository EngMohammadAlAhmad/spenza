import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/categories/data/models/categories_result_model.dart';

import 'package:spenza/features/categories/data/models/category_products_result_model.dart';

class CategoriesDatasource {
  final ApiConsumer api;

  CategoriesDatasource({required this.api});

  Future<CategoriesResultModel> getCategories({
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      EndPoints.getCategories,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    return CategoriesResultModel.fromJson(response);
  }

  Future<CategoryProductsResultModel> getCategoryProducts({
    required int categoryId,
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      '${EndPoints.getCategories}/$categoryId/products',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    return CategoryProductsResultModel.fromJson(response);
  }
}
