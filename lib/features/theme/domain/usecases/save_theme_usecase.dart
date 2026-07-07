import 'package:dartz/dartz.dart';
import 'package:spenza/core/errors/failure.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/domain/repositories/theme_repository.dart';

class SaveThemeUseCase {
  final ThemeRepository themeRepository;

  SaveThemeUseCase({required this.themeRepository});

  Future<Either<Failure, Unit>> call({required ThemeEntity theme}) {
    return themeRepository.saveTheme(theme: theme);
  }
}