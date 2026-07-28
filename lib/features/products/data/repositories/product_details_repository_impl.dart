import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/products/data/datasource/products_datasource.dart';
import 'package:spenza/features/products/domain/entities/product_details_entity.dart';
import 'package:spenza/features/products/domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductsDatasource datasource;

  ProductDetailsRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails({required int productId}) async {
    return await handleRepositoryCall(() => datasource.getProductDetails(productId: productId));
  }
}
