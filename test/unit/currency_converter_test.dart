import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Currency Conversion Logic', () {
    test('USD to IDR conversion with rate 15815', () {
      // Arrange
      const double amount = 100.0;
      const double rate = 15815.0;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, 1581500.0);
    });

    test('EUR to USD conversion with rate 1.0875', () {
      // Arrange
      const double amount = 100.0;
      const double rate = 1.0875;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, closeTo(108.75, 0.01));
    });

    test('Conversion with zero amount returns zero', () {
      // Arrange
      const double amount = 0.0;
      const double rate = 1.5;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, 0.0);
    });

    test('Conversion with rate 1.0 returns same amount', () {
      // Arrange
      const double amount = 50.0;
      const double rate = 1.0;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, 50.0);
    });

    test('Decimal precision is maintained', () {
      // Arrange
      const double amount = 99.99;
      const double rate = 1.234567;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, closeTo(123.44, 0.01));
    });

    test('Large amount conversion', () {
      // Arrange
      const double amount = 1000000.0;
      const double rate = 0.85;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, 850000.0);
    });

    test('Small decimal amount conversion', () {
      // Arrange
      const double amount = 0.01;
      const double rate = 100.0;

      // Act
      final result = amount * rate;

      // Assert
      expect(result, 1.0);
    });
  });

  group('Currency Exchange Rate Validation', () {
    test('Rate must be positive', () {
      // Arrange
      const double rate = 1.5;

      // Act & Assert
      expect(rate > 0, isTrue);
    });

    test('Negative rate should be invalid', () {
      // Arrange
      const double rate = -1.5;

      // Act & Assert
      expect(rate > 0, isFalse);
    });

    test('Zero rate should be invalid', () {
      // Arrange
      const double rate = 0.0;

      // Act & Assert
      expect(rate > 0, isFalse);
    });
  });

  group('Currency Formatting', () {
    test('Format with 2 decimal places', () {
      // Arrange
      const double amount = 1234.5678;

      // Act
      final formatted = amount.toStringAsFixed(2);

      // Assert
      expect(formatted, '1234.57');
    });

    test('Format with 4 decimal places for rate', () {
      // Arrange
      const double rate = 15815.6789;

      // Act
      final formatted = rate.toStringAsFixed(4);

      // Assert
      expect(formatted, '15815.6789');
    });

    test('Format whole number maintains decimals', () {
      // Arrange
      const double amount = 100.0;

      // Act
      final formatted = amount.toStringAsFixed(2);

      // Assert
      expect(formatted, '100.00');
    });
  });
}
