import 'package:spenza/features/language/domain/entities/language_entity.dart';

abstract class LanguageRepository {
  Future<void> setLanguage(String languageCode);
  String getCurrentLanguage();
  List<LanguageEntity> getSupportedLanguages();
}