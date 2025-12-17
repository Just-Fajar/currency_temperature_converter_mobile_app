/// Sealed class representing loading states for async operations.
///
/// Generic loading state that can be used across different features.
///
/// Example:
/// ```dart
/// LoadingState<List<User>> state;
/// switch (state) {
///   case LoadingIdle():
///     return Text('Start loading');
///   case LoadingInProgress():
///     return CircularProgressIndicator();
///   case LoadingSuccess():
///     return UserList(state.data);
///   case LoadingFailure():
///     return ErrorWidget(state.message);
/// }
/// ```
sealed class LoadingState<T> {
  const LoadingState();
}

/// Idle state - no operation in progress
class LoadingIdle<T> extends LoadingState<T> {
  const LoadingIdle();
}

/// In progress state - operation is running
class LoadingInProgress<T> extends LoadingState<T> {
  final double? progress;

  const LoadingInProgress({this.progress});
}

/// Success state - operation completed successfully
class LoadingSuccess<T> extends LoadingState<T> {
  final T data;

  const LoadingSuccess(this.data);
}

/// Failure state - operation failed
class LoadingFailure<T> extends LoadingState<T> {
  final String message;
  final String? code;

  const LoadingFailure({required this.message, this.code});
}
