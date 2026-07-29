import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/features/search/data/models/search_result_model.dart';
import 'package:spenza/features/search/domain/entities/search_params.dart';

class SearchDatasource {
  final ApiConsumer api;

  SearchDatasource({required this.api});

  Future<SearchResultModel> searchProducts(SearchParams params) async {
    final response = await api.get(
      '/api/products/search',
      queryParameters: {
        'q': params.q,
        'category_id': params.categoryId,
        'brand_id': params.brandId,
        'page': params.page,
        'per_page': params.perPage,
      },
    );

    return SearchResultModel.fromJson(response);
  }
}
