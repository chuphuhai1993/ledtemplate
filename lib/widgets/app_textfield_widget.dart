import 'package:flutter/material.dart';

/// A custom text field widget with consistent app styling
class AppTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;

  const AppTextFieldWidget({
    super.key,
    this.hintText,
    this.controller,
    this.onChanged,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: colorScheme.onSurface.withOpacity(0.1),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withOpacity(0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
