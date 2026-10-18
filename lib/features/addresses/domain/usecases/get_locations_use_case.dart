import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/addresses/domain/entities/governorate_entity.dart';
import 'package:spenza/features/addresses/domain/repositories/addresses_repository.dart';

class GetLocationsUseCase {
  final AddressesRepository repository;

  GetLocationsUseCase({required this.repository});

  Future<Either<Failure, List<GovernorateEntity>>> call() async {
    return await repository.getLocations();
  }
}
