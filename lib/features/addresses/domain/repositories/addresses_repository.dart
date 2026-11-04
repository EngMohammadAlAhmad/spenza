import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';
import 'package:spenza/features/addresses/domain/entities/update_address_params.dart';

abstract class AddressesRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, AddAddressResult>> addAddress(AddAddressParams params);
  Future<Either<Failure, String>> updateAddress(UpdateAddressParams params);
  Future<Either<Failure, String>> deleteAddress(int addressId);
  Future<Either<Failure, List<GovernorateEntity>>> getLocations();
}
// Trigger index refresh
