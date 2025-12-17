import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/helpers.dart';
import '../../core/utils/responsive_helper.dart';
import '../../data/services/location_service.dart';
import '../providers/currency_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/converter_card.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/shimmer_loading.dart';

/// Currency converter screen
class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final LocationService _locationService = LocationService();
  bool _isDetectingLocation = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Auto-detect currency based on GPS location
  Future<void> _detectCurrency() async {
    // Show explanation dialog on web platform
    if (kIsWeb && mounted) {
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber),
              SizedBox(width: 12),
              Text('GPS Not Available on Web'),
            ],
          ),
          content: const Text(
            'GPS location detection requires HTTPS and is not supported on localhost web apps.\n\n'
            'To use GPS features:\n'
            '• Use the mobile or desktop app\n'
            '• Deploy to an HTTPS server\n\n'
            'Would you like to manually select your currency instead?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Select Manually'),
            ),
          ],
        ),
      );

      if (shouldProceed == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please select your currency from the dropdown above',
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    // Mobile/Desktop: Proceed with actual GPS detection
    setState(() {
      _isDetectingLocation = true;
    });

    try {
      final currency = await _locationService.detectUserCurrency();
      if (currency != null && mounted) {
        final provider = context.read<CurrencyProvider>();
        provider.setFromCurrency(currency);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Detected currency: $currency'),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (mounted) {
        final shouldOpenSettings = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.location_off, color: Colors.orange),
                SizedBox(width: 12),
                Text('Enable GPS'),
              ],
            ),
            content: const Text(
              'Location services are disabled or permission denied.\n\n'
              'Please enable GPS in your device settings to auto-detect your currency.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.settings),
                label: const Text('Open Settings'),
              ),
            ],
          ),
        );

        if (shouldOpenSettings == true) {
          // On mobile, this would open device settings
          // For now, just show info message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enable GPS in your device settings'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDetectingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          // GPS auto-detect button
          IconButton(
            icon: _isDetectingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.my_location),
            onPressed: _isDetectingLocation ? null : _detectCurrency,
            tooltip: 'Auto-detect currency from location',
          ),
          // Theme toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: Consumer<CurrencyProvider>(
        builder: (context, provider, child) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxWidth(context),
              ),
              child: ResponsiveBuilder(
                builder: (context, constraints, orientation) {
                  final isWideScreen = constraints.maxWidth >= 1024;
                  final padding = ResponsiveHelper.getPadding(context);

                  if (isWideScreen) {
                    // Desktop layout - side by side
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(padding),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side - Input
                          Expanded(
                            child: _buildInputSection(context, provider),
                          ),
                          SizedBox(width: padding),
                          // Right side - Result
                          Expanded(
                            child: _buildResultSection(context, provider),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Mobile/Tablet layout - stacked
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildInputSection(context, provider),
                          SizedBox(height: padding),
                          _buildResultSection(context, provider),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputSection(BuildContext context, CurrencyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Amount input with clear button
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Amount',
            hintText: 'Enter amount',
            prefixIcon: const Icon(Icons.money),
            suffixIcon: _amountController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _amountController.clear();
                      provider.setAmount(0.0);
                    },
                    tooltip: 'Clear',
                  )
                : null,
            errorText: provider.error,
            helperText: provider.isOfflineMode
                ? '📡 Offline mode - using cached rates'
                : null,
            helperStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0.0;
            provider.setAmount(amount);
            setState(() {}); // Update to show/hide clear button
          },
        ),

        const SizedBox(height: 24),

        // From Currency
        CurrencyDropdown(
          label: 'From',
          value: provider.fromCurrency,
          currencies: provider.availableCurrencies,
          onChanged: (currency) {
            if (currency != null) {
              provider.setFromCurrency(currency);
            }
          },
        ),

        const SizedBox(height: 16),

        // Swap button with bounce animation
        Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: IconButton.filled(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: () {
                    provider.swapCurrencies();
                    // Trigger animation by rebuilding with different tween
                    setState(() {});
                  },
                  iconSize: 32,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // To Currency
        CurrencyDropdown(
          label: 'To',
          value: provider.toCurrency,
          currencies: provider.availableCurrencies,
          onChanged: (currency) {
            if (currency != null) {
              provider.setToCurrency(currency);
            }
          },
        ),
      ],
    );
  }

  Widget _buildResultSection(BuildContext context, CurrencyProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Result card with fade-in animation or shimmer loading
        if (provider.isLoading)
          const ShimmerCard()
        else if (provider.result > 0)
          AnimatedOpacity(
            key: ValueKey('result_${provider.result}'),
            opacity: provider.result > 0 ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: ConverterCard(
              title: 'Result',
              value: provider.result,
              currency: provider.toCurrency,
              exchangeRate: provider.exchangeRate,
              fromAmount: provider.amount.toString(),
              fromCurrency: provider.fromCurrency,
            ),
          )
        else
          SizedBox(
            height: 120,
            child: Center(
              child: Text(
                'Enter an amount to convert',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
          ),

        const SizedBox(height: 16),

        // Last updated
        if (provider.lastUpdate != null)
          Center(
            child: Text(
              'Last updated: ${Helpers.getRelativeTime(provider.lastUpdate!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),

        const SizedBox(height: 16),

        // Refresh button
        SizedBox(
          height: 48,
          child: ElevatedButton.icon(
            onPressed: provider.refreshRates,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Rates'),
          ),
        ),
      ],
    );
  }
}
