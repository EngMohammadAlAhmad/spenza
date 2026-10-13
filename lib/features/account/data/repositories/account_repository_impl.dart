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
}
