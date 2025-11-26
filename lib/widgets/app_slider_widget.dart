import 'package:flutter/material.dart';

class AppSliderWidget extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String? label;

  const AppSliderWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.onSurface.withOpacity(0.1),
        thumbColor: colorScheme.onSurface,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
        trackHeight: 4.0,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}
