import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/domain/repositories/theme_repository.dart';

class GetThemeUseCase {
  final ThemeRepository themeRepository;

  GetThemeUseCase({required this.themeRepository});

  Future<Either<Failure, ThemeEntity>> call() {
    return themeRepository.getTheme();
  }
}