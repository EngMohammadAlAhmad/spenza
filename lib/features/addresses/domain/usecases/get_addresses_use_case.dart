import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class GetAddressesUseCase {
  final AddressesRepository repository;

  GetAddressesUseCase({required this.repository});

  Future<Either<Failure, List<AddressEntity>>> call() async {
    return await repository.getAddresses();
  }
}
