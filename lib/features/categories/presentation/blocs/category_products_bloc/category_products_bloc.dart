import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';
import 'package:spenza/features/categories/domain/usecases/get_category_products_use_case.dart';

part 'category_products_event.dart';

class CategoryProductsBloc extends Bloc<CategoryProductsEvent, BaseState<CategoryProductsResultEntity>> {
  final GetCategoryProductsUseCase getCategoryProductsUseCase;

  CategoryProductsBloc({required this.getCategoryProductsUseCase})
      : super(const BaseState<CategoryProductsResultEntity>()) {
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

    if (event.isRefresh || isNewCategory) {
      emit(BaseState<CategoryProductsResultEntity>(
        requestStatus: RequestStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
        data: null,
      ));
    } else {
      if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading) return;
      emit(state.copyWith(requestStatus: RequestStatus.loading));
    }

    final result = await getCategoryProductsUseCase.call(
      categoryId: event.categoryId,
      page: state.currentPage,
      perPage: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (resultEntity) {
        final currentProducts = state.data?.products ?? [];
        final updatedProducts = isNewCategory || event.isRefresh
            ? resultEntity.products
            : [...currentProducts, ...resultEntity.products];

        final updatedResult = CategoryProductsResultEntity(
          category: resultEntity.category,
          children: resultEntity.children.isEmpty && state.data != null && !isNewCategory && !event.isRefresh
              ? state.data!.children
              : resultEntity.children, // Keep children from first load if subsequent pages don't return them (though API usually does for first page)
          products: updatedProducts,
          currentPage: resultEntity.currentPage,
          lastPage: resultEntity.lastPage,
          total: resultEntity.total,
        );

        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          data: updatedResult,
          currentPage: resultEntity.currentPage + 1,
          hasReachedMax: resultEntity.currentPage >= resultEntity.lastPage,
        ));
      },
    );
  }
}
