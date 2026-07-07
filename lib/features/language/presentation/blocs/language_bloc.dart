import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/language/domain/entities/language_entity.dart';

part 'language_event.dart';

class LanguageBloc extends Bloc<LanguageEvent, BaseState<LanguageEntity>> {
  LanguageBloc() : super(BaseState<LanguageEntity>()) {
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadCurrentLanguageEvent>(_onLoadCurrentLanguage);
  }

  void _onChangeLanguage(ChangeLanguageEvent event, Emitter<BaseState<LanguageEntity>> emit) async {
    final newLanguage = LanguageEntity.fromCode(event.languageCode);
    emit(state.copyWith(data: newLanguage));
  }

  void _onLoadCurrentLanguage(LoadCurrentLanguageEvent event, Emitter<BaseState<LanguageEntity>> emit) {}
}