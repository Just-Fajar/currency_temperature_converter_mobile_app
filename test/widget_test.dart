// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:currency_temperature_converter_mobile_app/app.dart';
import 'package:currency_temperature_converter_mobile_app/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App should build without error', (WidgetTester tester) async {
    // Create a test settings provider
    final settingsProvider = SettingsProvider();
    await settingsProvider.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(settingsProvider: settingsProvider));

    // Verify app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
