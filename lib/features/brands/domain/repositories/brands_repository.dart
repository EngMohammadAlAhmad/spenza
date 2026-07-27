import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/brands/domain/entities/brands_result_entity.dart';

abstract class BrandsRepository {
  Future<Either<Failure, BrandsResultEntity>> getBrands({
    required int page,
    required int perPage,
  });
}
