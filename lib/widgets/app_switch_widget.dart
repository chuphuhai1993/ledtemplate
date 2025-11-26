import 'package:flutter/material.dart';

class AppSwitchWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitchWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 32,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color:
              value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
