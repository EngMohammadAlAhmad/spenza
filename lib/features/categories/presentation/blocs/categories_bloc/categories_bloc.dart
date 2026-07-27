import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/shared/entities/category_entity.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/categories/domain/usecases/get_categories_use_case.dart';

part 'categories_event.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, BaseState<List<CategoryEntity>>> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoriesBloc({required this.getCategoriesUseCase}) : super(const BaseState<List<CategoryEntity>>(data: [])) {
    on<GetCategoriesEvent>(
      _onGetCategories,
      transformer: droppable(),
    );
  }

  Future<void> _onGetCategories(
    GetCategoriesEvent event,
    Emitter<BaseState<List<CategoryEntity>>> emit,
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

    final result = await getCategoriesUseCase.call(
      page: state.currentPage,
      perPage: 20,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (resultEntity) {
        final List<CategoryEntity> updatedList = List.of(state.data ?? [])
          ..addAll(resultEntity.categories);
        
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
