import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/categories/domain/entities/categories_result_entity.dart';

import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, CategoriesResultEntity>> getCategories({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, CategoryProductsResultEntity>> getCategoryProducts({
    required int categoryId,
    required int page,
    required int perPage,
  });
}
