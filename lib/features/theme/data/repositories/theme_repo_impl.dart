import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/exceptions.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/theme/data/datasources/theme_local_datasource.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;

  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<Either<Failure, ThemeEntity>> getTheme() async {
    try {
      var theme = await themeLocalDatasource.getTheme();
      return Right(theme);
    } on CacheException catch(e) {
      return Left(Failure(errMessage: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveTheme({required ThemeEntity theme}) async {
    try {
      await themeLocalDatasource.saveTheme(theme: theme);
      return Right(unit);
    } on CacheException catch(e) {
      return Left(Failure(errMessage: e.errorMessage));
    }
  }

}