import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spenza/core/databases/api/api_consumer.dart';
import 'package:spenza/core/databases/api/end_points.dart';
import 'package:spenza/core/databases/api/language_interpretation.dart';
import 'package:spenza/core/databases/cache/cache_helper.dart';
import 'package:spenza/core/errors/exceptions.dart';
import 'package:spenza/core/routes/route_paths.dart';
import 'dart:convert';

import 'package:spenza/core/utils/strings.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final LanguageInterceptor languageInterceptor;
  final CacheHelper cacheHelper;
  final GlobalKey<NavigatorState> navigatorKey;

  DioConsumer({
    required this.dio,
    required this.languageInterceptor,
    required this.cacheHelper,
    required this.navigatorKey,
  }) {
    dio.options.baseUrl = EndPoints.baseUrl;
    dio.options.responseType = ResponseType.json;
    dio.options.headers['Accept'] = 'application/json';
    dio.options.headers['Content-Type'] = 'application/json';

    // Language interceptor
    dio.interceptors.add(languageInterceptor);

    // 🔐 SESSION EXPIRATION INTERCEPTOR (Add BEFORE logger)
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            await _handleSessionExpired();
            return;
          }
          handler.next(error);
        },
      ),
    );

    // Enhanced logger
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logRequest(options);
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          handler.next(response);
        },
        onError: (DioException e, handler) {
          _logError(e);
          handler.next(e);
        },
      ),
    );
  }

  // In DioConsumer
  Future<void> _handleSessionExpired() async {
    debugPrint('🔐 Session expired - logging out user');

    // Clear all cached data
    await cacheHelper.deleteAuthToken();
    await cacheHelper.removeData(key: Strings.LOGGED_KEY);
    await cacheHelper.removeData(key: Strings.REMEMBER_ME_KEY);

    // Use go_router's static context
    final context = navigatorKey.currentContext;
    if (context != null && context.mounted) {
      // Import go_router
      //context.go(RoutePaths.login);
    }
  }

  // ANSI Color codes
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _red = '\x1B[31m';
  static const String _reset = '\x1B[0m';

  // Helper to create lines with proper width
  String _createLine(String content, int width, String color) {
    if (content.length >= width - 4) {
      return '$color│$_reset ${content.substring(0, width - 6)}...$color │$_reset';
    }
    return '$color│$_reset $content${' ' * (width - content.length - 4)}$color│$_reset';
  }

  String _createSeparator(int width, String color) {
    return '$color├${'─' * (width - 2)}┤$_reset';
  }

  String _createTop(int width, String color) {
    return '$color┌${'─' * (width - 2)}┐$_reset';
  }

  String _createBottom(int width, String color) {
    return '$color└${'─' * (width - 2)}┘$_reset';
  }

  // =============================
  // 📤 REQUEST LOG
  // =============================
  void _logRequest(RequestOptions options) {
    const width = 80;
    final method = options.method;
    final uri = options.uri;

    debugPrint(_createTop(width, _blue));
    debugPrint(_createLine('📤 REQUEST', width, _blue));
    debugPrint(_createSeparator(width, _blue));
    debugPrint(_createLine('Method: $method', width, _blue));
    debugPrint(_createLine('URL: ${uri.toString()}', width, _blue));

    // Query Parameters
    if (options.queryParameters.isNotEmpty) {
      debugPrint(_createSeparator(width, _blue));
      debugPrint(_createLine('Query Parameters:', width, _blue));
      options.queryParameters.forEach((key, value) {
        debugPrint(_createLine('  • $key: $value', width, _blue));
      });
    }

    // Headers (only important ones)
    final importantHeaders = ['Authorization', 'Content-Type', 'Accept'];
    final filteredHeaders = Map.fromEntries(
        options.headers.entries.where((e) => importantHeaders.contains(e.key))
    );

    if (filteredHeaders.isNotEmpty) {
      debugPrint(_createSeparator(width, _blue));
      debugPrint(_createLine('Headers:', width, _blue));
      filteredHeaders.forEach((key, value) {
        final displayValue = key == 'Authorization'
            ? 'Bearer ${value.toString().replaceAll('Bearer ', '').substring(0, 20)}...'
            : value;
        debugPrint(_createLine('  • $key: $displayValue', width, _blue));
      });
    }

    // Request Body
    if (options.data != null) {
      debugPrint(_createSeparator(width, _blue));
      debugPrint(_createLine('Body:', width, _blue));
      try {
        final prettyData = _prettyJson(options.data);
        prettyData.split('\n').forEach((line) {
          debugPrint(_createLine('  $line', width, _blue));
        });
      } catch (e) {
        debugPrint(_createLine('  ${options.data}', width, _blue));
      }
    }

    debugPrint(_createBottom(width, _blue));
    debugPrint('');
  }

  // =============================
  // 📥 RESPONSE LOG
  // =============================
  void _logResponse(Response response) {
    const width = 80;
    final statusCode = response.statusCode;
    final uri = response.requestOptions.uri;

    debugPrint(_createTop(width, _green));
    debugPrint(_createLine('📥 RESPONSE', width, _green));
    debugPrint(_createSeparator(width, _green));
    debugPrint(_createLine('Status: $statusCode', width, _green));
    debugPrint(_createLine('URL: ${uri.toString()}', width, _green));

    // Response Headers (only important ones)
    final importantHeaders = ['content-type', 'content-length'];
    final filteredHeaders = Map.fromEntries(
        response.headers.map.entries.where((e) =>
            importantHeaders.contains(e.key.toLowerCase())
        )
    );

    if (filteredHeaders.isNotEmpty) {
      debugPrint(_createSeparator(width, _green));
      debugPrint(_createLine('Headers:', width, _green));
      filteredHeaders.forEach((key, value) {
        debugPrint(_createLine('  • $key: ${value.join(', ')}', width, _green));
      });
    }

    // Response Body
    if (response.data != null) {
      debugPrint(_createSeparator(width, _green));
      debugPrint(_createLine('Data:', width, _green));
      try {
        final prettyData = _prettyJson(response.data);
        final lines = prettyData.split('\n');

        // Limit response body preview to 15 lines
        final displayLines = lines.take(15).toList();
        for (var line in displayLines) {
          debugPrint(_createLine('  $line', width, _green));
        }

        if (lines.length > 15) {
          debugPrint(_createLine('  ... (${lines.length - 15} more lines)', width, _green));
        }
      } catch (e) {
        debugPrint(_createLine('  ${response.data}', width, _green));
      }
    }

    debugPrint(_createBottom(width, _green));
    debugPrint('');
  }

  // =============================
  // ❌ ERROR LOG
  // =============================
  void _logError(DioException e) {
    const width = 80;
    final statusCode = e.response?.statusCode ?? 'N/A';
    final uri = e.requestOptions.uri;

    debugPrint(_createTop(width, _red));
    debugPrint(_createLine('❌ ERROR', width, _red));
    debugPrint(_createSeparator(width, _red));
    debugPrint(_createLine('Status: $statusCode', width, _red));
    debugPrint(_createLine('URL: ${uri.toString()}', width, _red));
    debugPrint(_createLine('Type: ${e.type}', width, _red));

    if (e.message != null) {
      debugPrint(_createSeparator(width, _red));
      debugPrint(_createLine('Message:', width, _red));
      final messageLines = e.message!.split('\n');
      for (var line in messageLines) {
        debugPrint(_createLine('  $line', width, _red));
      }
    }

    if (e.response?.data != null) {
      debugPrint(_createSeparator(width, _red));
      debugPrint(_createLine('Error Data:', width, _red));
      try {
        final prettyData = _prettyJson(e.response!.data);
        prettyData.split('\n').forEach((line) {
          debugPrint(_createLine('  $line', width, _red));
        });
      } catch (err) {
        debugPrint(_createLine('  ${e.response!.data}', width, _red));
      }
    }

    debugPrint(_createBottom(width, _red));
    debugPrint('');
  }

  // =============================
  // HELPER: Pretty JSON
  // =============================
  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        // Try to parse if it's already a JSON string
        final decoded = jsonDecode(data);
        return JsonEncoder.withIndent('  ').convert(decoded);
      }
      return JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  // =============================
  // API METHODS
  // =============================

  @override
  Future post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false,
        String? token,
      }) async {
    try {
      final res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future get(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        String? token,
      }) async {
    try {
      final res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future delete(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        String? token,
      }) async {
    try {
      final res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        bool isFormData = false,
        String? token,
      }) async {
    try {
      final res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: {'Authorization': 'Bearer $token'})
            : null,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}