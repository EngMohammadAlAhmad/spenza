import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/addresses/data/datasources/addresses_datasource.dart';
import 'package:spenza/features/addresses/domain/entities/add_address_params.dart';
import 'package:spenza/features/addresses/domain/entities/address_entity.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesDatasource datasource;

  AddressesRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    return handleRepositoryCall<List<AddressEntity>>(() async => await datasource.getAddresses());
  }

  @override
  Future<Either<Failure, AddAddressResult>> addAddress(AddAddressParams params) async {
    return handleRepositoryCall<AddAddressResult>(() async => await datasource.addAddress(params));
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getLocations() async {
    return handleRepositoryCall<List<GovernorateEntity>>(() async => await datasource.getLocations());
  }
}
