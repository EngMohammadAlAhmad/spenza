import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, List<CartItemEntity>>> addToCart(CartItemEntity item);
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(int productId, int unitId, int quantity);
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(int productId, int unitId);
  Future<Either<Failure, List<CartItemEntity>>> clearCart();
}
