import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/account/data/datasource/account_datasource.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDatasource datasource;

  AccountRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    return handleRepositoryCall(() => datasource.getUserProfile());
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String name,
    required String email,
  }) async {
    return handleRepositoryCall(() => datasource.updateProfile(name: name, email: email));
  }

  @override
  Future<Either<Failure, String>> requestPhoneChange({
    required String phoneNumber,
  }) async {
    return handleRepositoryCall(() => datasource.requestPhoneChange(phoneNumber: phoneNumber));
  }

  @override
  Future<Either<Failure, UserEntity>> confirmPhoneChange({
    required String phoneNumber,
    required String code,
  }) async {
    return handleRepositoryCall(() => datasource.confirmPhoneChange(phoneNumber: phoneNumber, code: code));
  }
}
