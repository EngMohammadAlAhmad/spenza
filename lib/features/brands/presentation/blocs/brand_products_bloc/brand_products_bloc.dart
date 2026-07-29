import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';
import 'package:spenza/features/brands/domain/usecases/get_brand_products_use_case.dart';

import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/usecases/search_products_use_case.dart';

part 'brand_products_event.dart';

class BrandProductsBloc extends Bloc<BrandProductsEvent, BaseState<BrandProductsResultEntity>> {
  final GetBrandProductsUseCase getBrandProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;

  BrandProductsBloc({
    required this.getBrandProductsUseCase,
    required this.searchProductsUseCase,
  }) : super(const BaseState<BrandProductsResultEntity>()) {
    on<GetBrandProductsEvent>(
      _onGetBrandProducts,
      transformer: droppable(),
    );
  }

  Future<void> _onGetBrandProducts(
    GetBrandProductsEvent event,
    Emitter<BaseState<BrandProductsResultEntity>> emit,
  ) async {
    final bool isNewBrand = state.data?.brand.id != event.brandId;
    final bool isNewSort = state.sort != event.sort;

    if (event.isRefresh || isNewBrand || isNewSort) {
      emit(BaseState<BrandProductsResultEntity>(
        requestStatus: RequestStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
        data: isNewBrand ? null : state.data,
        sort: event.sort,
      ));
    } else {
      if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading) return;
      emit(state.copyWith(requestStatus: RequestStatus.loading));
    }

    final Either<dynamic, dynamic> result;

    if (event.sort != null && event.sort != 'newest') {
      result = await searchProductsUseCase.call(SearchParams(
        brandId: event.brandId,
        sort: event.sort,
        page: state.currentPage,
        perPage: 20,
      ));
    } else {
      result = await getBrandProductsUseCase.call(
        brandId: event.brandId,
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
        final currentProducts = (isNewBrand || event.isRefresh || isNewSort) ? <ProductEntity>[] : (state.data?.products ?? <ProductEntity>[]);
        final List<ProductEntity> updatedProducts = [...currentProducts, ...products];

        final updatedResult = BrandProductsResultEntity(
          brand: (resultData is BrandProductsResultEntity) ? resultData.brand : state.data!.brand,
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
