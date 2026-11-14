part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();
}

class GetThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends ThemeEvent {
  @override
  List<Object?> get props => [];
}

class ChangeThemeEvent extends ThemeEvent {
  final ThemeType themeType;

  const ChangeThemeEvent({required this.themeType});

  @override
  List<Object?> get props => [themeType];
}