import 'package:flutter/material.dart';

/// A chip button widget that displays text and can be selected/unselected
class TextChipButtonWidget extends StatelessWidget {
  /// The text to display on the chip
  final String label;

  /// Whether this chip is currently selected
  final bool isSelected;

  /// Callback when the chip is tapped
  final VoidCallback onTap;

  const TextChipButtonWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
