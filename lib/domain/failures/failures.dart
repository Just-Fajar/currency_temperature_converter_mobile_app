/// Base class for all failures in the domain layer.
///
/// Failures represent errors that can occur during business logic execution.
/// They are separate from exceptions and provide more context.
abstract class Failure {
  /// Human-readable error message
  final String message;

  /// Optional error code for categorization
  final String? code;

  /// Original error if available
  final dynamic originalError;

  const Failure({required this.message, this.code, this.originalError});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Network-related failures (connection, timeout, etc.)
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Cache-related failures (read/write errors)
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.originalError});
}

/// Validation failures (invalid input, constraints)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Server-related failures (4xx, 5xx errors)
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
    super.originalError,
  });
}
