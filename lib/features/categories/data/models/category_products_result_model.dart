import 'package:spenza/core/shared/models/category_model.dart';
import 'package:spenza/core/shared/models/product_model.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';

class CategoryProductsResultModel extends CategoryProductsResultEntity {
  const CategoryProductsResultModel({
    required super.category,
    required super.children,
    required super.products,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory CategoryProductsResultModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final pagination = (data['pagination'] is Map<String, dynamic>)
        ? data['pagination'] as Map<String, dynamic>
        : (data['meta'] is Map<String, dynamic>
            ? data['meta'] as Map<String, dynamic>
            : (json['pagination'] is Map<String, dynamic>
                ? json['pagination'] as Map<String, dynamic>
                : <String, dynamic>{}));

    final productsList = (data['products'] is List)
        ? (data['products'] as List)
        : (data['data'] is List
            ? (data['data'] as List)
            : (json['products'] is List ? (json['products'] as List) : []));

    final int rawTotal = _parseInt(
      pagination['total'] ?? data['total'] ?? json['total'] ?? productsList.length,
    );

    return CategoryProductsResultModel(
      category: data['category'] != null && data['category'] is Map<String, dynamic>
          ? CategoryModel.fromJson(data['category'] as Map<String, dynamic>)
          : CategoryModel(
              id: _parseInt(data['id'] ?? json['id']),
              name: (data['name'] ?? json['name'] ?? '').toString(),
              image: '',
              productsCount: productsList.length,
            ),
      children: (data['children'] is List)
          ? (data['children'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      products: productsList
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: _parseInt(pagination['current_page'] ?? data['current_page'] ?? 1),
      lastPage: _parseInt(pagination['last_page'] ?? data['last_page'] ?? 1),
      total: rawTotal > 0 ? rawTotal : productsList.length,
    );
  }

  static int _parseInt(dynamic val) {
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val) ?? 0;
    return 0;
  }
}
