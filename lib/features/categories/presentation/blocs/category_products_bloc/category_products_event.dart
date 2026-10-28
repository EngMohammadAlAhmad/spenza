part of 'category_products_bloc.dart';

sealed class CategoryProductsEvent extends Equatable {
  const CategoryProductsEvent();

  @override
  List<Object?> get props => [];
}

class GetCategoryProductsEvent extends CategoryProductsEvent {
  final int categoryId;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;
  final int? inStock;
  final bool isRefresh;

  const GetCategoryProductsEvent({
    required this.categoryId,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [categoryId, sort, minPrice, maxPrice, inStock, isRefresh];
}
