import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/home/domain/entities/home_data_entity.dart';

abstract class HomeRepository {

  Future<Either<Failure, HomeDataEntity>> getHomeData();

}