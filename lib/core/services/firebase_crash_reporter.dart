// core/services/crash/firebase_crash_reporter.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'crash_reporter.dart';

class FirebaseCrashReporter implements CrashReporter {
  @override
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false}) async {
    if (kIsWeb) {
      debugPrint('CrashReporter (Web): $exception\n$stack');
      return;
    }
    await FirebaseCrashlytics.instance.recordError(exception, stack, fatal: fatal);
  }

  @override
  Future<void> log(String message) async {
    if (kIsWeb) {
      debugPrint('CrashReporter Log (Web): $message');
      return;
    }
    await FirebaseCrashlytics.instance.log(message);
  }

  @override
  Future<void> setUserId(String id) async {
    if (kIsWeb) return;
    await FirebaseCrashlytics.instance.setUserIdentifier(id);
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    if (kIsWeb) return;
    await FirebaseCrashlytics.instance.setCustomKey(key, value);
  }
}