import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/domain/usecases/get_user_profile_use_case.dart';
import 'package:spenza/features/account/presentation/blocs/account_bloc/account_event.dart';

class AccountBloc extends Bloc<AccountEvent, BaseState<UserEntity>> {
  final GetUserProfileUseCase getUserProfileUseCase;

  AccountBloc({required this.getUserProfileUseCase})
      : super(const BaseState<UserEntity>()) {
    on<GetUserProfileEvent>(_onGetUserProfile);
  }

  Future<void> _onGetUserProfile(
    GetUserProfileEvent event,
    Emitter<BaseState<UserEntity>> emit,
  ) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final result = await getUserProfileUseCase();

    result.fold(
      (failure) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: failure,
      )),
      (user) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        data: user,
      )),
    );
  }
}
