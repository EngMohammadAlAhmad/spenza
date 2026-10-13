import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase({required this.repository});

  Future<Either<Failure, List<CartItemEntity>>> call({
    required int productId,
    required int unitId,
    required int quantity,
  }) {
    return repository.updateQuantity(productId, unitId, quantity);
  }
}
