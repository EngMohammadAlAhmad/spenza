import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/categories/data/datasource/categories_datasource.dart';
import 'package:spenza/features/categories/domain/entities/categories_result_entity.dart';
import 'package:spenza/features/categories/domain/repositories/categories_repository.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesDatasource datasource;

  CategoriesRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, CategoriesResultEntity>> getCategories({
    required int page,
    required int perPage,
  }) async {
    return await handleRepositoryCall(() => datasource.getCategories(
          page: page,
          perPage: perPage,
        ));
  }
}
