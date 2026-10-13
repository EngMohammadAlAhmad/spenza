import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';

abstract class PointsMarketRepository {
  Future<Either<Failure, PointsSummaryEntity>> getMyPoints();
}
