import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';
import 'package:spenza/features/search/domain/usecases/search_products_use_case.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

part 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, BaseState<SearchResultEntity>> {
  final SearchProductsUseCase searchProductsUseCase;

  String? _lastQuery;
  int? _lastCategoryId;
  int? _lastBrandId;
  String? _lastSort;

  SearchBloc({required this.searchProductsUseCase})
      : super(const BaseState<SearchResultEntity>()) {
    on<PerformSearchEvent>(
      _onPerformSearch,
      transformer: restartable(),
    );
    on<LoadMoreSearchEvent>(
      _onLoadMore,
      transformer: droppable(),
    );
  }

  Future<void> _onPerformSearch(
    PerformSearchEvent event,
    Emitter<BaseState<SearchResultEntity>> emit,
  ) async {
    _lastQuery = event.q;
    _lastCategoryId = event.categoryId;
    _lastBrandId = event.brandId;
    _lastSort = event.sort;

    emit(const BaseState<SearchResultEntity>(requestStatus: RequestStatus.loading));

    final result = await searchProductsUseCase.call(SearchParams(
      q: event.q,
      categoryId: event.categoryId,
      brandId: event.brandId,
      sort: event.sort,
      page: 1,
      perPage: 20,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (searchResult) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        data: searchResult,
        currentPage: 2,
        hasReachedMax: 1 >= searchResult.lastPage,
      )),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreSearchEvent event,
    Emitter<BaseState<SearchResultEntity>> emit,
  ) async {
    if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading || (_lastQuery == null && _lastCategoryId == null && _lastBrandId == null)) return;

    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await searchProductsUseCase.call(SearchParams(
      q: _lastQuery,
      categoryId: _lastCategoryId,
      brandId: _lastBrandId,
      sort: _lastSort,
      page: state.currentPage,
      perPage: 20,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (searchResult) {
        final List<ProductEntity> updatedProducts = List.of(state.data?.products ?? [])
          ..addAll(searchResult.products);

        final updatedResult = SearchResultEntity(
          products: updatedProducts,
          currentPage: searchResult.currentPage,
          lastPage: searchResult.lastPage,
          total: searchResult.total,
        );

        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          data: updatedResult,
          currentPage: state.currentPage + 1,
          hasReachedMax: state.currentPage >= searchResult.lastPage,
        ));
      },
    );
  }
}
