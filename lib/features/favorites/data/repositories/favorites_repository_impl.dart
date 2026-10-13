import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import 'package:spenza/core/shared/models/product_model.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasource/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavorites() async {
    return await handleRepositoryCall(() => localDataSource.getFavorites());
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(ProductEntity product) async {
    return await handleRepositoryCall(() async {
      final favorites = await localDataSource.getFavorites();
      final index = favorites.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        favorites.removeAt(index);
      } else {
        favorites.add(ProductModel(
          id: product.id,
          title: product.title,
          photo: product.photo,
          rate: product.rate,
          reviewsCount: product.reviewsCount,
          brand: product.brand,
          price: product.price,
          discountedPrice: product.discountedPrice,
          discountPercentage: product.discountPercentage,
        ));
      }
      await localDataSource.saveFavorites(favorites);
    });
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int productId) async {
    return await handleRepositoryCall(() async {
      final favorites = await localDataSource.getFavorites();
      return favorites.any((p) => p.id == productId);
    });
  }
}
