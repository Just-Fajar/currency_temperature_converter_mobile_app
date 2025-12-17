/// Base class for all use cases.
///
/// Use cases encapsulate business logic and orchestrate
/// the flow of data between entities and repositories.
///
/// Each use case should have a single responsibility.
abstract class UseCase<T, Params> {
  /// Execute the use case
  ///
  /// [params] Parameters needed for the use case
  ///
  /// Returns the result of the use case execution
  Future<T> call(Params params);
}

/// Use case that doesn't require parameters
abstract class NoParamsUseCase<T> {
  /// Execute the use case without parameters
  Future<T> call();
}
