import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/auth/domain/entities/auth_result_entity.dart';
import 'package:spenza/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<Either<Failure, AuthResultEntity>> call({
    required String name,
    required String phoneNumber,
    required String code,
  }) async {
    return await repository.register(
      name: name,
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}
