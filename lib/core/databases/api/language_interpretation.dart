import 'package:dio/dio.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/utils/strings.dart';

/// Interceptor that automatically adds the locale as a query parameter to all requests
class LanguageInterceptor extends Interceptor {
  final CacheHelper cacheHelper;
  String? _currentLanguage;

  LanguageInterceptor({required this.cacheHelper});

  /// Update the current language (Call this on app startup or when user changes language)
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
    cacheHelper.saveData(key: Strings.LOCALE_KEY, value: languageCode);
  }

  /// Get the current language
  String get currentLanguage {
    if (_currentLanguage != null) {
      return _currentLanguage!;
    }
    final savedLang = cacheHelper.getDataString(key: Strings.LOCALE_KEY);
    if (savedLang != null && savedLang.isNotEmpty) {
      _currentLanguage = savedLang;
      return _currentLanguage!;
    }
    _currentLanguage = 'ar';
    return _currentLanguage!;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add locale strictly as a query parameter
    // Dio will automatically format this as ?locale=en or &locale=en
    options.queryParameters['locale'] = currentLanguage;

    // Continue with the request
    handler.next(options);
  }
}