import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/categories/domain/entities/categories_result_entity.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, CategoriesResultEntity>> getCategories({
    required int page,
    required int perPage,
  });
}
