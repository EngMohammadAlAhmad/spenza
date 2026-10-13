import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/auth/domain/entities/verify_otp_result_entity.dart';
import 'package:spenza/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<Either<Failure, VerifyOtpResultEntity>> call(String phoneNumber, String code) async {
    return await repository.verifyOtp(phoneNumber, code);
  }
}
