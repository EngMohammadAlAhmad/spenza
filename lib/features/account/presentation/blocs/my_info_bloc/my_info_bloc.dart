import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/features/account/domain/usecases/confirm_phone_change_use_case.dart';
import 'package:spenza/features/account/domain/usecases/request_phone_change_use_case.dart';
import 'package:spenza/features/account/domain/usecases/update_profile_use_case.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_event.dart';
import 'package:spenza/features/account/presentation/blocs/my_info_bloc/my_info_state.dart';

class MyInfoBloc extends Bloc<MyInfoEvent, MyInfoState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final RequestPhoneChangeUseCase requestPhoneChangeUseCase;
  final ConfirmPhoneChangeUseCase confirmPhoneChangeUseCase;

  MyInfoBloc({
    required this.updateProfileUseCase,
    required this.requestPhoneChangeUseCase,
    required this.confirmPhoneChangeUseCase,
  }) : super(const MyInfoState()) {
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<RequestPhoneChangeEvent>(_onRequestPhoneChange);
    on<ConfirmPhoneChangeEvent>(_onConfirmPhoneChange);
    on<ResetMyInfoStatusEvent>(_onResetStatus);
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<MyInfoState> emit,
  ) async {
    emit(state.copyWith(updateProfileStatus: RequestStatus.loading));

    final result = await updateProfileUseCase(
      name: event.name,
      email: event.email,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        updateProfileStatus: RequestStatus.error,
        errorMessage: failure.errMessage,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        updateProfileStatus: RequestStatus.success,
        user: user,
      )),
    );
  }

  Future<void> _onRequestPhoneChange(
    RequestPhoneChangeEvent event,
    Emitter<MyInfoState> emit,
  ) async {
    emit(state.copyWith(requestPhoneStatus: RequestStatus.loading));

    final result = await requestPhoneChangeUseCase(
      phoneNumber: event.phoneNumber,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        requestPhoneStatus: RequestStatus.error,
        errorMessage: failure.errMessage,
        failure: failure,
      )),
      (message) => emit(state.copyWith(
        requestPhoneStatus: RequestStatus.success,
        phoneChangeMessage: message,
      )),
    );
  }

  Future<void> _onConfirmPhoneChange(
    ConfirmPhoneChangeEvent event,
    Emitter<MyInfoState> emit,
  ) async {
    emit(state.copyWith(
      confirmPhoneStatus: RequestStatus.loading,
      requestPhoneStatus: RequestStatus.init,
      phoneChangeMessage: null,
    ));

    final result = await confirmPhoneChangeUseCase(
      phoneNumber: event.phoneNumber,
      code: event.code,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        confirmPhoneStatus: RequestStatus.error,
        errorMessage: failure.errMessage,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        confirmPhoneStatus: RequestStatus.success,
        user: user,
      )),
    );
  }

  void _onResetStatus(
    ResetMyInfoStatusEvent event,
    Emitter<MyInfoState> emit,
  ) {
    emit(state.copyWith(
      updateProfileStatus: RequestStatus.init,
      requestPhoneStatus: RequestStatus.init,
      confirmPhoneStatus: RequestStatus.init,
      errorMessage: null,
      phoneChangeMessage: null,
    ));
  }
}
