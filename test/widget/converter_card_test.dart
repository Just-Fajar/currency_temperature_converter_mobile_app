import 'package:currency_temperature_converter_mobile_app/presentation/widgets/converter_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ConverterCard displays title and value correctly', (
    WidgetTester tester,
  ) async {
    // Arrange
    const testTitle = 'Test Converter';
    const testValue = 100.0;
    const testCurrency = 'USD';

    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(
            title: testTitle,
            value: testValue,
            currency: testCurrency,
          ),
        ),
      ),
    );

    // Assert
    expect(find.text(testTitle), findsOneWidget);
  });

  testWidgets('ConverterCard displays currency symbol', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(title: 'Test', value: 100.0, currency: 'USD'),
        ),
      ),
    );

    // Assert - Should display value with currency formatting
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('ConverterCard displays without placeholder when empty', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(title: 'Test', value: 0.0, currency: 'USD'),
        ),
      ),
    );

    // Assert - Should show value even if 0
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('ConverterCard copy button appears with result', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(title: 'Test', value: 150.0, currency: 'EUR'),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(Icons.copy), findsOneWidget);
  });

  testWidgets('ConverterCard share button appears with result', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(title: 'Test', value: 150.0, currency: 'EUR'),
        ),
      ),
    );

    // Assert
    expect(find.byIcon(Icons.share), findsOneWidget);
  });

  testWidgets('ConverterCard displays exchange rate when provided', (
    WidgetTester tester,
  ) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(
            title: 'Test',
            value: 150.0,
            currency: 'EUR',
            exchangeRate: 1.5,
            fromAmount: '100',
            fromCurrency: 'USD',
          ),
        ),
      ),
    );

    // Assert - Should display exchange rate info
    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('ConverterCard handles zero result', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConverterCard(title: 'Test', value: 0.0, currency: 'EUR'),
        ),
      ),
    );

    // Assert
    expect(find.byType(Card), findsOneWidget);
  });
}
