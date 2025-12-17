/// Core failure classes for centralized error handling.
///
/// This module provides a type-safe way to handle errors across the application
/// using sealed classes and pattern matching.
///
/// Example:
/// ```dart
/// final result = await repository.getData();
/// result.fold(
///   (failure) => _handleFailure(failure),
///   (data) => _showData(data),
/// );
/// ```
library;

/// Base failure class for all errors in the application.
///
/// All failures should extend this class to provide consistent error handling.
sealed class Failure {
  /// Human-readable error message
  final String message;

  /// Optional error code for categorization
  final String? code;

  /// Original error object for debugging
  final dynamic originalError;

  /// Stack trace for debugging
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  /// Returns a user-friendly message
  String get userMessage => message;

  /// Returns technical details for logging
  String get technicalMessage {
    final buffer = StringBuffer();
    buffer.writeln('Error: $message');
    if (code != null) buffer.writeln('Code: $code');
    if (originalError != null) buffer.writeln('Original: $originalError');
    return buffer.toString();
  }

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => Object.hash(message, code);
}

/// Network-related failures (connection, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for connection failures
  factory NetworkFailure.connection() {
    return const NetworkFailure(
      message:
          'Unable to connect to server. Please check your internet connection.',
      code: 'NETWORK_CONNECTION_FAILED',
    );
  }

  /// Factory for timeout failures
  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Request timed out. Please try again.',
      code: 'NETWORK_TIMEOUT',
    );
  }

  /// Factory for no internet failures
  factory NetworkFailure.noInternet() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your network settings.',
      code: 'NO_INTERNET',
    );
  }

  @override
  String get userMessage => message;
}

/// Server-related failures (4xx, 5xx errors)
class ServerFailure extends Failure {
  /// HTTP status code
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for 400 Bad Request
  factory ServerFailure.badRequest({String? details}) {
    return ServerFailure(
      message: details ?? 'Invalid request. Please check your input.',
      statusCode: 400,
      code: 'BAD_REQUEST',
    );
  }

  /// Factory for 401 Unauthorized
  factory ServerFailure.unauthorized() {
    return const ServerFailure(
      message: 'Unauthorized. Please login again.',
      statusCode: 401,
      code: 'UNAUTHORIZED',
    );
  }

  /// Factory for 403 Forbidden
  factory ServerFailure.forbidden() {
    return const ServerFailure(
      message: 'Access denied. You don\'t have permission.',
      statusCode: 403,
      code: 'FORBIDDEN',
    );
  }

  /// Factory for 404 Not Found
  factory ServerFailure.notFound({String? resource}) {
    return ServerFailure(
      message: resource != null
          ? '$resource not found.'
          : 'Resource not found.',
      statusCode: 404,
      code: 'NOT_FOUND',
    );
  }

  /// Factory for 500 Internal Server Error
  factory ServerFailure.internal() {
    return const ServerFailure(
      message: 'Server error. Please try again later.',
      statusCode: 500,
      code: 'INTERNAL_SERVER_ERROR',
    );
  }

  /// Factory for 503 Service Unavailable
  factory ServerFailure.unavailable() {
    return const ServerFailure(
      message: 'Service temporarily unavailable. Please try again later.',
      statusCode: 503,
      code: 'SERVICE_UNAVAILABLE',
    );
  }

  @override
  String get userMessage => message;
}

/// Cache-related failures (read/write errors)
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for cache read failures
  factory CacheFailure.read() {
    return const CacheFailure(
      message: 'Failed to read from cache.',
      code: 'CACHE_READ_FAILED',
    );
  }

  /// Factory for cache write failures
  factory CacheFailure.write() {
    return const CacheFailure(
      message: 'Failed to write to cache.',
      code: 'CACHE_WRITE_FAILED',
    );
  }

  /// Factory for cache corruption
  factory CacheFailure.corrupted() {
    return const CacheFailure(
      message: 'Cache data is corrupted. Please clear cache.',
      code: 'CACHE_CORRUPTED',
    );
  }

  @override
  String get userMessage => 'Data access error. Please try again.';
}

/// Validation-related failures (invalid input, format errors)
class ValidationFailure extends Failure {
  /// Field that failed validation
  final String? field;

  const ValidationFailure({
    required super.message,
    this.field,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for required field validation
  factory ValidationFailure.required(String field) {
    return ValidationFailure(
      message: '$field is required.',
      field: field,
      code: 'VALIDATION_REQUIRED',
    );
  }

  /// Factory for invalid format
  factory ValidationFailure.format(String field, {String? expected}) {
    return ValidationFailure(
      message: expected != null
          ? 'Invalid $field format. Expected: $expected'
          : 'Invalid $field format.',
      field: field,
      code: 'VALIDATION_FORMAT',
    );
  }

  /// Factory for range validation
  factory ValidationFailure.range(String field, {num? min, num? max}) {
    return ValidationFailure(
      message: 'Invalid $field. Range: $min to $max.',
      field: field,
      code: 'VALIDATION_RANGE',
    );
  }

  /// Factory for length validation
  factory ValidationFailure.length(String field, {int? min, int? max}) {
    return ValidationFailure(
      message: 'Invalid $field length. Required: $min to $max characters.',
      field: field,
      code: 'VALIDATION_LENGTH',
    );
  }

  @override
  String get userMessage => message;
}

/// Parsing-related failures (JSON, data conversion)
class ParsingFailure extends Failure {
  const ParsingFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for JSON parsing failures
  factory ParsingFailure.json() {
    return const ParsingFailure(
      message: 'Failed to parse response data.',
      code: 'PARSING_JSON_FAILED',
    );
  }

  /// Factory for type conversion failures
  factory ParsingFailure.conversion(String from, String to) {
    return ParsingFailure(
      message: 'Failed to convert from $from to $to.',
      code: 'PARSING_CONVERSION_FAILED',
    );
  }

  @override
  String get userMessage => 'Data processing error. Please try again.';
}

/// Storage-related failures (database, file system)
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for storage initialization failures
  factory StorageFailure.initialization() {
    return const StorageFailure(
      message: 'Failed to initialize storage.',
      code: 'STORAGE_INIT_FAILED',
    );
  }

  /// Factory for storage read failures
  factory StorageFailure.read() {
    return const StorageFailure(
      message: 'Failed to read from storage.',
      code: 'STORAGE_READ_FAILED',
    );
  }

  /// Factory for storage write failures
  factory StorageFailure.write() {
    return const StorageFailure(
      message: 'Failed to write to storage.',
      code: 'STORAGE_WRITE_FAILED',
    );
  }

  /// Factory for storage delete failures
  factory StorageFailure.delete() {
    return const StorageFailure(
      message: 'Failed to delete from storage.',
      code: 'STORAGE_DELETE_FAILED',
    );
  }

  /// Factory for insufficient storage
  factory StorageFailure.insufficient() {
    return const StorageFailure(
      message: 'Insufficient storage space.',
      code: 'STORAGE_INSUFFICIENT',
    );
  }

  @override
  String get userMessage => 'Storage error. Please check available space.';
}

/// Permission-related failures (denied permissions)
class PermissionFailure extends Failure {
  /// Permission that was denied
  final String permission;

  const PermissionFailure({
    required super.message,
    required this.permission,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for denied permissions
  factory PermissionFailure.denied(String permission) {
    return PermissionFailure(
      message: '$permission permission is required.',
      permission: permission,
      code: 'PERMISSION_DENIED',
    );
  }

  /// Factory for permanently denied permissions
  factory PermissionFailure.permanentlyDenied(String permission) {
    return PermissionFailure(
      message:
          '$permission permission was permanently denied. Please enable it in settings.',
      permission: permission,
      code: 'PERMISSION_PERMANENTLY_DENIED',
    );
  }

  @override
  String get userMessage => message;
}

/// Authentication-related failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for invalid credentials
  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password.',
      code: 'AUTH_INVALID_CREDENTIALS',
    );
  }

  /// Factory for expired session
  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      message: 'Your session has expired. Please login again.',
      code: 'AUTH_SESSION_EXPIRED',
    );
  }

  /// Factory for token refresh failure
  factory AuthFailure.refreshFailed() {
    return const AuthFailure(
      message: 'Failed to refresh authentication. Please login again.',
      code: 'AUTH_REFRESH_FAILED',
    );
  }

  @override
  String get userMessage => message;
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  /// Factory for general unknown errors
  factory UnknownFailure.general() {
    return const UnknownFailure(
      message: 'An unexpected error occurred.',
      code: 'UNKNOWN_ERROR',
    );
  }

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}

/// Extension methods for common failure operations
extension FailureExtension on Failure {
  /// Whether this is a network-related failure
  bool get isNetworkFailure => this is NetworkFailure;

  /// Whether this is a server-related failure
  bool get isServerFailure => this is ServerFailure;

  /// Whether this is a validation failure
  bool get isValidationFailure => this is ValidationFailure;

  /// Whether this is a recoverable failure (user can retry)
  bool get isRecoverable {
    return this is NetworkFailure ||
        this is ServerFailure ||
        this is CacheFailure ||
        this is StorageFailure;
  }

  /// Whether this failure should be reported to crash analytics
  bool get shouldReport {
    return this is! ValidationFailure &&
        this is! PermissionFailure &&
        this is! AuthFailure;
  }
}
