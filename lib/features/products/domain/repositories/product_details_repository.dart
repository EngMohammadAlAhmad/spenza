import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails({
    required int productId,
  });
}
