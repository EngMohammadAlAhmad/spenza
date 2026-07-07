enum LanguageEntity {
  english('en', 'English'),
  arabic('ar', 'العربية');

  final String code;
  final String name;

  const LanguageEntity(this.code, this.name);

  static LanguageEntity fromCode(String code) {
    return values.firstWhere(
          (element) => element.code == code,
      orElse: () => english,
    );
  }
}