part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearchEvent extends SearchEvent {
  final String? q;
  final int? categoryId;
  final int? brandId;
  final String? sort;
  final double? minPrice;
  final double? maxPrice;
  final int? inStock;
  final bool isRefresh;

  const PerformSearchEvent({
    this.q,
    this.categoryId,
    this.brandId,
    this.sort,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.isRefresh = false,
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
        isRefresh,
      ];
}

class LoadMoreSearchEvent extends SearchEvent {
  const LoadMoreSearchEvent();
}
