import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/points_market/data/datasource/points_market_datasource.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/domain/repositories/points_market_repository.dart';

class PointsMarketRepositoryImpl implements PointsMarketRepository {
  final PointsMarketDatasource datasource;

  PointsMarketRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, PointsSummaryEntity>> getMyPoints() {
    return handleRepositoryCall(() => datasource.getMyPoints());
  }
}
