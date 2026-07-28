import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/brands/domain/entities/brand_products_result_entity.dart';
import 'package:spenza/features/brands/domain/repositories/brands_repository.dart';

class GetBrandProductsUseCase {
  final BrandsRepository repository;

  GetBrandProductsUseCase({required this.repository});

  Future<Either<Failure, BrandProductsResultEntity>> call({
    required int brandId,
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getBrandProducts(
      brandId: brandId,
      page: page,
      perPage: perPage,
    );
  }
}
