import 'package:spenza/core/shared/models/category_model.dart';
import 'package:spenza/features/categories/domain/entities/categories_result_entity.dart';

class CategoriesResultModel extends CategoriesResultEntity {
  const CategoriesResultModel({
    required super.categories,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory CategoriesResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final categoriesJson = data['categories'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return CategoriesResultModel(
      categories: categoriesJson
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
    );
  }
}
