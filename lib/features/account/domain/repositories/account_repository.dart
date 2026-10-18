import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
  });
  Future<Either<Failure, String>> requestPhoneChange({
    required String phoneNumber,
  });
  Future<Either<Failure, UserEntity>> confirmPhoneChange({
    required String phoneNumber,
    required String code,
  });
}
