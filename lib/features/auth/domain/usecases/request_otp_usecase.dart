import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/auth/domain/repositories/auth_repository.dart';

class RequestOtpUseCase {
  final AuthRepository repository;

  RequestOtpUseCase({required this.repository});

  Future<Either<Failure, String>> call(String phoneNumber) async {
    return await repository.requestOtp(phoneNumber);
  }
}
