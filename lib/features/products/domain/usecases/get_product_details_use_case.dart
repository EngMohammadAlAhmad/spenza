import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/domain/repositories/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository repository;

  GetProductDetailsUseCase({required this.repository});

  Future<Either<Failure, ProductDetailsEntity>> call({
    required int productId,
  }) async {
    return await repository.getProductDetails(productId: productId);
  }
}
