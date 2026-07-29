import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';
import 'package:spenza/features/categories/domain/usecases/get_category_products_use_case.dart';

import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/usecases/search_products_use_case.dart';

part 'category_products_event.dart';

class CategoryProductsBloc extends Bloc<CategoryProductsEvent, BaseState<CategoryProductsResultEntity>> {
  final GetCategoryProductsUseCase getCategoryProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  CategoryProductsBloc({
    required this.getCategoryProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(const BaseState<CategoryProductsResultEntity>()) {
    on<GetCategoryProductsEvent>(
      _onGetCategoryProducts,
      transformer: droppable(),
    );
  }

  Future<void> _onGetCategoryProducts(
    GetCategoryProductsEvent event,
    Emitter<BaseState<CategoryProductsResultEntity>> emit,
  ) async {
    final bool isNewCategory = state.data?.category.id != event.categoryId;
    final bool isNewSort = state.sort != event.sort;

    if (event.isRefresh || isNewCategory || isNewSort) {
      emit(BaseState<CategoryProductsResultEntity>(
        requestStatus: RequestStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
        data: isNewCategory ? null : state.data,
        sort: event.sort,
      ));
    } else {
      if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading) return;
      emit(state.copyWith(requestStatus: RequestStatus.loading));
    }

    final Either<dynamic, dynamic> result;

    if (event.sort != null && event.sort != 'newest') {
      result = await searchProductsUseCase.call(SearchParams(
        categoryId: event.categoryId,
        sort: event.sort,
        page: state.currentPage,
        perPage: 20,
      ));
    } else {
      result = await getCategoryProductsUseCase.call(
        categoryId: event.categoryId,
        page: state.currentPage,
        perPage: 20,
      );
    }

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (resultData) {
        final List<ProductEntity> products = resultData.products;
        final currentProducts = (isNewCategory || event.isRefresh || isNewSort) ? <ProductEntity>[] : (state.data?.products ?? <ProductEntity>[]);
        final List<ProductEntity> updatedProducts = [...currentProducts, ...products];

        final updatedResult = CategoryProductsResultEntity(
          category: (resultData is CategoryProductsResultEntity) ? resultData.category : state.data!.category,
          children: (resultData is CategoryProductsResultEntity)
              ? (resultData.children.isEmpty && state.data != null ? state.data!.children : resultData.children)
              : (state.data?.children ?? []),
          products: updatedProducts,
          currentPage: resultData.currentPage,
          lastPage: resultData.lastPage,
          total: resultData.total,
        );

        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          data: updatedResult,
          currentPage: resultData.currentPage + 1,
          hasReachedMax: resultData.currentPage >= resultData.lastPage,
          sort: event.sort,
        ));
      },
    );
  }
}
