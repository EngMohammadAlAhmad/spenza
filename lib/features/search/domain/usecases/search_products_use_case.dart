import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';
import 'package:spenza/features/search/domain/repositories/search_repository.dart';

class SearchProductsUseCase {
  final SearchRepository repository;

  SearchProductsUseCase({required this.repository});

  Future<Either<Failure, SearchResultEntity>> call(SearchParams params) async {
    return await repository.searchProducts(params);
  }
}
