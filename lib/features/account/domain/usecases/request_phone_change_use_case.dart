import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/account/domain/repositories/account_repository.dart';

class RequestPhoneChangeUseCase {
  final AccountRepository repository;

  RequestPhoneChangeUseCase({required this.repository});

  Future<Either<Failure, String>> call({
    required String phoneNumber,
  }) async {
    return await repository.requestPhoneChange(
      phoneNumber: phoneNumber,
    );
  }
}
