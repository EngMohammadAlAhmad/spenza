import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';

abstract class AuthStatusEvent {}

class CheckAuthStatus extends AuthStatusEvent {}

class UpdateAuthStatus extends AuthStatusEvent {
  final bool isLoggedIn;
  UpdateAuthStatus(this.isLoggedIn);
}

class AuthStatusState {
  final bool isLoggedIn;
  AuthStatusState({required this.isLoggedIn});
}

class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStatusState> {
  final CacheHelper cacheHelper;

  AuthStatusBloc({required this.cacheHelper})
      : super(AuthStatusState(isLoggedIn: cacheHelper.getAuthToken().isNotEmpty)) {
    on<CheckAuthStatus>((event, emit) {
      emit(AuthStatusState(isLoggedIn: cacheHelper.getAuthToken().isNotEmpty));
    });

    on<UpdateAuthStatus>((event, emit) {
      emit(AuthStatusState(isLoggedIn: event.isLoggedIn));
    });
  }
}
