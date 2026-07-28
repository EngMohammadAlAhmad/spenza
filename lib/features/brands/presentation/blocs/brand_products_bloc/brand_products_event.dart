part of 'brand_products_bloc.dart';

sealed class BrandProductsEvent extends Equatable {
  const BrandProductsEvent();

  @override
  List<Object> get props => [];
}

class GetBrandProductsEvent extends BrandProductsEvent {
  final int brandId;
  final bool isRefresh;

  const GetBrandProductsEvent({
    required this.brandId,
    this.isRefresh = false,
  });

  @override
  List<Object> get props => [brandId, isRefresh];
}
