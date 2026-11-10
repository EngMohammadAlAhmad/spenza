import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/databases/api/language_interpretation.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/language/domain/entities/language_entity.dart';

part 'language_event.dart';

class LanguageBloc extends Bloc<LanguageEvent, BaseState<LanguageEntity>> {
  final LanguageInterceptor languageInterceptor;

  LanguageBloc({required this.languageInterceptor})
      : super(BaseState<LanguageEntity>()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadCurrentLanguageEvent>(_onLoadCurrentLanguage);
  }

  void _onChangeLanguage(
      ChangeLanguageEvent event, Emitter<BaseState<LanguageEntity>> emit) async {
    final newLanguage = LanguageEntity.fromCode(event.languageCode);
    languageInterceptor.setLanguage(event.languageCode);
    emit(state.copyWith(data: newLanguage));
  }

  void _onLoadCurrentLanguage(
      LoadCurrentLanguageEvent event, Emitter<BaseState<LanguageEntity>> emit) {
    final currentLang = languageInterceptor.currentLanguage;
    emit(state.copyWith(data: LanguageEntity.fromCode(currentLang)));
  }
}