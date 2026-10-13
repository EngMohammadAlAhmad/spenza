import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase({required this.repository});

  Future<Either<Failure, List<CartItemEntity>>> call({
    required int productId,
    required int unitId,
  }) {
    return repository.removeFromCart(productId, unitId);
  }
}
