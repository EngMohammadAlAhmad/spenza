import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/entities/user_entity.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';

class ConfirmPhoneChangeUseCase {
  final AccountRepository repository;

  ConfirmPhoneChangeUseCase({required this.repository});

  Future<Either<Failure, UserEntity>> call({
    required String phoneNumber,
    required String code,
  }) async {
    return await repository.confirmPhoneChange(
      phoneNumber: phoneNumber,
      code: code,
    );
  }
}
