import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/home/domain/entities/home_data_entity.dart';
import 'package:spenza/features/home/domain/repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository homeRepository;

  GetHomeDataUseCase({required this.homeRepository});

  Future<Either<Failure, HomeDataEntity>> call() {
    return homeRepository.getHomeData();
  }

}