enum ThemeType {
  light,
  dark,
  system,
}

class ThemeEntity {
  final ThemeType themeType;

  ThemeEntity({required this.themeType});
}