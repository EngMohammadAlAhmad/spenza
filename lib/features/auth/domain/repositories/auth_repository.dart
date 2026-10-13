import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';

import 'package:spenza/features/auth/domain/entities/auth_result_entity.dart';
import 'package:spenza/features/auth/domain/entities/verify_otp_result_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> requestOtp(String phoneNumber);
  Future<Either<Failure, VerifyOtpResultEntity>> verifyOtp(String phoneNumber, String code);
  Future<Either<Failure, AuthResultEntity>> register({
    required String name,
    required String phoneNumber,
    required String code,
  });
}
