import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/utils/base_state.dart';
import 'package:spenza/features/auth/domain/usecases/register_usecase.dart';
import 'package:spenza/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:spenza/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:spenza/features/auth/presentation/bloc/auth_status_bloc.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, BaseState<Object>> {
  final RequestOtpUseCase requestOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final RegisterUseCase registerUseCase;
  final CacheHelper cacheHelper;
  final AuthStatusBloc authStatusBloc;

  AuthBloc({
    required this.requestOtpUseCase,
    required this.verifyOtpUseCase,
    required this.registerUseCase,
    required this.cacheHelper,
    required this.authStatusBloc,
  }) : super(const BaseState<Object>()) {
    on<RequestOtpEvent>((event, emit) async {
      emit(state.loading());
      final result = await requestOtpUseCase(event.phoneNumber);
      result.fold(
        (failure) => emit(state.error(failure)),
        (message) => emit(state.success(message, message: message)),
      );
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(state.loading());
      final result = await verifyOtpUseCase(event.phoneNumber, event.code);
      await result.fold(
        (failure) async => emit(state.error(failure)),
        (resultEntity) async {
          if (resultEntity.registered && resultEntity.token != null) {
            await cacheHelper.saveAuthToken(resultEntity.token!);
            authStatusBloc.add(UpdateAuthStatus(true));
          }
          emit(state.success(resultEntity, message: resultEntity.message));
        },
      );
    });

    on<RegisterEvent>((event, emit) async {
      emit(state.loading());
      final result = await registerUseCase(
        name: event.name,
        phoneNumber: event.phoneNumber,
        code: event.code,
      );
      await result.fold(
        (failure) async => emit(state.error(failure)),
        (authResult) async {
          if (authResult.token != null) {
            await cacheHelper.saveAuthToken(authResult.token!);
            authStatusBloc.add(UpdateAuthStatus(true));
          }
          emit(state.success(authResult, message: authResult.message));
        },
      );
    });
  }
}
