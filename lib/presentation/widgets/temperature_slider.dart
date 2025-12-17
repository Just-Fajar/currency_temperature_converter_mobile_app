import 'package:flutter/material.dart';

/// Temperature slider widget (placeholder)
class TemperatureSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;

  const TemperatureSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = -50,
    this.max = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toStringAsFixed(1),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: ((max - min) * 2).toInt(),
          label: value.toStringAsFixed(1),
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$min°'),
            Text('$max°'),
          ],
        ),
      ],
    );
  }
}
