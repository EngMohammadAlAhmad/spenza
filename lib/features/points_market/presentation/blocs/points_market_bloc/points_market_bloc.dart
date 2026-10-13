import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/domain/usecases/get_user_points_use_case.dart';

part 'points_market_event.dart';

class PointsMarketBloc extends Bloc<PointsMarketEvent, BaseState<PointsSummaryEntity>> {
  final GetUserPointsUseCase getUserPointsUseCase;

  PointsMarketBloc({
    required this.getUserPointsUseCase,
  }) : super(BaseState<PointsSummaryEntity>()) {
    on<GetMyPointsEvent>(_onGetMyPoints);
  }

  Future<void> _onGetMyPoints(
    GetMyPointsEvent event,
    Emitter<BaseState<PointsSummaryEntity>> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await getUserPointsUseCase.call();

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        data: data,
      )),
    );
  }
}
