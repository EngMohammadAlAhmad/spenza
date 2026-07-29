part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearchEvent extends SearchEvent {
  final String q;
  final int? categoryId;
  final int? brandId;
  final bool isRefresh;

  const PerformSearchEvent({
    required this.q,
    this.categoryId,
    this.brandId,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [q, categoryId, brandId, isRefresh];
}

class LoadMoreSearchEvent extends SearchEvent {
  const LoadMoreSearchEvent();
}
