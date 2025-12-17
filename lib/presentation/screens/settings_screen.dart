import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';

/// Settings screen for app preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          // Reset to defaults button
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset to defaults',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text(
                    'Are you sure you want to reset all settings to defaults?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                await context.read<SettingsProvider>().resetToDefaults();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings reset to defaults'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView(
            children: [
              // Currency Settings
              const _SectionHeader(title: 'Currency Settings'),
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Default Currency'),
                subtitle: Text(settings.defaultCurrency),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyPicker(context, settings),
              ),

              const Divider(),

              // Display Settings
              const _SectionHeader(title: 'Display Settings'),
              ListTile(
                leading: const Icon(Icons.numbers),
                title: const Text('Decimal Places'),
                subtitle: Text('${settings.decimalPlaces} digits'),
                trailing: DropdownButton<int>(
                  value: settings.decimalPlaces,
                  items: List.generate(5, (i) => i + 2)
                      .map(
                        (places) => DropdownMenuItem(
                          value: places,
                          child: Text('$places'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      settings.setDecimalPlaces(value);
                    }
                  },
                ),
              ),

              // Theme Settings
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return ListTile(
                    leading: const Icon(Icons.palette),
                    title: const Text('Theme Mode'),
                    subtitle: Text(_getThemeModeName(settings.themeMode)),
                    trailing: SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.light,
                          icon: Icon(Icons.light_mode, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          icon: Icon(Icons.dark_mode, size: 16),
                        ),
                        ButtonSegment(
                          value: ThemeMode.system,
                          icon: Icon(Icons.brightness_auto, size: 16),
                        ),
                      ],
                      selected: {settings.themeMode},
                      onSelectionChanged: (Set<ThemeMode> modes) {
                        final mode = modes.first;
                        settings.setThemeMode(mode);
                        // Sync with theme provider
                        themeProvider.setThemeMode(mode);
                      },
                    ),
                  );
                },
              ),

              const Divider(),

              // App Behavior
              const _SectionHeader(title: 'App Behavior'),
              SwitchListTile(
                secondary: const Icon(Icons.refresh),
                title: const Text('Auto-update Rates'),
                subtitle: const Text('Update exchange rates on app start'),
                value: settings.autoUpdateRates,
                onChanged: (_) => settings.toggleAutoUpdateRates(),
              ),

              SwitchListTile(
                secondary: const Icon(Icons.vibration),
                title: const Text('Haptic Feedback'),
                subtitle: const Text('Vibrate on interactions'),
                value: settings.hapticFeedback,
                onChanged: (_) => settings.toggleHapticFeedback(),
              ),

              SwitchListTile(
                secondary: const Icon(Icons.my_location),
                title: const Text('GPS Auto-Detection'),
                subtitle: const Text('Auto-detect currency from location'),
                value: settings.gpsDetection,
                onChanged: (_) => settings.toggleGpsDetection(),
              ),

              const Divider(),

              // About Section
              const _SectionHeader(title: 'About'),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0+1'),
              ),

              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Open Source'),
                subtitle: const Text('Built with Flutter'),
                trailing: const Icon(Icons.open_in_new),
                onTap: () {
                  // Open GitHub repo (if applicable)
                },
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  Future<void> _showCurrencyPicker(
    BuildContext context,
    SettingsProvider settings,
  ) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) =>
          _CurrencyPickerDialog(currentCurrency: settings.defaultCurrency),
    );

    if (selected != null) {
      await settings.setDefaultCurrency(selected);
    }
  }
}

/// Section header widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Currency picker dialog
class _CurrencyPickerDialog extends StatefulWidget {
  final String currentCurrency;

  const _CurrencyPickerDialog({required this.currentCurrency});

  @override
  State<_CurrencyPickerDialog> createState() => _CurrencyPickerDialogState();
}

class _CurrencyPickerDialogState extends State<_CurrencyPickerDialog> {
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currentCurrency;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Default Currency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppConstants.currencyCodes.length,
              itemBuilder: (context, index) {
                final currency = AppConstants.currencyCodes[index];
                final symbol = AppConstants.currencySymbols[currency] ?? '';
                final isSelected = currency == _selectedCurrency;

                return ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text('$currency - $symbol'),
                  subtitle: Text(
                    AppConstants.currencyNames[currency] ?? currency,
                  ),
                  selected: isSelected,
                  onTap: () {
                    Navigator.pop(context, currency);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
