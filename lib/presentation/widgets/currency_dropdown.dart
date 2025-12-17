import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';

/// Currency dropdown selector
class CurrencyDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> currencies;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.currencies,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.monetization_on),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: currencies.map((currency) {
            final symbol = AppConstants.currencySymbols[currency] ?? '';
            final name = AppConstants.currencyNames[currency] ?? currency;

            return DropdownMenuItem(
              value: currency,
              child: Text('$symbol $currency - $name'),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
