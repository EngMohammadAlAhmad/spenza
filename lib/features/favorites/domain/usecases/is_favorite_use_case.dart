import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import '../repositories/favorites_repository.dart';

class IsFavoriteUseCase {
  final FavoritesRepository repository;

  IsFavoriteUseCase({required this.repository});

  Future<Either<Failure, bool>> call(int productId) async {
    return await repository.isFavorite(productId);
  }
}
