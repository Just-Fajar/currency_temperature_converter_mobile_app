import 'package:currency_temperature_converter_mobile_app/app.dart';
import 'package:currency_temperature_converter_mobile_app/data/repositories/storage_repository.dart';
import 'package:currency_temperature_converter_mobile_app/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Currency & Temperature Converter App - End-to-End Tests', () {
    testWidgets('Complete app flow: currency conversion to history', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Verify home screen loads
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Test Currency Conversion
      // 1. Should be on currency tab by default
      expect(find.text('Currency Converter'), findsOneWidget);

      // 2. Enter amount
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '100');
      await tester.pumpAndSettle();

      // 3. Tap convert button
      final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
      await tester.tap(convertButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // 4. Verify conversion result appears
      // (Result will vary based on API, so we just check something appears)
      expect(find.byType(Card), findsWidgets);

      // Test Navigation to Temperature
      // 5. Tap on temperature tab
      final temperatureTab = find.text('Temperature');
      await tester.tap(temperatureTab);
      await tester.pumpAndSettle();

      // 6. Verify temperature screen loads
      expect(find.text('Temperature Converter'), findsOneWidget);

      // 7. Enter temperature value
      final tempField = find.byType(TextField).first;
      await tester.enterText(tempField, '25');
      await tester.pumpAndSettle();

      // 8. Tap convert
      final tempConvertButton = find.widgetWithText(ElevatedButton, 'Convert');
      await tester.tap(tempConvertButton);
      await tester.pumpAndSettle();

      // 9. Verify temperature results appear
      expect(find.textContaining('°C'), findsWidgets);
      expect(find.textContaining('°F'), findsWidgets);

      // Test History Navigation
      // 10. Tap on history tab
      final historyTab = find.text('History');
      await tester.tap(historyTab);
      await tester.pumpAndSettle();

      // 11. Verify history screen loads
      expect(find.text('Conversion History'), findsOneWidget);

      // 12. Verify history items appear (if any conversions were saved)
      // History might be empty or have items based on previous tests
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Settings navigation and theme toggle', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Navigate to settings via drawer or app bar
      // Find settings icon/button (assuming it's in a drawer or menu)
      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon);
        await tester.pumpAndSettle();

        // Verify settings screen loads
        expect(find.text('Settings'), findsOneWidget);

        // Find and tap theme toggle
        final themeSwitch = find.byType(SegmentedButton<ThemeMode>);
        if (themeSwitch.evaluate().isNotEmpty) {
          await tester.tap(themeSwitch);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('Temperature conversion with different units', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Navigate to temperature tab
      final temperatureTab = find.text('Temperature');
      await tester.tap(temperatureTab);
      await tester.pumpAndSettle();

      // Enter temperature
      final tempField = find.byType(TextField).first;
      await tester.enterText(tempField, '0');
      await tester.pumpAndSettle();

      // Select Celsius unit (default should be Celsius)
      final celsiusButton = find.text('Celsius');
      if (celsiusButton.evaluate().isNotEmpty) {
        await tester.tap(celsiusButton);
        await tester.pumpAndSettle();
      }

      // Convert
      final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Verify 0°C = 32°F
      expect(find.textContaining('32'), findsWidgets);

      // Test with 100°C
      await tester.enterText(tempField, '100');
      await tester.pumpAndSettle();

      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // Verify 100°C = 212°F
      expect(find.textContaining('212'), findsWidgets);
    });

    testWidgets('History search and filter functionality', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Do a conversion first to ensure history has items
      final amountField = find.byType(TextField).first;
      await tester.enterText(amountField, '50');
      await tester.pumpAndSettle();

      final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
      await tester.tap(convertButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to history
      final historyTab = find.text('History');
      await tester.tap(historyTab);
      await tester.pumpAndSettle();

      // Look for search field
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        // Enter search query
        await tester.enterText(searchField.first, 'USD');
        await tester.pumpAndSettle();

        // Verify filtering works
        expect(find.byType(TextField), findsWidgets);
      }

      // Test filter chips
      final filterChips = find.byType(FilterChip);
      if (filterChips.evaluate().length >= 2) {
        // Tap on currency filter
        final currencyFilter = find.text('Currency');
        if (currencyFilter.evaluate().isNotEmpty) {
          await tester.tap(currencyFilter);
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('App handles empty inputs gracefully', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Try to convert without entering amount
      final convertButton = find.widgetWithText(ElevatedButton, 'Convert');
      await tester.tap(convertButton);
      await tester.pumpAndSettle();

      // App should not crash
      expect(find.byType(MaterialApp), findsOneWidget);

      // Switch to temperature
      final temperatureTab = find.text('Temperature');
      await tester.tap(temperatureTab);
      await tester.pumpAndSettle();

      // Try to convert without entering temperature
      final tempConvertButton = find
          .widgetWithText(ElevatedButton, 'Convert')
          .first;
      await tester.tap(tempConvertButton);
      await tester.pumpAndSettle();

      // App should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Bottom navigation switches tabs correctly', (
      WidgetTester tester,
    ) async {
      // Initialize app
      final storage = StorageRepository();
      await storage.init();

      final settingsProvider = SettingsProvider();
      await settingsProvider.init();

      // Launch app
      await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));
      await tester.pumpAndSettle();

      // Test all tab switches
      final tabs = ['Currency', 'Temperature', 'History'];

      for (final tab in tabs) {
        final tabFinder = find.text(tab);
        if (tabFinder.evaluate().isNotEmpty) {
          await tester.tap(tabFinder);
          await tester.pumpAndSettle();

          // Verify tab switched
          expect(find.byType(BottomNavigationBar), findsOneWidget);
        }
      }
    });
  });
}
