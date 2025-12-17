import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Celsius to Fahrenheit', () {
    double celsiusToFahrenheit(double celsius) {
      return (celsius * 9 / 5) + 32;
    }

    test('0°C converts to 32°F', () {
      expect(celsiusToFahrenheit(0), 32.0);
    });

    test('100°C converts to 212°F (boiling point)', () {
      expect(celsiusToFahrenheit(100), 212.0);
    });

    test('25°C converts to 77°F (room temperature)', () {
      expect(celsiusToFahrenheit(25), 77.0);
    });

    test('-40°C converts to -40°F', () {
      expect(celsiusToFahrenheit(-40), -40.0);
    });

    test('Negative temperature conversion', () {
      expect(celsiusToFahrenheit(-10), 14.0);
    });
  });

  group('Celsius to Kelvin', () {
    double celsiusToKelvin(double celsius) {
      return celsius + 273.15;
    }

    test('0°C converts to 273.15K', () {
      expect(celsiusToKelvin(0), 273.15);
    });

    test('100°C converts to 373.15K', () {
      expect(celsiusToKelvin(100), 373.15);
    });

    test('25°C converts to 298.15K', () {
      expect(celsiusToKelvin(25), 298.15);
    });

    test('-273.15°C converts to 0K (absolute zero)', () {
      expect(celsiusToKelvin(-273.15), 0.0);
    });

    test('Negative celsius converts correctly', () {
      expect(celsiusToKelvin(-50), closeTo(223.15, 0.01));
    });
  });

  group('Celsius to Reamur', () {
    double celsiusToReamur(double celsius) {
      return celsius * 4 / 5;
    }

    test('0°C converts to 0°Ré', () {
      expect(celsiusToReamur(0), 0.0);
    });

    test('100°C converts to 80°Ré', () {
      expect(celsiusToReamur(100), 80.0);
    });

    test('25°C converts to 20°Ré', () {
      expect(celsiusToReamur(25), 20.0);
    });

    test('Negative temperature conversion', () {
      expect(celsiusToReamur(-10), -8.0);
    });
  });

  group('Fahrenheit to Celsius', () {
    double fahrenheitToCelsius(double fahrenheit) {
      return (fahrenheit - 32) * 5 / 9;
    }

    test('32°F converts to 0°C', () {
      expect(fahrenheitToCelsius(32), 0.0);
    });

    test('212°F converts to 100°C', () {
      expect(fahrenheitToCelsius(212), 100.0);
    });

    test('77°F converts to 25°C', () {
      expect(fahrenheitToCelsius(77), 25.0);
    });

    test('-40°F converts to -40°C', () {
      expect(fahrenheitToCelsius(-40), -40.0);
    });
  });

  group('Kelvin to Celsius', () {
    double kelvinToCelsius(double kelvin) {
      return kelvin - 273.15;
    }

    test('273.15K converts to 0°C', () {
      expect(kelvinToCelsius(273.15), 0.0);
    });

    test('373.15K converts to 100°C', () {
      expect(kelvinToCelsius(373.15), 100.0);
    });

    test('0K converts to -273.15°C (absolute zero)', () {
      expect(kelvinToCelsius(0), -273.15);
    });
  });

  group('Reamur to Celsius', () {
    double reamurToCelsius(double reamur) {
      return reamur * 5 / 4;
    }

    test('0°Ré converts to 0°C', () {
      expect(reamurToCelsius(0), 0.0);
    });

    test('80°Ré converts to 100°C', () {
      expect(reamurToCelsius(80), 100.0);
    });

    test('20°Ré converts to 25°C', () {
      expect(reamurToCelsius(20), 25.0);
    });
  });

  group('Temperature Validation', () {
    test('Kelvin cannot be negative', () {
      const double kelvin = -10.0;
      expect(kelvin >= 0, isFalse);
    });

    test('Valid Kelvin temperature', () {
      const double kelvin = 300.0;
      expect(kelvin >= 0, isTrue);
    });

    test('Absolute zero is 0 Kelvin', () {
      const double absoluteZero = 0.0;
      expect(absoluteZero, 0.0);
    });
  });

  group('Conversion Precision', () {
    test('Celsius to Fahrenheit maintains precision', () {
      const double celsius = 37.5;
      final fahrenheit = (celsius * 9 / 5) + 32;
      expect(fahrenheit, closeTo(99.5, 0.01));
    });

    test('Round-trip conversion Celsius -> Fahrenheit -> Celsius', () {
      const double original = 25.0;
      final fahrenheit = (original * 9 / 5) + 32;
      final backToCelsius = (fahrenheit - 32) * 5 / 9;
      expect(backToCelsius, closeTo(original, 0.001));
    });

    test('Round-trip conversion Celsius -> Kelvin -> Celsius', () {
      const double original = 50.0;
      final kelvin = original + 273.15;
      final backToCelsius = kelvin - 273.15;
      expect(backToCelsius, closeTo(original, 0.001));
    });
  });
}
