import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/points_market/domain/entities/points_summary_entity.dart';
import 'package:spenza/features/points_market/domain/repositories/points_market_repository.dart';

class GetUserPointsUseCase {
  final PointsMarketRepository repository;

  GetUserPointsUseCase({required this.repository});

  Future<Either<Failure, PointsSummaryEntity>> call() {
    return repository.getMyPoints();
  }
}
