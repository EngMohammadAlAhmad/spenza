import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/data/models/cart_preview_model.dart';
import 'package:spenza/features/cart/domain/entities/cart_preview_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class GetCheckoutPreviewUseCase {
  final CartRepository repository;

  GetCheckoutPreviewUseCase({required this.repository});

  Future<Either<Failure, CartPreviewEntity>> call(CheckoutPreviewParams params) async {
    return await repository.getCheckoutPreview(params);
  }
}
