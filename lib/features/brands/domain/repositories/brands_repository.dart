import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/brands/domain/entities/brands_result_entity.dart';

import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';

abstract class BrandsRepository {
  Future<Either<Failure, BrandsResultEntity>> getBrands({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, BrandProductsResultEntity>> getBrandProducts({
    required int brandId,
    required int page,
    required int perPage,
  });
}
