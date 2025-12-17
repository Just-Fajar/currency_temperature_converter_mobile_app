import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/conversion_history.dart';

/// History list tile widget with tap-to-reuse functionality
class HistoryTile extends StatelessWidget {
  final ConversionHistory history;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const HistoryTile({
    super.key,
    required this.history,
    required this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrency = history.type == 'currency';
    final icon = isCurrency ? Icons.attach_money : Icons.thermostat;
    final color = isCurrency
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    String fromUnit = history.fromUnit;
    String toUnit = history.toUnit;

    // Add symbols for display
    if (!isCurrency) {
      fromUnit = '${AppConstants.temperatureSymbols[history.fromUnit]}';
      toUnit = '${AppConstants.temperatureSymbols[history.toUnit]}';
    } else {
      fromUnit =
          AppConstants.currencySymbols[history.fromUnit] ?? history.fromUnit;
      toUnit = AppConstants.currencySymbols[history.toUnit] ?? history.toUnit;
    }

    return Dismissible(
      key: Key(history.timestamp.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.2),
            child: Icon(icon, color: color),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  '${history.inputValue.toStringAsFixed(2)} $fromUnit',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.arrow_forward, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${history.result.toStringAsFixed(2)} $toUnit',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${history.fromUnit} → ${history.toUnit}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (history.exchangeRate != null)
                Text(
                  'Rate: ${history.exchangeRate!.toStringAsFixed(4)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              Text(
                Helpers.getRelativeTime(history.timestamp),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),
          isThreeLine: true,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
