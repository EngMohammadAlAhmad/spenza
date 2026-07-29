import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/search/data/datasource/search_datasource.dart';
import 'package:spenza/features/search/domain/entities/search_params.dart';
import 'package:spenza/features/search/domain/entities/search_result_entity.dart';
import 'package:spenza/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchDatasource datasource;

  SearchRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, SearchResultEntity>> searchProducts(SearchParams params) async {
    return await handleRepositoryCall(() => datasource.searchProducts(params));
  }
}
