import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/auth/data/datasource/auth_datasource.dart';
import 'package:spenza/features/auth/domain/entities/auth_result_entity.dart';
import 'package:spenza/features/auth/domain/entities/verify_otp_result_entity.dart';
import 'package:spenza/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, String>> requestOtp(String phoneNumber) async {
    return await handleRepositoryCall(() => datasource.requestOtp(phoneNumber));
  }

  @override
  Future<Either<Failure, VerifyOtpResultEntity>> verifyOtp(String phoneNumber, String code) async {
    return await handleRepositoryCall(() => datasource.verifyOtp(phoneNumber, code));
  }

  @override
  Future<Either<Failure, AuthResultEntity>> register({
    required String name,
    required String phoneNumber,
    required String code,
  }) async {
    return await handleRepositoryCall(() => datasource.register(
          name: name,
          phoneNumber: phoneNumber,
          code: code,
        ));
  }
}
