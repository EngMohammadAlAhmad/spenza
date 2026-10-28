import 'package:equatable/equatable.dart';

class SearchParams extends Equatable {
  final String? q;
  final int? categoryId;
  final int? brandId;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;
  final int? inStock;
  final int page;
  final int perPage;

  const SearchParams({
    this.q,
    this.categoryId,
    this.brandId,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.page = 1,
    this.perPage = 20,
  });

  @override
  List<Object?> get props => [
        q,
        categoryId,
        brandId,
        sort,
        minPrice,
        maxPrice,
        inStock,
        page,
        perPage,
      ];
}
