import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class DeleteAddressUseCase {
  final AddressesRepository repository;

  DeleteAddressUseCase({required this.repository});

  Future<Either<Failure, String>> call(int addressId) async {
    return await repository.deleteAddress(addressId);
  }
}
