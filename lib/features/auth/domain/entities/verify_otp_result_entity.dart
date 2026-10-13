import 'package:equatable/equatable.dart';

class VerifyOtpResultEntity extends Equatable {
  final bool registered;
  final String message;
  final String? token;

  const VerifyOtpResultEntity({
    required this.registered,
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [registered, message, token];
}
