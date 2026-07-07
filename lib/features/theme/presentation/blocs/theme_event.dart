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


