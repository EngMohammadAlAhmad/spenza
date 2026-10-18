import 'package:equatable/equatable.dart';

abstract class MyInfoEvent extends Equatable {
  const MyInfoEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends MyInfoEvent {
  final String name;
  final String email;

  const UpdateProfileEvent({
    required this.name,
    required this.email,
  });

  @override
  List<Object?> get props => [name, email];
}

class RequestPhoneChangeEvent extends MyInfoEvent {
  final String phoneNumber;

  const RequestPhoneChangeEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class ConfirmPhoneChangeEvent extends MyInfoEvent {
  final String phoneNumber;
  final String code;

  const ConfirmPhoneChangeEvent({
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object?> get props => [phoneNumber, code];
}

class ResetMyInfoStatusEvent extends MyInfoEvent {
  const ResetMyInfoStatusEvent();
}
