import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Number Input Validation', () {
    bool isValidNumber(String input) {
      if (input.isEmpty) return false;
      final number = double.tryParse(input);
      return number != null;
    }

    test('Valid integer is accepted', () {
      expect(isValidNumber('100'), isTrue);
    });

    test('Valid decimal is accepted', () {
      expect(isValidNumber('99.99'), isTrue);
    });

    test('Valid negative number is accepted', () {
      expect(isValidNumber('-10'), isTrue);
    });

    test('Empty string is rejected', () {
      expect(isValidNumber(''), isFalse);
    });

    test('Alphabetic characters are rejected', () {
      expect(isValidNumber('abc'), isFalse);
    });

    test('Mixed alphanumeric is rejected', () {
      expect(isValidNumber('100abc'), isFalse);
    });

    test('Special characters are rejected', () {
      expect(isValidNumber(r'$100'), isFalse);
    });

    test('Multiple decimal points are rejected', () {
      expect(isValidNumber('10.5.5'), isFalse);
    });

    test('Leading zero with decimal is valid', () {
      expect(isValidNumber('0.5'), isTrue);
    });

    test('Zero is valid', () {
      expect(isValidNumber('0'), isTrue);
    });
  });

  group('Kelvin Temperature Validation', () {
    bool isValidKelvin(double value) {
      return value >= 0;
    }

    test('Positive Kelvin is valid', () {
      expect(isValidKelvin(300), isTrue);
    });

    test('Zero Kelvin (absolute zero) is valid', () {
      expect(isValidKelvin(0), isTrue);
    });

    test('Negative Kelvin is invalid', () {
      expect(isValidKelvin(-10), isFalse);
    });

    test('Very large Kelvin value is valid', () {
      expect(isValidKelvin(10000), isTrue);
    });
  });

  group('Currency Amount Validation', () {
    bool isValidCurrencyAmount(String input) {
      if (input.isEmpty) return false;
      final amount = double.tryParse(input);
      if (amount == null) return false;
      return amount >= 0;
    }

    test('Valid positive amount', () {
      expect(isValidCurrencyAmount('100'), isTrue);
    });

    test('Valid decimal amount', () {
      expect(isValidCurrencyAmount('99.99'), isTrue);
    });

    test('Zero is valid', () {
      expect(isValidCurrencyAmount('0'), isTrue);
    });

    test('Negative amount is invalid for currency', () {
      expect(isValidCurrencyAmount('-100'), isFalse);
    });

    test('Empty input is invalid', () {
      expect(isValidCurrencyAmount(''), isFalse);
    });

    test('Non-numeric input is invalid', () {
      expect(isValidCurrencyAmount('invalid'), isFalse);
    });

    test('Very large amount is valid', () {
      expect(isValidCurrencyAmount('1000000'), isTrue);
    });

    test('Small decimal amount is valid', () {
      expect(isValidCurrencyAmount('0.01'), isTrue);
    });
  });

  group('Input Sanitization', () {
    String sanitizeInput(String input) {
      return input.trim().replaceAll(',', '');
    }

    test('Remove leading/trailing spaces', () {
      expect(sanitizeInput('  100  '), '100');
    });

    test('Remove commas from thousands separator', () {
      expect(sanitizeInput('1,000'), '1000');
    });

    test('Remove multiple commas', () {
      expect(sanitizeInput('1,000,000'), '1000000');
    });

    test('Handle mixed whitespace and commas', () {
      expect(sanitizeInput(' 1,000 '), '1000');
    });
  });

  group('Decimal Places Validation', () {
    bool hasValidDecimalPlaces(String input, int maxDecimals) {
      if (!input.contains('.')) return true;
      final parts = input.split('.');
      if (parts.length != 2) return false;
      return parts[1].length <= maxDecimals;
    }

    test('2 decimal places is valid for max 2', () {
      expect(hasValidDecimalPlaces('10.99', 2), isTrue);
    });

    test('3 decimal places is invalid for max 2', () {
      expect(hasValidDecimalPlaces('10.999', 2), isFalse);
    });

    test('No decimal point is valid', () {
      expect(hasValidDecimalPlaces('100', 2), isTrue);
    });

    test('1 decimal place is valid for max 2', () {
      expect(hasValidDecimalPlaces('10.5', 2), isTrue);
    });

    test('6 decimal places is valid for max 6', () {
      expect(hasValidDecimalPlaces('10.123456', 6), isTrue);
    });

    test('7 decimal places is invalid for max 6', () {
      expect(hasValidDecimalPlaces('10.1234567', 6), isFalse);
    });
  });

  group('Range Validation', () {
    bool isWithinRange(double value, double min, double max) {
      return value >= min && value <= max;
    }

    test('Value within range is valid', () {
      expect(isWithinRange(50, 0, 100), isTrue);
    });

    test('Value at minimum boundary is valid', () {
      expect(isWithinRange(0, 0, 100), isTrue);
    });

    test('Value at maximum boundary is valid', () {
      expect(isWithinRange(100, 0, 100), isTrue);
    });

    test('Value below minimum is invalid', () {
      expect(isWithinRange(-10, 0, 100), isFalse);
    });

    test('Value above maximum is invalid', () {
      expect(isWithinRange(150, 0, 100), isFalse);
    });
  });
}
