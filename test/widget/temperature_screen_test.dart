import 'package:currency_temperature_converter_mobile_app/presentation/providers/temperature_provider.dart';
import 'package:currency_temperature_converter_mobile_app/presentation/screens/temperature_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('TemperatureScreen displays correctly', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Assert
    expect(find.byType(TemperatureScreen), findsOneWidget);
  });

  testWidgets('TemperatureScreen has input field', (WidgetTester tester) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Assert
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('TemperatureScreen has unit selector', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Assert
    expect(find.byType(SegmentedButton<String>), findsOneWidget);
  });

  testWidgets('TemperatureScreen displays all temperature units', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert - Should show Celsius, Fahrenheit, Kelvin, Reamur
    expect(find.text('Celsius'), findsWidgets);
    expect(find.text('Fahrenheit'), findsWidgets);
    expect(find.text('Kelvin'), findsWidgets);
    expect(find.text('Reamur'), findsWidgets);
  });

  testWidgets('TemperatureScreen can input temperature value', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Enter temperature value
    final textField = find.byType(TextField);
    await tester.enterText(textField, '25');
    await tester.pump();

    // Assert
    expect(find.text('25'), findsOneWidget);
  });

  testWidgets('TemperatureScreen has convert button', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Assert
    expect(find.widgetWithText(ElevatedButton, 'Convert'), findsOneWidget);
  });

  testWidgets('TemperatureScreen shows result cards after conversion', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Enter value and convert
    final textField = find.byType(TextField);
    await tester.enterText(textField, '25');
    await tester.pump();

    final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
    await tester.tap(convertButton);
    await tester.pumpAndSettle();

    // Assert - Should display result cards
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('TemperatureScreen displays temperature symbols', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();
    temperatureProvider.setInputValue(25.0);
    temperatureProvider.setSelectedUnit('Celsius');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert - Should show temperature symbols (°C, °F, K, °Ré)
    expect(find.textContaining('°C'), findsWidgets);
    expect(find.textContaining('°F'), findsWidgets);
    expect(find.textContaining('K'), findsWidgets);
  });

  testWidgets('TemperatureScreen copy buttons appear on result cards', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();
    temperatureProvider.setInputValue(25.0);
    temperatureProvider.setSelectedUnit('Celsius');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert - Should have copy icons
    expect(find.byIcon(Icons.copy), findsWidgets);
  });

  testWidgets('TemperatureScreen handles empty input', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Tap convert without input
    final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
    await tester.tap(convertButton);
    await tester.pump();

    // Assert - Should not crash
    expect(find.byType(TemperatureScreen), findsOneWidget);
  });

  testWidgets('TemperatureScreen handles zero input', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Enter zero and convert
    final textField = find.byType(TextField);
    await tester.enterText(textField, '0');
    await tester.pump();

    final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
    await tester.tap(convertButton);
    await tester.pumpAndSettle();

    // Assert - Should show results for 0 degrees
    expect(find.text('0'), findsWidgets);
  });

  testWidgets('TemperatureScreen handles negative values', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    // Enter negative value
    final textField = find.byType(TextField);
    await tester.enterText(textField, '-40');
    await tester.pump();

    final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
    await tester.tap(convertButton);
    await tester.pumpAndSettle();

    // Assert - Should handle negative temperatures
    expect(find.text('-40'), findsWidgets);
  });

  testWidgets('TemperatureScreen share button exists', (
    WidgetTester tester,
  ) async {
    // Arrange
    final temperatureProvider = TemperatureProvider();
    temperatureProvider.setInputValue(25.0);
    temperatureProvider.setSelectedUnit('Celsius');

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: temperatureProvider,
          child: const TemperatureScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Assert
    expect(find.byIcon(Icons.share), findsOneWidget);
  });
}
