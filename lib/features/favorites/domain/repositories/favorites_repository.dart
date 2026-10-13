import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<ProductEntity>>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(ProductEntity product);
  Future<Either<Failure, bool>> isFavorite(int productId);
}
