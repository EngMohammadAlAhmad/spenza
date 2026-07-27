import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/categories/domain/entities/categories_result_entity.dart';
import 'package:spenza/features/categories/domain/repositories/categories_repository.dart';

class GetCategoriesUseCase {
  final CategoriesRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Either<Failure, CategoriesResultEntity>> call({
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getCategories(page: page, perPage: perPage);
  }
}
