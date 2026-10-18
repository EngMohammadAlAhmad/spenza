import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/entities/cart_preview_entity.dart';
import 'package:spenza/features/cart/domain/entities/checkout_options_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCart();
  Future<Either<Failure, List<CartItemEntity>>> addToCart(CartItemEntity item);
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(int productId, int unitId, int quantity);
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(int productId, int unitId);
  Future<Either<Failure, List<CartItemEntity>>> clearCart();
  Future<Either<Failure, CheckoutOptionsEntity>> getCheckoutOptions(int cityId);
  Future<Either<Failure, CartPreviewEntity>> getCheckoutPreview(CheckoutPreviewParams params);
}
