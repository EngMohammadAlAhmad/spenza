import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/home/domain/entities/home_data_entity.dart';
import 'package:spenza/features/home/domain/usecases/get_home_data.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, BaseState<HomeDataEntity>> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeBloc({
    required this.getHomeDataUseCase,
  }) : super(BaseState<HomeDataEntity>()) {

    on<GetHomeDataEvent>(_onGetHomeData);

  }

  // ==================== EVENT HANDLERS ====================

  Future<void> _onGetHomeData(
      GetHomeDataEvent event,
      Emitter<BaseState<HomeDataEntity>> emit,
      ) async {
    await _executeUseCase(
      useCaseFuture: getHomeDataUseCase.call(),
      emit: emit,
      onSuccess: (HomeDataEntity data) {
        _emitSuccess(emit, data: data);
      },
    );
  }

  // ==================== SHARED STATE-TRANSITION & EXECUTION MECHANISM ====================
  // Centralized helper to execute a use case, emit loading, and handle the Either fold.
  // This avoids repeating `emit(state.copyWith(...))` and `fold` logic in every handler.

  Future<void> _executeUseCase({
    required Future<Either<Failure, HomeDataEntity>> useCaseFuture,
    required Emitter<BaseState<HomeDataEntity>> emit,
    required void Function(HomeDataEntity data) onSuccess,
  }) async {
    _emitLoading(emit);

    final result = await useCaseFuture;

    result.fold(
          (failure) => _emitError(emit, failure.errMessage),
          (successData) => onSuccess(successData),
    );
  }

  void _emitLoading(Emitter<BaseState<HomeDataEntity>> emit) {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
  }

  void _emitError(Emitter<BaseState<HomeDataEntity>> emit, String? message) {
    emit(state.copyWith(
      requestStatus: RequestStatus.error,
      message: message ?? 'حدث خطأ غير متوقّع',
    ));
  }

  void _emitSuccess(
      Emitter<BaseState<HomeDataEntity>> emit, {
        required HomeDataEntity data,
      }) {
    emit(state.copyWith(
      requestStatus: RequestStatus.success,
      data: data,
    ));
  }
}