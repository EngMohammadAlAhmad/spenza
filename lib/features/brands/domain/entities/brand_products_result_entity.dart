import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

class BrandProductsResultEntity extends Equatable {
  final BrandEntity brand;
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;
  final int total;

  const BrandProductsResultEntity({
    required this.brand,
    required this.products,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [brand, products, currentPage, lastPage, total];
}
