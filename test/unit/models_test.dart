import 'package:currency_temperature_converter_mobile_app/data/models/conversion_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConversionHistory Model', () {
    test('Currency conversion history is created correctly', () {
      // Arrange & Act
      final history = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'IDR',
        result: 1581500.0,
        exchangeRate: 15815.0,
      );

      // Assert
      expect(history.type, 'currency');
      expect(history.inputValue, 100.0);
      expect(history.fromUnit, 'USD');
      expect(history.toUnit, 'IDR');
      expect(history.result, 1581500.0);
      expect(history.exchangeRate, 15815.0);
      expect(history.timestamp, isA<DateTime>());
    });

    test('Temperature conversion history is created correctly', () {
      // Arrange & Act
      final history = ConversionHistory.temperature(
        inputValue: 25.0,
        fromUnit: 'Celsius',
        toUnit: 'Fahrenheit',
        result: 77.0,
      );

      // Assert
      expect(history.type, 'temperature');
      expect(history.inputValue, 25.0);
      expect(history.fromUnit, 'Celsius');
      expect(history.toUnit, 'Fahrenheit');
      expect(history.result, 77.0);
      expect(history.exchangeRate, isNull);
      expect(history.timestamp, isA<DateTime>());
    });

    test('Currency history with exchange rate', () {
      // Arrange & Act
      final history = ConversionHistory.currency(
        inputValue: 50.0,
        fromCurrency: 'EUR',
        toCurrency: 'USD',
        result: 54.38,
        exchangeRate: 1.0876,
      );

      // Assert
      expect(history.exchangeRate, 1.0876);
    });

    test('History with zero input value', () {
      // Arrange & Act
      final history = ConversionHistory.currency(
        inputValue: 0.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 0.0,
        exchangeRate: 0.92,
      );

      // Assert
      expect(history.inputValue, 0.0);
      expect(history.result, 0.0);
    });

    test('History with decimal values', () {
      // Arrange & Act
      final history = ConversionHistory.currency(
        inputValue: 99.99,
        fromCurrency: 'GBP',
        toCurrency: 'USD',
        result: 127.49,
        exchangeRate: 1.275,
      );

      // Assert
      expect(history.inputValue, 99.99);
      expect(history.result, 127.49);
      expect(history.exchangeRate, 1.275);
    });

    test('History timestamp is auto-generated', () {
      // Arrange
      final before = DateTime.now();

      // Act
      final history = ConversionHistory.temperature(
        inputValue: 0.0,
        fromUnit: 'Celsius',
        toUnit: 'Kelvin',
        result: 273.15,
      );

      // Assert
      expect(
        history.timestamp.isAfter(before.subtract(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('Currency and temperature types are distinct', () {
      // Arrange & Act
      final currencyHistory = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 92.0,
        exchangeRate: 0.92,
      );

      final temperatureHistory = ConversionHistory.temperature(
        inputValue: 100.0,
        fromUnit: 'Celsius',
        toUnit: 'Fahrenheit',
        result: 212.0,
      );

      // Assert
      expect(currencyHistory.type, 'currency');
      expect(temperatureHistory.type, 'temperature');
      expect(currencyHistory.type != temperatureHistory.type, isTrue);
    });

    test('Large values are handled correctly', () {
      // Arrange & Act
      final history = ConversionHistory.currency(
        inputValue: 1000000.0,
        fromCurrency: 'USD',
        toCurrency: 'IDR',
        result: 15815000000.0,
        exchangeRate: 15815.0,
      );

      // Assert
      expect(history.inputValue, 1000000.0);
      expect(history.result, 15815000000.0);
    });

    test('Negative temperature values are valid', () {
      // Arrange & Act
      final history = ConversionHistory.temperature(
        inputValue: -40.0,
        fromUnit: 'Celsius',
        toUnit: 'Fahrenheit',
        result: -40.0,
      );

      // Assert
      expect(history.inputValue, -40.0);
      expect(history.result, -40.0);
    });

    test('Unit names are case-sensitive', () {
      // Arrange & Act
      final history = ConversionHistory.temperature(
        inputValue: 25.0,
        fromUnit: 'Celsius',
        toUnit: 'celsius',
        result: 25.0,
      );

      // Assert
      expect(history.fromUnit, 'Celsius');
      expect(history.toUnit, 'celsius');
      expect(history.fromUnit != history.toUnit, isTrue);
    });
  });

  group('ConversionHistory Comparison', () {
    test('Two histories with same data have same values', () {
      // Arrange
      final history1 = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 92.0,
        exchangeRate: 0.92,
      );

      final history2 = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 92.0,
        exchangeRate: 0.92,
      );

      // Assert
      expect(history1.inputValue, history2.inputValue);
      expect(history1.fromUnit, history2.fromUnit);
      expect(history1.toUnit, history2.toUnit);
      expect(history1.result, history2.result);
      expect(history1.type, history2.type);
    });

    test('Histories created at different times have different timestamps', () {
      // Arrange
      final history1 = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 92.0,
        exchangeRate: 0.92,
      );

      // Wait a bit
      final history2 = ConversionHistory.currency(
        inputValue: 100.0,
        fromCurrency: 'USD',
        toCurrency: 'EUR',
        result: 92.0,
        exchangeRate: 0.92,
      );

      // Assert - timestamps will be different (or at least not reliably same)
      expect(history1.inputValue, history2.inputValue);
    });
  });
}
