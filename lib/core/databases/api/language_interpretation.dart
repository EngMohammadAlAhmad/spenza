import 'package:dio/dio.dart';

/// Interceptor that automatically adds Accept-Language header to all requests
class LanguageInterceptor extends Interceptor {
  String _currentLanguage = 'en'; // Default language

  /// Update the current language
  void setLanguage(String languageCode) {
    _currentLanguage = languageCode;
  }

  /// Get the current language
  String get currentLanguage => _currentLanguage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add Accept-Language header to all requests
    options.headers['Accept-Language'] = _currentLanguage;

    // Continue with the request
    handler.next(options);
  }
}