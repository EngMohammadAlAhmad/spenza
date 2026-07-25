import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/core/utils/handle_repository_call.dart';
import 'package:spenza/features/home/data/datasource/home_datasource.dart';
import 'package:spenza/features/home/data/models/home_data_model.dart';
import 'package:spenza/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDatasource homeDatasource;

  HomeRepositoryImpl({required this.homeDatasource});

  @override
  Future<Either<Failure, HomeDataModel>> getHomeData() async {

    return handleRepositoryCall(() => homeDatasource.getHomeData());
  }

}