import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RequestOtpEvent extends AuthEvent {
  final String phoneNumber;

  const RequestOtpEvent(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtpEvent extends AuthEvent {
  final String phoneNumber;
  final String code;

  const VerifyOtpEvent({required this.phoneNumber, required this.code});

  @override
  List<Object> get props => [phoneNumber, code];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phoneNumber;
  final String code;

  const RegisterEvent({
    required this.name,
    required this.phoneNumber,
    required this.code,
  });

  @override
  List<Object> get props => [name, phoneNumber, code];
}
