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
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return CategoryProductsResultModel(
      category: CategoryModel.fromJson(data['category'] as Map<String, dynamic>),
      children: (data['children'] as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      products: (data['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
    );
  }
}
