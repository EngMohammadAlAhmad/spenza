import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/brands/data/datasource/brands_datasource.dart';
import 'package:spenza/features/brands/domain/entities/brands_result_entity.dart';
import 'package:spenza/features/brands/domain/repositories/brands_repository.dart';

import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';

class BrandsRepositoryImpl implements BrandsRepository {
  final BrandsDatasource datasource;

  BrandsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, BrandsResultEntity>> getBrands({
    required int page,
    required int perPage,
  }) async {
    return await handleRepositoryCall(() => datasource.getBrands(
          page: page,
          perPage: perPage,
        ));
  }

  @override
  Future<Either<Failure, BrandProductsResultEntity>> getBrandProducts({
    required int brandId,
    required int page,
    required int perPage,
  }) async {
    return await handleRepositoryCall(() => datasource.getBrandProducts(
          brandId: brandId,
          page: page,
          perPage: perPage,
        ));
  }
}
