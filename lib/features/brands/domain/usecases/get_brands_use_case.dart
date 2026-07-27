import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/brands/domain/entities/brands_result_entity.dart';
import 'package:spenza/features/brands/domain/repositories/brands_repository.dart';

class GetBrandsUseCase {
  final BrandsRepository repository;

  GetBrandsUseCase({required this.repository});

  Future<Either<Failure, BrandsResultEntity>> call({
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getBrands(page: page, perPage: perPage);
  }
}
