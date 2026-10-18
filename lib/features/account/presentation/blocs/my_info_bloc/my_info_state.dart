import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';

class MyInfoState extends Equatable {
  final RequestStatus updateProfileStatus;
  final RequestStatus requestPhoneStatus;
  final RequestStatus confirmPhoneStatus;
  final UserEntity? user;
  final String? phoneChangeMessage;
  final String? errorMessage;
  final Failure failure;

  const MyInfoState({
    this.updateProfileStatus = RequestStatus.init,
    this.requestPhoneStatus = RequestStatus.init,
    this.confirmPhoneStatus = RequestStatus.init,
    this.user,
    this.phoneChangeMessage,
    this.errorMessage,
    this.failure = defaultFailure,
  });

  MyInfoState copyWith({
    RequestStatus? updateProfileStatus,
    RequestStatus? requestPhoneStatus,
    RequestStatus? confirmPhoneStatus,
    UserEntity? user,
    String? phoneChangeMessage,
    String? errorMessage,
    Failure? failure,
  }) {
    return MyInfoState(
      updateProfileStatus: updateProfileStatus ?? this.updateProfileStatus,
      requestPhoneStatus: requestPhoneStatus ?? this.requestPhoneStatus,
      confirmPhoneStatus: confirmPhoneStatus ?? this.confirmPhoneStatus,
      user: user ?? this.user,
      phoneChangeMessage: phoneChangeMessage ?? this.phoneChangeMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        updateProfileStatus,
        requestPhoneStatus,
        confirmPhoneStatus,
        user,
        phoneChangeMessage,
        errorMessage,
        failure,
      ];
}
