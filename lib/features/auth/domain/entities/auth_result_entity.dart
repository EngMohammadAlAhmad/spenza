import 'package:equatable/equatable.dart';

class AuthResultEntity extends Equatable {
  final String message;
  final String? token;

  const AuthResultEntity({
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [message, token];
}
