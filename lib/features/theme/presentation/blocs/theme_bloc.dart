import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spenza/core/enums/request_state.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/theme/domain/entities/theme_entity.dart';
import 'package:spenza/features/theme/domain/usecases/get_theme_usecase.dart';
import 'package:spenza/features/theme/domain/usecases/save_theme_usecase.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, BaseState<ThemeEntity>> {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeBloc({
    required this.getThemeUseCase,
    required this.saveThemeUseCase,
  }) : super(BaseState<ThemeEntity>(data: ThemeEntity(themeType: ThemeType.light))) {
    on<GetThemeEvent>(onGetTheme);
    on<ToggleThemeEvent>(onToggleTheme);
    on<ChangeThemeEvent>(onChangeTheme);
  }

  Future<void> onGetTheme(GetThemeEvent event, Emitter<BaseState<ThemeEntity>> emit) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await getThemeUseCase.call();
    result.fold(
      (left) => emit(state.copyWith(
        requestStatus: RequestStatus.error,
        failure: left,
        data: ThemeEntity(themeType: ThemeType.light),
      )),
      (right) => emit(state.copyWith(requestStatus: RequestStatus.success, data: right)),
    );
  }

  Future<void> onToggleTheme(ToggleThemeEvent event, Emitter<BaseState<ThemeEntity>> emit) async {
    final currentType = state.data?.themeType ?? ThemeType.light;
    final newThemeType = currentType == ThemeType.dark
        ? ThemeType.light
        : ThemeType.dark;

    final newThemeEntity = ThemeEntity(themeType: newThemeType);
    final result = await saveThemeUseCase.call(theme: newThemeEntity);

    result.fold(
      (left) => emit(state.copyWith(requestStatus: RequestStatus.error, failure: left)),
      (right) => emit(state.copyWith(requestStatus: RequestStatus.success, data: newThemeEntity)),
    );
  }

  Future<void> onChangeTheme(ChangeThemeEvent event, Emitter<BaseState<ThemeEntity>> emit) async {
    final newThemeEntity = ThemeEntity(themeType: event.themeType);
    final result = await saveThemeUseCase.call(theme: newThemeEntity);

    result.fold(
      (left) => emit(state.copyWith(requestStatus: RequestStatus.error, failure: left)),
      (right) => emit(state.copyWith(requestStatus: RequestStatus.success, data: newThemeEntity)),
    );
  }
}
