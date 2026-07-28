import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/features/brands/data/models/brands_result_model.dart';

import 'package:spenza/features/brands/data/models/brand_products_result_model.dart';

class BrandsDatasource {
  final ApiConsumer api;

  BrandsDatasource({required this.api});

  Future<BrandsResultModel> getBrands({
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      EndPoints.getBrands,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    return BrandsResultModel.fromJson(response);
  }

  Future<BrandProductsResultModel> getBrandProducts({
    required int brandId,
    required int page,
    required int perPage,
  }) async {
    final response = await api.get(
      '${EndPoints.getBrands}/$brandId/products',
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    return BrandProductsResultModel.fromJson(response);
  }
}
