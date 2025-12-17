import '../core/result.dart';
import '../entities/exchange_rates.dart';
import '../repositories/i_currency_repository.dart';
import 'usecase.dart';

/// Use case for getting exchange rates with caching support.
///
/// Handles:
/// - Cache validation
/// - API calls when cache is stale
/// - Error handling
///
/// Example:
/// ```dart
/// final useCase = GetExchangeRatesUseCase(currencyRepository);
/// final result = await useCase(GetExchangeRatesParams(
///   from: 'USD',
///   to: 'EUR',
/// ));
/// ```
class GetExchangeRatesUseCase
    implements UseCase<Result<ExchangeRates>, GetExchangeRatesParams> {
  final ICurrencyRepository _repository;

  GetExchangeRatesUseCase(this._repository);

  @override
  Future<Result<ExchangeRates>> call(GetExchangeRatesParams params) async {
    return await _repository.getExchangeRates(from: params.from, to: params.to);
  }
}

/// Parameters for getting exchange rates
class GetExchangeRatesParams {
  final String from;
  final String to;

  const GetExchangeRatesParams({required this.from, required this.to});
}
