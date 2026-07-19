abstract class CrashReporter {
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false});
  Future<void> log(String message);
  Future<void> setUserId(String id);
  Future<void> setCustomKey(String key, dynamic value);
}