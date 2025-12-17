import '../../core/errors/failures.dart';

/// Result type for domain layer operations.
///
/// Represents either a successful result with data [Success]
/// or a failure with error information [Error].
///
/// This is a type-safe way to handle errors without exceptions.
///
/// Example:
/// ```dart
/// Future<Result<double>> divide(double a, double b) async {
///   if (b == 0) {
///     return Error(ValidationFailure(message: 'Cannot divide by zero'));
///   }
///   return Success(a / b);
/// }
///
/// final result = await divide(10, 2);
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (value) => print('Result: $value'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Check if result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Fold the result into a single value
  R fold<R>(R Function(Failure failure) onError, R Function(T data) onSuccess) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      return onError((this as Error<T>).failure);
    }
  }

  /// Get data if successful, otherwise return null
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;

  /// Get failure if error, otherwise return null
  Failure? get failureOrNull =>
      this is Error<T> ? (this as Error<T>).failure : null;
}

/// Successful result with data
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

/// Error result with failure
class Error<T> extends Result<T> {
  final Failure failure;

  const Error(this.failure);

  @override
  String toString() => 'Error(failure: $failure)';
}

/// Extension methods for Result type
extension ResultExtension<T> on Result<T> {
  /// Map the success value to another type
  Result<R> map<R>(R Function(T data) transform) {
    return fold(
      (failure) => Error<R>(failure),
      (data) => Success(transform(data)),
    );
  }

  /// FlatMap for chaining Result-returning operations
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return fold((failure) => Error<R>(failure), (data) => transform(data));
  }

  /// Get data or throw exception
  T getOrThrow() {
    return fold((failure) => throw Exception(failure.message), (data) => data);
  }

  /// Get data or return default value
  T getOrElse(T defaultValue) {
    return fold((_) => defaultValue, (data) => data);
  }

  /// Get data or compute from failure
  T getOrHandle(T Function(Failure failure) handler) {
    return fold((failure) => handler(failure), (data) => data);
  }

  /// Execute side effect on success
  Result<T> onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  /// Execute side effect on error
  Result<T> onError(void Function(Failure failure) callback) {
    if (this is Error<T>) {
      callback((this as Error<T>).failure);
    }
    return this;
  }

  /// Convert to Future
  Future<Result<T>> toFuture() async => this;

  /// Recover from error with fallback value
  Result<T> recover(T Function(Failure failure) recovery) {
    return fold(
      (failure) => Success(recovery(failure)),
      (data) => Success(data),
    );
  }

  /// Recover from error with fallback Result
  Result<T> recoverWith(Result<T> Function(Failure failure) recovery) {
    return fold((failure) => recovery(failure), (data) => Success(data));
  }
}

/// Extension for Future&lt;Result&lt;T&gt;&gt;
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Map the success value
  Future<Result<R>> map<R>(R Function(T data) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// FlatMap for chaining
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    final result = await this;
    return result.fold(
      (failure) => Error<R>(failure),
      (data) => transform(data),
    );
  }

  /// Get data or return default
  Future<T> getOrElse(T defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Execute side effect on success
  Future<Result<T>> onSuccess(void Function(T data) callback) async {
    final result = await this;
    return result.onSuccess(callback);
  }

  /// Execute side effect on error
  Future<Result<T>> onError(void Function(Failure failure) callback) async {
    final result = await this;
    return result.onError(callback);
  }
}

/// Utility functions for working with Results
class Results {
  Results._();

  /// Combine multiple Results into a single Result of List
  static Result<List<T>> all<T>(List<Result<T>> results) {
    final List<T> values = [];

    for (final result in results) {
      if (result is Error<T>) {
        return Error(result.failure);
      }
      values.add((result as Success<T>).data);
    }

    return Success(values);
  }

  /// Execute async operation and wrap in Result
  static Future<Result<T>> tryCatch<T>(
    Future<T> Function() operation, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      final data = await operation();
      return Success(data);
    } catch (e, stackTrace) {
      if (onError != null) {
        return Error(onError(e, stackTrace));
      }
      return Error(
        UnknownFailure(
          message: e.toString(),
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Execute sync operation and wrap in Result
  static Result<T> tryCatchSync<T>(
    T Function() operation, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) {
    try {
      final data = operation();
      return Success(data);
    } catch (e, stackTrace) {
      if (onError != null) {
        return Error(onError(e, stackTrace));
      }
      return Error(
        UnknownFailure(
          message: e.toString(),
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
