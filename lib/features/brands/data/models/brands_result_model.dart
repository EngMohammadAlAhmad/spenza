import 'package:spenza/core/shared/models/brand_model.dart';
import 'package:spenza/features/brands/domain/entities/brands_result_entity.dart';

class BrandsResultModel extends BrandsResultEntity {
  const BrandsResultModel({
    required super.brands,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory BrandsResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final brandsJson = data['brands'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return BrandsResultModel(
      brands: brandsJson
          .map((item) => BrandModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
    );
  }
}
