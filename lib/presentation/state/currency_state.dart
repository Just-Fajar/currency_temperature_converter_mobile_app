/// Sealed class representing all possible states of currency conversion.
///
/// Using sealed classes provides:
/// - Exhaustive pattern matching
/// - Type safety
/// - Clear state representation
///
/// Example:
/// ```dart
/// switch (state) {
///   case CurrencyInitial():
///     return Text('Enter amount');
///   case CurrencyLoading():
///     return CircularProgressIndicator();
///   case CurrencySuccess():
///     return Text('Result: ${state.result}');
///   case CurrencyError():
///     return Text('Error: ${state.message}');
///   case CurrencyOffline():
///     return Text('Offline: ${state.cachedResult}');
/// }
/// ```
sealed class CurrencyState {
  const CurrencyState();
}

/// Initial state - no conversion performed yet
class CurrencyInitial extends CurrencyState {
  const CurrencyInitial();
}

/// Loading state - conversion in progress
class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

/// Success state - conversion completed successfully
class CurrencySuccess extends CurrencyState {
  final double result;
  final double exchangeRate;
  final String fromCurrency;
  final String toCurrency;
  final DateTime timestamp;

  const CurrencySuccess({
    required this.result,
    required this.exchangeRate,
    required this.fromCurrency,
    required this.toCurrency,
    required this.timestamp,
  });

  @override
  String toString() => 'CurrencySuccess(result: $result, rate: $exchangeRate)';
}

/// Error state - conversion failed
class CurrencyError extends CurrencyState {
  final String message;
  final String? code;

  const CurrencyError({required this.message, this.code});

  @override
  String toString() => 'CurrencyError(message: $message)';
}

/// Offline state - using cached rates
class CurrencyOffline extends CurrencyState {
  final double cachedResult;
  final double cachedRate;
  final DateTime lastUpdate;
  final String message;

  const CurrencyOffline({
    required this.cachedResult,
    required this.cachedRate,
    required this.lastUpdate,
    required this.message,
  });

  @override
  String toString() =>
      'CurrencyOffline(cachedResult: $cachedResult, lastUpdate: $lastUpdate)';
}
