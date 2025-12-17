import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../providers/temperature_provider.dart';

/// Temperature converter screen with responsive layout.
///
/// Provides:
/// - Temperature input field
/// - Unit selector (Celsius, Fahrenheit, Kelvin)
/// - Real-time conversion results
/// - Copy and share functionality
/// - Visual temperature indicators
class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  final TextEditingController _tempController = TextEditingController();

  @override
  void dispose() {
    _tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: Consumer<TemperatureProvider>(
        builder: (context, provider, child) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxWidth(context),
              ),
              child: ResponsiveBuilder(
                builder: (context, constraints, orientation) {
                  final padding = ResponsiveHelper.getPadding(context);
                  final isWideScreen = constraints.maxWidth >= 1024;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (isWideScreen)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildInputSection(context, provider),
                              ),
                              SizedBox(width: padding),
                              Expanded(
                                child: _buildResultsSection(context, provider),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildInputSection(context, provider),
                              SizedBox(height: padding),
                              _buildResultsSection(context, provider),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputSection(
    BuildContext context,
    TemperatureProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTemperatureTextField(provider),
        const SizedBox(height: 24),
        _buildUnitSelector(provider),
      ],
    );
  }

  /// Build temperature input text field with clear button.
  Widget _buildTemperatureTextField(TemperatureProvider provider) {
    return TextField(
      controller: _tempController,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      autofocus: false,
      decoration: InputDecoration(
        labelText: 'Temperature',
        hintText: 'Enter temperature',
        prefixIcon: const Icon(Icons.thermostat),
        suffixIcon: _buildClearButton(provider),
      ),
      onChanged: (value) => _handleTemperatureInput(value, provider),
    );
  }

  /// Build clear button widget if text is not empty.
  Widget? _buildClearButton(TemperatureProvider provider) {
    if (_tempController.text.isEmpty) return null;

    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        _tempController.clear();
        provider.setInputValue(0.0);
      },
      tooltip: 'Clear',
    );
  }

  /// Handle temperature input change.
  void _handleTemperatureInput(String value, TemperatureProvider provider) {
    final temp = double.tryParse(value) ?? 0.0;
    provider.setInputValue(temp);
    setState(() {});
  }

  /// Build unit selector segmented button.
  Widget _buildUnitSelector(TemperatureProvider provider) {
    return SegmentedButton<String>(
      segments: AppConstants.temperatureUnits.map((unit) {
        return ButtonSegment<String>(
          value: unit,
          label: Text(unit),
          icon: Icon(Icons.thermostat),
        );
      }).toList(),
      selected: {provider.selectedUnit},
      onSelectionChanged: (Set<String> selected) {
        provider.setSelectedUnit(selected.first);
      },
    );
  }

  /// Build results section with conversion results.
  Widget _buildResultsSection(
    BuildContext context,
    TemperatureProvider provider,
  ) {
    if (provider.inputValue == 0.0) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTemperatureIndicator(context, provider),
        const SizedBox(height: 24),
        ..._buildResultCards(context, provider),
        const SizedBox(height: 16),
        _buildShareAllButton(provider),
      ],
    );
  }

  /// Build empty state widget when no temperature is entered.
  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Text(
          'Enter a temperature to convert',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }

  /// Build temperature indicator with color and description.
  Widget _buildTemperatureIndicator(
    BuildContext context,
    TemperatureProvider provider,
  ) {
    return AnimatedContainer(
      key: ValueKey('temp_${provider.inputValue}'),
      duration: AppConstants.animationDurationSlow,
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: provider.getTemperatureColor().withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: provider.getTemperatureColor(), width: 2),
      ),
      child: Column(
        children: [
          AnimatedDefaultTextStyle(
            duration: AppConstants.animationDurationNormal,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: provider.getTemperatureColor(),
              fontWeight: FontWeight.bold,
            ),
            child: Text(provider.getTemperatureDescription()),
          ),
          const SizedBox(height: 8),
          _buildAnimatedThermometerIcon(provider),
        ],
      ),
    );
  }

  /// Build animated thermometer icon with scale effect.
  Widget _buildAnimatedThermometerIcon(TemperatureProvider provider) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('icon_${provider.inputValue}'),
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Icon(
            Icons.thermostat,
            size: 48,
            color: provider.getTemperatureColor(),
          ),
        );
      },
    );
  }

  /// Build list of result cards for all temperature units.
  List<Widget> _buildResultCards(
    BuildContext context,
    TemperatureProvider provider,
  ) {
    return AppConstants.temperatureUnits.map((unit) {
      return _buildResultCard(context, provider, unit);
    }).toList();
  }

  /// Build individual result card for a temperature unit.
  Widget _buildResultCard(
    BuildContext context,
    TemperatureProvider provider,
    String unit,
  ) {
    final value = provider.results[unit] ?? 0.0;
    final symbol = AppConstants.temperatureSymbols[unit] ?? '';
    final index = AppConstants.temperatureUnits.indexOf(unit);
    final isSelected = unit == provider.selectedUnit;

    return AnimatedOpacity(
      key: ValueKey('${unit}_$value'),
      opacity: provider.results[unit] != null ? 1.0 : 0.0,
      duration: Duration(milliseconds: 300 + (index * 100)),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Icon(
            Icons.thermostat,
            color: isSelected ? Theme.of(context).colorScheme.primary : null,
          ),
          title: Text(
            unit,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: _buildResultActions(context, value, symbol),
        ),
      ),
    );
  }

  /// Build action buttons (copy and share) for result card.
  Widget _buildResultActions(
    BuildContext context,
    double value,
    String symbol,
  ) {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              '${value.toStringAsFixed(2)} $symbol',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _buildCopyButton(context, value, symbol),
          _buildShareButton(value, symbol),
        ],
      ),
    );
  }

  /// Build copy button for individual result.
  Widget _buildCopyButton(BuildContext context, double value, String symbol) {
    return IconButton(
      icon: const Icon(Icons.copy, size: 20),
      tooltip: 'Copy',
      onPressed: () {
        Clipboard.setData(
          ClipboardData(text: '${value.toStringAsFixed(2)} $symbol'),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Copied to clipboard'),
            duration: AppConstants.snackBarDuration,
          ),
        );
      },
    );
  }

  /// Build share button for individual result.
  Widget _buildShareButton(double value, String symbol) {
    return IconButton(
      icon: const Icon(Icons.share, size: 20),
      tooltip: 'Share',
      onPressed: () {
        SharePlus.instance.share(
          ShareParams(text: '${value.toStringAsFixed(2)} $symbol'),
        );
      },
    );
  }

  /// Build button to share all conversion results.
  Widget _buildShareAllButton(TemperatureProvider provider) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _shareAllResults(provider),
        icon: const Icon(Icons.share),
        label: const Text('Share All Results'),
      ),
    );
  }

  /// Share all conversion results as formatted text.
  void _shareAllResults(TemperatureProvider provider) {
    String shareText = 'Temperature Conversion:\n';
    shareText += '${provider.inputValue} ${provider.selectedUnit}\n\n';

    for (var unit in AppConstants.temperatureUnits) {
      final value = provider.results[unit] ?? 0.0;
      final symbol = AppConstants.temperatureSymbols[unit] ?? '';
      shareText += '$unit: ${value.toStringAsFixed(2)} $symbol\n';
    }

    SharePlus.instance.share(ShareParams(text: shareText));
  }
}
