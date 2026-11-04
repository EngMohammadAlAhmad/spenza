import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/update_address_params.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class UpdateAddressUseCase {
  final AddressesRepository repository;

  UpdateAddressUseCase({required this.repository});

  Future<Either<Failure, String>> call(UpdateAddressParams params) async {
    return await repository.updateAddress(params);
  }
}
