import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class AddAddressUseCase {
  final AddressesRepository repository;

  AddAddressUseCase({required this.repository});

  Future<Either<Failure, AddAddressResult>> call(AddAddressParams params) async {
    return await repository.addAddress(params);
  }
}
