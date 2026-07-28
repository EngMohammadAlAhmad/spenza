import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';
import 'package:spenza/features/brands/domain/usecases/get_brand_products_use_case.dart';

part 'brand_products_event.dart';

class BrandProductsBloc extends Bloc<BrandProductsEvent, BaseState<BrandProductsResultEntity>> {
  final GetBrandProductsUseCase getBrandProductsUseCase;

  BrandProductsBloc({required this.getBrandProductsUseCase})
      : super(const BaseState<BrandProductsResultEntity>()) {
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

    if (event.isRefresh || isNewBrand) {
      emit(BaseState<BrandProductsResultEntity>(
        requestStatus: RequestStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
        data: null,
      ));
    } else {
      if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading) return;
      emit(state.copyWith(requestStatus: RequestStatus.loading));
    }

    final result = await getBrandProductsUseCase.call(
      brandId: event.brandId,
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
        final updatedProducts = isNewBrand || event.isRefresh
            ? resultEntity.products
            : [...currentProducts, ...resultEntity.products];

        final updatedResult = BrandProductsResultEntity(
          brand: resultEntity.brand,
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
