/*
// core/services/crash/firebase_crash_reporter.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:injectable/injectable.dart';
import 'package:spenza/core/services/crash_reporter.dart';

@LazySingleton(as: CrashReporter)
class FirebaseCrashReporter implements CrashReporter {
  final _crashlytics = FirebaseCrashlytics.instance;

  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false}) =>
      _crashlytics.recordError(exception, stack, fatal: fatal);

  @override
  Future<void> log(String message) => _crashlytics.log(message);

  @override
  Future<void> setUserId(String id) => _crashlytics.setUserIdentifier(id);

  @override
  Future<void> setCustomKey(String key, dynamic value) => _crashlytics.setCustomKey(key, value);
}*/
