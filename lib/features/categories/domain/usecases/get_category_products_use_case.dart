import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/categories/domain/entities/category_products_result_entity.dart';
import 'package:spenza/features/categories/domain/repositories/categories_repository.dart';

class GetCategoryProductsUseCase {
  final CategoriesRepository repository;

  GetCategoryProductsUseCase({required this.repository});

  Future<Either<Failure, CategoryProductsResultEntity>> call({
    required int categoryId,
    int page = 1,
    int perPage = 15,
  }) async {
    return await repository.getCategoryProducts(
      categoryId: categoryId,
      page: page,
      perPage: perPage,
    );
  }
}
