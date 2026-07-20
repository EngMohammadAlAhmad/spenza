// core/observers/app_bloc_observer.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spenza/core/services/crash_reporter.dart';
import 'package:spenza/injection_locator.dart' as di;

class AppBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    di.sl<CrashReporter>().recordError(error, stackTrace, fatal: false);
    super.onError(bloc, error, stackTrace);
  }
}