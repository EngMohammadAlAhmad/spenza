import 'package:spenza/core/shared/models/brand_model.dart';
import 'package:spenza/core/shared/models/product_model.dart';
import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';

class BrandProductsResultModel extends BrandProductsResultEntity {
  const BrandProductsResultModel({
    required super.brand,
    required super.products,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  factory BrandProductsResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return BrandProductsResultModel(
      brand: BrandModel.fromJson(data['brand'] as Map<String, dynamic>),
      products: (data['products'] as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: pagination['current_page'] ?? 1,
      lastPage: pagination['last_page'] ?? 1,
      total: pagination['total'] ?? 0,
    );
  }
}
