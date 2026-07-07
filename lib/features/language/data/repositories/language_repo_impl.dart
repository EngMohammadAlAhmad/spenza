import 'package:spenza/features/language/domain/entities/language_entity.dart';
import 'package:spenza/features/language/domain/repositories/language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  @override
  Future<void> setLanguage(String languageCode) async {
    // Implementation will be handled by BLoC with context
  }

  @override
  String getCurrentLanguage() {
    // Implementation will be handled by BLoC with context
    return 'en';
  }

  @override
  List<LanguageEntity> getSupportedLanguages() {
    return LanguageEntity.values;
  }
}