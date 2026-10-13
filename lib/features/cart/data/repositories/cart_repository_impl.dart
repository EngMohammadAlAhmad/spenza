import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCart() {
    return handleRepositoryCall(() => localDataSource.getCart());
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> addToCart(CartItemEntity item) {
    return handleRepositoryCall(() => localDataSource.addToCart(item));
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> updateQuantity(int productId, int unitId, int quantity) {
    return handleRepositoryCall(() => localDataSource.updateQuantity(productId, unitId, quantity));
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> removeFromCart(int productId, int unitId) {
    return handleRepositoryCall(() => localDataSource.removeFromCart(productId, unitId));
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> clearCart() {
    return handleRepositoryCall(() => localDataSource.clearCart());
  }
}
