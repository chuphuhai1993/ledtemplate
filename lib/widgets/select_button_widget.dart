import 'package:flutter/material.dart';

/// A button widget that displays a selected value, typically used for opening selection bottom sheets
class SelectButtonWidget extends StatelessWidget {
  /// The currently selected value to display
  final String value;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Optional text style for the value
  final TextStyle? textStyle;

  /// Optional border color for the button
  final Color? borderColor;

  /// Optional border width for the button
  final double? borderWidth;

  const SelectButtonWidget({
    super.key,
    required this.value,
    required this.onPressed,
    this.textStyle,
    this.borderColor,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onBackground.withOpacity(0.05),
        side: BorderSide(
          color: borderColor ?? Theme.of(context).colorScheme.onSurface,
          width: borderWidth ?? 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(
        value,
        style:
            textStyle ??
            TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
            ),
      ),
    );
  }
}
