import 'package:spenza/core/shared/models/product_model.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required super.products,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final productsJson = data['products'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return SearchResultModel(
      products: productsJson
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
    );
  }
}
