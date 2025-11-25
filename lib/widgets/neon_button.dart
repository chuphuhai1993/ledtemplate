import 'package:flutter/material.dart';

enum NeonButtonSize { small, medium, large }

enum NeonButtonType { primary, secondary, tertiary, tonal, disabled }

class NeonButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final NeonButtonSize size;
  final NeonButtonType type;
  final double? borderSize;
  final double? borderRadius;
  final double? fontSize;
  final double? minHeight;

  const NeonButton({
    super.key,
    this.onPressed,
    required this.child,
    this.size = NeonButtonSize.medium,
    this.type = NeonButtonType.primary,
    this.borderSize,
    this.borderRadius,
    this.fontSize,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Size configuration
    double verticalPadding;
    double horizontalPadding;
    double defaultBorderRadius;
    double defaultBorderSize;
    double defaultFontSize;
    double defaultMinHeight;

    switch (size) {
      case NeonButtonSize.small:
        verticalPadding = 8;
        horizontalPadding = 16;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 14;
        defaultMinHeight = 32;
        break;
      case NeonButtonSize.medium:
        verticalPadding = 12;
        horizontalPadding = 24;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 14;
        defaultMinHeight = 40;
        break;
      case NeonButtonSize.large:
        verticalPadding = 16;
        horizontalPadding = 32;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 16;
        defaultMinHeight = 64;
        break;
    }

    // Type configuration
    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case NeonButtonType.primary:
        borderColor = colorScheme.primary;
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        break;
      case NeonButtonType.secondary:
        borderColor = colorScheme.secondary;
        backgroundColor = colorScheme.secondaryContainer;
        textColor = colorScheme.onSecondaryContainer;
        break;
      case NeonButtonType.tertiary:
        borderColor = colorScheme.tertiary;
        backgroundColor = colorScheme.tertiaryContainer;
        textColor = colorScheme.onTertiaryContainer;
        break;
      case NeonButtonType.tonal:
        borderColor = Colors.transparent;
        backgroundColor = colorScheme.onSurface.withOpacity(0.16);
        textColor = colorScheme.onSurface;
        break;
      case NeonButtonType.disabled:
        borderColor = Colors.transparent;
        backgroundColor = colorScheme.onSurface.withOpacity(0.08);
        textColor = colorScheme.onSurface.withOpacity(0.38);
        break;
    }

    final effectiveBorderRadius = borderRadius ?? defaultBorderRadius;
    final effectiveBorderSize = borderSize ?? defaultBorderSize;
    final effectiveFontSize = fontSize ?? defaultFontSize;
    final effectiveMinHeight = minHeight ?? defaultMinHeight;

    return Container(
      constraints: BoxConstraints(minHeight: effectiveMinHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: Container(
        // Gradient Border Container
        padding: EdgeInsets.all(effectiveBorderSize),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          color: borderColor,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(
            effectiveBorderRadius - effectiveBorderSize,
          ),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: InkWell(
              onTap: type == NeonButtonType.disabled ? null : onPressed,
              borderRadius: BorderRadius.circular(
                effectiveBorderRadius - effectiveBorderSize,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: effectiveFontSize,
                  ),
                  child: Center(child: child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
