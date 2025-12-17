import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/storage_repository.dart';
import 'presentation/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storage = StorageRepository();
  await storage.init();

  // Initialize settings
  final settingsProvider = SettingsProvider();
  await settingsProvider.init();

  runApp(MyApp(settingsProvider: settingsProvider));
}
