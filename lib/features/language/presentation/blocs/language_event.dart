part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();
}


class ChangeLanguageEvent extends LanguageEvent {
  final String languageCode;

  const ChangeLanguageEvent({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class LoadCurrentLanguageEvent extends LanguageEvent {
  @override
  List<Object?> get props => [];
}