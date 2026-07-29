import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResultEntity>> searchProducts(SearchParams params);
}
