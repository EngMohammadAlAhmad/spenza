import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/cart/domain/entities/checkout_options_entity.dart';
import 'package:spenza/features/cart/domain/repositories/cart_repository.dart';

class GetCheckoutOptionsUseCase {
  final CartRepository repository;

  GetCheckoutOptionsUseCase({required this.repository});

  Future<Either<Failure, CheckoutOptionsEntity>> call(int cityId) async {
    return await repository.getCheckoutOptions(cityId);
  }
}
