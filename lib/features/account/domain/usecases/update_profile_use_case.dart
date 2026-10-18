import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';

class UpdateProfileUseCase {
  final AccountRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
  }) async {
    return await repository.updateProfile(
      name: name,
      email: email,
    );
  }
}
