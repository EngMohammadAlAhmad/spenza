import 'package:equatable/equatable.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

class CategoryProductsResultEntity extends Equatable {
  final CategoryEntity category;
  final List<CategoryEntity> children;
  final List<ProductEntity> products;
  final int currentPage;
  final int lastPage;
  final int total;

  const CategoryProductsResultEntity({
    required this.category,
    required this.children,
    required this.products,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  @override
  List<Object?> get props => [category, children, products, currentPage, lastPage, total];
}
