import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/shared/entities/product_entity.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase({required this.repository});

  Future<Either<Failure, void>> call(ProductEntity product) async {
    return await repository.toggleFavorite(product);
  }
}
