import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:spenza/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_item_entity.dart';
import 'package:spenza/features/cart/domain/entities/cart_preview_entity.dart';
import 'package:spenza/features/cart/domain/entities/checkout_options_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

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

  @override
  Future<Either<Failure, CheckoutOptionsEntity>> getCheckoutOptions(int cityId) {
    return handleRepositoryCall(() => remoteDataSource.getCheckoutOptions(cityId));
  }

  @override
  Future<Either<Failure, CartPreviewEntity>> getCheckoutPreview(CheckoutPreviewParams params) {
    return handleRepositoryCall(() => remoteDataSource.getCheckoutPreview(params));
  }
}
