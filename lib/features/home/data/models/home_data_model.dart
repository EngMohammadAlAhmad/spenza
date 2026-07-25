import 'package:spenza/features/home/domain/entities/home_data_entity.dart';
import 'package:spenza/features/home/data/models/banner_model.dart';
import 'package:spenza/core/shared/models/category_model.dart';
import 'package:spenza/core/shared/models/brand_model.dart';
import 'package:spenza/core/shared/models/product_model.dart';

class HomeDataModel extends HomeDataEntity {
  const HomeDataModel({
    required super.banners,
    required super.categories,
    required super.brands,
    required super.discountedProducts,
    required super.products,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract the inner 'data' object. If it doesn't exist, default to empty map.
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return HomeDataModel(
      // 2. Map each list safely. If the list is null/missing, default to []
      banners: (data['banners'] as List<dynamic>?)
          ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      categories: (data['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      brands: (data['brands'] as List<dynamic>?)
          ?.map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      // Note the exact snake_case key matching your JSON
      discountedProducts: (data['discounted_products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],

      products: (data['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'banners': banners.map((e) => (e as BannerModel).toJson()).toList(),
        'categories': categories.map((e) => (e as CategoryModel).toJson()).toList(),
        'brands': brands.map((e) => (e as BrandModel).toJson()).toList(),
        'discounted_products': discountedProducts.map((e) => (e as ProductModel).toJson()).toList(),
        'products': products.map((e) => (e as ProductModel).toJson()).toList(),
      }
    };
  }
}