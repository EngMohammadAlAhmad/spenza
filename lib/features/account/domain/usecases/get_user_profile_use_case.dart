import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';

class GetUserProfileUseCase {
  final AccountRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.getUserProfile();
  }
}
