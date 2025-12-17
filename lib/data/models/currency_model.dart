/// Currency model for API response and local storage
class CurrencyModel {
  final String code;
  final String name;
  final String symbol;
  final double rate; // Rate relative to base currency

  CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  // From JSON
  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'symbol': symbol,
      'rate': rate,
    };
  }

  // Copy with
  CurrencyModel copyWith({
    String? code,
    String? name,
    String? symbol,
    double? rate,
  }) {
    return CurrencyModel(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      rate: rate ?? this.rate,
    );
  }

  @override
  String toString() {
    return 'CurrencyModel(code: $code, name: $name, symbol: $symbol, rate: $rate)';
  }
}

/// Exchange rates response model
class ExchangeRatesModel {
  final String base;
  final DateTime date;
  final Map<String, double> rates;

  ExchangeRatesModel({
    required this.base,
    required this.date,
    required this.rates,
  });

  // From JSON (ExchangeRate-API format)
  factory ExchangeRatesModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRatesModel(
      base: json['base'] as String,
      date: DateTime.parse(json['date'] as String),
      rates: (json['rates'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'date': date.toIso8601String(),
      'rates': rates,
    };
  }

  /// Convert amount from one currency to another
  double convert(double amount, String from, String to) {
    if (from == to) return amount;
    
    // Convert to base currency first
    final fromRate = from == base ? 1.0 : rates[from];
    final toRate = to == base ? 1.0 : rates[to];
    
    if (fromRate == null || toRate == null) {
      throw Exception('Currency not found in rates');
    }
    
    // Convert: amount (from) -> base -> to
    final baseAmount = amount / fromRate;
    return baseAmount * toRate;
  }

  @override
  String toString() {
    return 'ExchangeRatesModel(base: $base, date: $date, rates: ${rates.length} currencies)';
  }
}
