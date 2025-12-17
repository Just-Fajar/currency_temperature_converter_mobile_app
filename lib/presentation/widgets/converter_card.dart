import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';

/// Reusable converter result card
class ConverterCard extends StatelessWidget {
  final String title;
  final double value;
  final String currency;
  final double? exchangeRate;
  final String? fromAmount;
  final String? fromCurrency;

  const ConverterCard({
    super.key,
    required this.title,
    required this.value,
    required this.currency,
    this.exchangeRate,
    this.fromAmount,
    this.fromCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final symbol = AppConstants.currencySymbols[currency] ?? '';
    final formattedValue = Helpers.formatCurrency(value, currency, 2);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$symbol $formattedValue',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currency,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                // Action buttons (Copy & Share)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy to clipboard',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: formattedValue));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Copied to clipboard'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.share),
                      tooltip: 'Share result',
                      onPressed: () {
                        String shareText;
                        if (fromAmount != null && fromCurrency != null) {
                          shareText =
                              '$fromAmount $fromCurrency = $formattedValue $currency';
                          if (exchangeRate != null) {
                            shareText +=
                                '\nRate: ${exchangeRate!.toStringAsFixed(4)}';
                          }
                        } else {
                          shareText = '$formattedValue $currency';
                        }
                        SharePlus.instance.share(ShareParams(text: shareText));
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (exchangeRate != null) ...[
              const Divider(height: 24),
              Text(
                'Exchange Rate: ${exchangeRate!.toStringAsFixed(4)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
