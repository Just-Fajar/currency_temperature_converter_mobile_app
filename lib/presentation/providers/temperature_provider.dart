import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/conversion_history.dart';
import '../../data/models/temperature_model.dart';
import '../../data/repositories/storage_repository.dart';

/// Provider for managing temperature conversion state and operations.
///
/// This provider handles:
/// - Temperature unit selection (Celsius, Fahrenheit, Kelvin)
/// - Real-time conversion between all temperature units
/// - Conversion history management
/// - Temperature color indicators and descriptions
/// - Haptic feedback on conversions
///
/// Example:
/// ```dart
/// final provider = Provider.of<TemperatureProvider>(context);
/// provider.setSelectedUnit('Celsius');
/// provider.setInputValue(25.0);
/// print('In Fahrenheit: ${provider.results['Fahrenheit']}');
/// ```
class TemperatureProvider with ChangeNotifier {
  /// Repository for local storage operations
  final StorageRepository _storage = StorageRepository();

  // State variables
  String _selectedUnit = 'Celsius';
  double _inputValue = 0.0;
  Map<String, double> _results = {
    'Celsius': 0.0,
    'Fahrenheit': 0.0,
    'Kelvin': 0.0,
  };

  // Getters

  /// Currently selected temperature unit
  String get selectedUnit => _selectedUnit;

  /// Current input temperature value
  double get inputValue => _inputValue;

  /// Conversion results for all temperature units
  Map<String, double> get results => _results;

  /// List of available temperature units
  List<String> get availableUnits => AppConstants.temperatureUnits;

  /// Set the selected temperature unit and trigger conversion.
  ///
  /// [unit] The unit to set (e.g., 'Celsius', 'Fahrenheit', 'Kelvin')
  ///
  /// Automatically triggers conversion if input value is non-zero.
  void setSelectedUnit(String unit) {
    _selectedUnit = unit;
    if (_inputValue != 0.0) {
      _convertAll();
    }
    notifyListeners();
  }

  /// Set input temperature value and trigger conversion.
  ///
  /// [value] The temperature value to convert
  ///
  /// Automatically converts to all other temperature units.
  void setInputValue(double value) {
    _inputValue = value;
    _convertAll();
    notifyListeners();
  }

  /// Convert input temperature to all available units.
  ///
  /// This method:
  /// 1. Converts input to Celsius, Fahrenheit, and Kelvin
  /// 2. Saves conversions to history
  /// 3. Triggers haptic feedback
  void _convertAll() {
    if (_inputValue == 0.0) {
      _results = {'Celsius': 0.0, 'Fahrenheit': 0.0, 'Kelvin': 0.0};
      return;
    }

    final temperature = TemperatureModel(
      value: _inputValue,
      unit: _selectedUnit,
    );

    _results = {
      'Celsius': temperature.toCelsius(),
      'Fahrenheit': temperature.toFahrenheit(),
      'Kelvin': temperature.toKelvin(),
    };

    _saveToHistory();
    _triggerHaptic();
  }

  /// Convert current input to specific target unit.
  ///
  /// [targetUnit] The unit to convert to
  /// Returns the converted temperature value.
  double convertTo(String targetUnit) {
    return Helpers.convertTemperature(_inputValue, _selectedUnit, targetUnit);
  }

  /// Save all conversions to history.
  ///
  /// Saves conversion for each unit except the input unit.
  Future<void> _saveToHistory() async {
    for (final unit in availableUnits) {
      if (unit != _selectedUnit) {
        final history = ConversionHistory.temperature(
          inputValue: _inputValue,
          fromUnit: _selectedUnit,
          toUnit: unit,
          result: _results[unit]!,
        );
        await _storage.saveConversion(history);
      }
    }
  }

  /// Trigger haptic feedback if enabled in settings.
  ///
  /// Vibrates device briefly (50ms) to provide tactile feedback.
  Future<void> _triggerHaptic() async {
    final hapticEnabled = await _storage.getHapticEnabled();
    if (hapticEnabled) {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        Vibration.vibrate(duration: 50);
      }
    }
  }

  /// Get temperature color based on celsius value
  Color getTemperatureColor() {
    final celsius = _results['Celsius'] ?? 0.0;

    if (celsius < 0) {
      return const Color(0xFF2196F3); // Cold Blue
    } else if (celsius < 15) {
      return const Color(0xFF00BCD4); // Cool Cyan
    } else if (celsius < 25) {
      return const Color(0xFF4CAF50); // Normal Green
    } else if (celsius < 35) {
      return const Color(0xFFFF9800); // Warm Orange
    } else {
      return const Color(0xFFF44336); // Hot Red
    }
  }

  /// Get temperature description
  String getTemperatureDescription() {
    final celsius = _results['Celsius'] ?? 0.0;

    if (celsius < 0) {
      return 'Freezing';
    } else if (celsius < 15) {
      return 'Cold';
    } else if (celsius < 25) {
      return 'Moderate';
    } else if (celsius < 35) {
      return 'Warm';
    } else {
      return 'Hot';
    }
  }

  /// Reset conversion
  void reset() {
    _inputValue = 0.0;
    _results = {'Celsius': 0.0, 'Fahrenheit': 0.0, 'Kelvin': 0.0};
    notifyListeners();
  }
}
