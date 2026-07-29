import 'package:dartz/dartz.dart';
import 'package:spenza/core/connection/network_info.dart';
import 'package:spenza/core/errors/exceptions.dart';
import 'package:spenza/core/errors/failure.dart';

/// A reusable helper to handle repository calls and catch exceptions.
/// - By default, it catches [ServerException] and maps it to a [Failure].
/// - You can pass [onError] to handle custom exceptions or override the default mapping.
///
Future<Either<Failure, T>> handleRepositoryCall<T>(
    Future<T> Function() repositoryCall, {
      NetworkInfo? networkInfo,
      Failure Function(dynamic exception)? onError,
    }) async {
  if (networkInfo != null && !await networkInfo.isConnected) {
    return const Left(OfflineFailure());
  }

  try {
    final response = await repositoryCall();
    return Right(response);
  } catch (e) {
    // 1. If a custom error mapper is provided, use it for ANY exception.
    if (onError != null) {
      return Left(onError(e));
    }

    // 2. Handle OfflineException specifically.
    if (e is OfflineException) {
      return const Left(OfflineFailure());
    }

    // 3. Handle ServerException specifically.
    if (e is ServerException) {
      return Left(Failure(errMessage: e.errorModel.errorMessage));
    }

    // 4. If it's not a handled exception and no custom mapper is provided,
    // re-throw it to perfectly preserve your original logic (letting it bubble up).
    rethrow;
  }
}