import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';

abstract class AccountRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
}
