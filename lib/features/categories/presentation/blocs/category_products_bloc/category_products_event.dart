part of 'category_products_bloc.dart';

sealed class CategoryProductsEvent extends Equatable {
  const CategoryProductsEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryProductsEvent extends CategoryProductsEvent {
  final int categoryId;
  final bool isRefresh;

  const GetCategoryProductsEvent({
    required this.categoryId,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [categoryId, isRefresh];
}
