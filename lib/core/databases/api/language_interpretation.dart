import 'package:dio/dio.dart';

/// Interceptor that automatically adds the locale as a query parameter to all requests
class LanguageInterceptor extends Interceptor {
  String _currentLanguage = 'ar'; // Default language

  /// Update the current language (Call this on app startup or when user changes language)
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  /// Get the current language
  String get currentLanguage => _currentLanguage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add locale strictly as a query parameter
    // Dio will automatically format this as ?locale=en or &locale=en
    options.queryParameters['locale'] = _currentLanguage;

    // Continue with the request
    handler.next(options);
  }
}