import 'package:dio/dio.dart';
import 'package:spenza/core/errors/error_model.dart';

/// =========================
/// Base Exceptions
/// =========================

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class OfflineException implements Exception {}

class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

/// =========================
/// Dio / Network Exceptions
/// =========================

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

/// =========================
/// HTTP Client Errors (4xx)
/// =========================

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class MethodNotAllowedException extends ServerException {
  MethodNotAllowedException(super.errorModel);
}

class RequestTimeoutException extends ServerException {
  RequestTimeoutException(super.errorModel);
}

class CoefficientException extends ServerException {
  CoefficientException(super.errorModel);
}

class GoneException extends ServerException {
  GoneException(super.errorModel);
}

class ValidationException extends ServerException {
  ValidationException(super.errorModel);
}

class LockedException extends ServerException {
  LockedException(super.errorModel);
}

class TooManyRequestsException extends ServerException {
  TooManyRequestsException(super.errorModel);
}

/// =========================
/// HTTP Server Errors (5xx)
/// =========================

class InternalServerErrorException extends ServerException {
  InternalServerErrorException(super.errorModel);
}

class NotImplementedException extends ServerException {
  NotImplementedException(super.errorModel);
}

class BadGatewayException extends ServerException {
  BadGatewayException(super.errorModel);
}

class ServiceUnavailableException extends ServerException {
  ServiceUnavailableException(super.errorModel);
}

/// =========================
/// Dio Exception Handler
/// =========================

void handleDioException(DioException e) {
  /// Safely extract error model from response
  ErrorModel extractErrorModel(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return ErrorModel.fromJson(responseData);
    } else if (responseData is String) {
      return ErrorModel(errorMessage: responseData);
    } else {
      return ErrorModel(errorMessage: 'An unexpected error occurred');
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw OfflineException();

    case DioExceptionType.badCertificate:
      throw BadCertificateException(
        ErrorModel(errorMessage: 'Invalid SSL certificate.'),
      );

    case DioExceptionType.connectionTimeout:
      throw OfflineException();

    case DioExceptionType.receiveTimeout:
      throw OfflineException();

    case DioExceptionType.sendTimeout:
      throw OfflineException();

    case DioExceptionType.cancel:
      throw CancelException(
        ErrorModel(errorMessage: 'Request was cancelled.'),
      );

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      final errorModel = extractErrorModel(e.response?.data ?? {});

      switch (statusCode) {
      // 🔴 4xx — Client errors
        case 400:
          throw BadResponseException(errorModel);
        case 401:
          throw UnauthorizedException(errorModel);
        case 403:
          throw ForbiddenException(errorModel);
        case 404:
          throw NotFoundException(errorModel);
        case 405:
          throw MethodNotAllowedException(errorModel);
        case 408:
          throw OfflineException();
        case 409:
          throw CoefficientException(errorModel);
        case 410:
          throw GoneException(errorModel);
        case 415:
          throw BadResponseException(errorModel);
        case 422:
          throw ValidationException(errorModel);
        case 423:
          throw LockedException(errorModel);
        case 429:
          throw TooManyRequestsException(ErrorModel(errorMessage: 'Too many requests. Try again later.'));

      // 🔥 5xx — Server errors
        case 500:
          throw InternalServerErrorException(errorModel);
        case 501:
          throw NotImplementedException(errorModel);
        case 502:
          throw BadGatewayException(errorModel);
        case 503:
          throw ServiceUnavailableException(ErrorModel(errorMessage: 'Server unavailable. Please try later.'));
        case 504:
          throw BadGatewayException(ErrorModel(errorMessage: 'Gateway timeout.'));
        default:
          throw BadResponseException(errorModel);
      }

    case DioExceptionType.unknown:
      if (e.message?.contains('SocketException') == true || e.message?.contains('host lookup') == true) {
        throw OfflineException();
      }
      throw UnknownException(
        ErrorModel(errorMessage: e.message ?? 'Unknown error occurred'),
      );
    case DioExceptionType.transformTimeout:
      throw OfflineException();
  }
}


/*
//!ServerException
class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}
//!CacheException
class CacheException implements Exception {
  final String errorMessage;
  CacheException({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CoefficientException extends ServerException {
  CoefficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(ErrorModel.fromJson(e.response?.data ?? {}));
    case DioExceptionType.badCertificate:
      throw BadCertificateException(ErrorModel.fromJson(e.response!.data ?? {}));
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(ErrorModel.fromJson(e.response!.data ?? {}));

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(ErrorModel.fromJson(e.response!.data ?? {}));

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(ErrorModel.fromJson(e.response!.data ?? {}));

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request

          throw BadResponseException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 401: //unauthorized
          throw UnauthorizedException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 403: //forbidden
          throw ForbiddenException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 404: //not found
          throw NotFoundException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 409: //coefficient

          throw CoefficientException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 415: // Unsupported Media Type
          throw BadResponseException(ErrorModel.fromJson(e.response!.data ?? {}));

        case 504: // Bad request

          throw BadResponseException(
              ErrorModel(*/
/*status: 504, *//*
errorMessage: e.response!.data ?? {}));
      }

    case DioExceptionType.cancel:
      throw CancelException(
          ErrorModel(errorMessage: e.toString()*/
/*, status: 500*//*
));

    case DioExceptionType.unknown:
      throw UnknownException(
          ErrorModel(errorMessage: e.toString()*/
/*, status: 500*//*
));
  }
}
*/
