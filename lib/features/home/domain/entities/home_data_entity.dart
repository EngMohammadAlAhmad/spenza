import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/features/home/domain/entities/banner_entity.dart';

class HomeDataEntity extends Equatable{
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  final List<ProductEntity> discountedProducts;
  final List<ProductEntity> products;

  const HomeDataEntity({
    required this.banners,
    required this.categories,
    required this.brands,
    required this.discountedProducts,
    required this.products,
  });

  @override
  List<Object?> get props => [banners, categories, brands, discountedProducts, products];
}