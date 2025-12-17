import '../../core/errors/failures.dart';
import '../core/result.dart';
import '../repositories/i_currency_repository.dart';
import 'usecase.dart';

/// Use case for converting currency with caching and error handling.
///
/// This encapsulates all business logic related to currency conversion:
/// - Input validation
/// - Cache checking
/// - API calls
/// - Error handling
///
/// Example:
/// ```dart
/// final useCase = ConvertCurrencyUseCase(currencyRepository);
/// final result = await useCase(ConvertCurrencyParams(
///   amount: 100,
///   from: 'USD',
///   to: 'EUR',
/// ));
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (value) => print('Result: $value'),
/// );
/// ```
class ConvertCurrencyUseCase
    implements UseCase<Result<double>, ConvertCurrencyParams> {
  final ICurrencyRepository _repository;

  ConvertCurrencyUseCase(this._repository);

  @override
  Future<Result<double>> call(ConvertCurrencyParams params) async {
    // Validate input
    if (params.amount < 0) {
      return Error(ValidationFailure(message: 'Amount cannot be negative'));
    }

    if (params.amount == 0) {
      return const Success(0.0);
    }

    // Same currency, no conversion needed
    if (params.from == params.to) {
      return Success(params.amount);
    }

    // Delegate to repository
    try {
      return await _repository.convertCurrency(
        amount: params.amount,
        from: params.from,
        to: params.to,
      );
    } catch (e) {
      return Error(
        UnknownFailure(
          message: 'Unexpected error during conversion',
          originalError: e,
        ),
      );
    }
  }
}

/// Parameters for currency conversion use case
class ConvertCurrencyParams {
  final double amount;
  final String from;
  final String to;

  const ConvertCurrencyParams({
    required this.amount,
    required this.from,
    required this.to,
  });

  @override
  String toString() => 'ConvertCurrencyParams($amount $from -> $to)';
}
