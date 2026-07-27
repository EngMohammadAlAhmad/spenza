import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/shared/entities/brand_entity.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/brands/domain/usecases/get_brands_use_case.dart';

part 'brands_event.dart';

class BrandsBloc extends Bloc<BrandsEvent, BaseState<List<BrandEntity>>> {
  final GetBrandsUseCase getBrandsUseCase;

  BrandsBloc({required this.getBrandsUseCase}) : super(const BaseState<List<BrandEntity>>(data: [])) {
    on<GetBrandsEvent>(
      _onGetBrands,
      transformer: droppable(),
    );
  }

  Future<void> _onGetBrands(
    GetBrandsEvent event,
    Emitter<BaseState<List<BrandEntity>>> emit,
  ) async {
    if (event.isRefresh) {
      emit(state.copyWith(
        requestStatus: RequestStatus.loading,
        currentPage: 1,
        hasReachedMax: false,
        data: [],
      ));
    } else {
      if (state.hasReachedMax == true || state.requestStatus == RequestStatus.loading) return;
      emit(state.copyWith(requestStatus: RequestStatus.loading));
    }

    final result = await getBrandsUseCase.call(
      page: state.currentPage,
      perPage: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (resultEntity) {
        final List<BrandEntity> updatedList = List.of(state.data ?? [])
          ..addAll(resultEntity.brands);
        
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          data: updatedList,
          currentPage: state.currentPage + 1,
          hasReachedMax: state.currentPage >= resultEntity.lastPage,
        ));
      },
    );
  }
}
