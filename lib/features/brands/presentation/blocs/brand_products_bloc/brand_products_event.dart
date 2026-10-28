part of 'brand_products_bloc.dart';

sealed class BrandProductsEvent extends Equatable {
  const BrandProductsEvent();

  @override
  List<Object?> get props => [];
}

class GetBrandProductsEvent extends BrandProductsEvent {
  final int brandId;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;
  final int? inStock;
  final bool isRefresh;

  const GetBrandProductsEvent({
    required this.brandId,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [brandId, sort, minPrice, maxPrice, inStock, isRefresh];
}
