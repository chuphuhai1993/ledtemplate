import 'dart:ui';
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
  final double? height;

  const NeonButton({
    super.key,
    this.onPressed,
    required this.child,
    this.size = NeonButtonSize.medium,
    this.type = NeonButtonType.primary,
    this.borderSize,
    this.borderRadius,
    this.fontSize,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Size configuration
    double horizontalPadding;
    double defaultBorderRadius;
    double defaultBorderSize;
    double defaultFontSize;
    double defaultHeight;

    switch (size) {
      case NeonButtonSize.small:
        horizontalPadding = 12;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 14;
        defaultHeight = 32;
        break;
      case NeonButtonSize.medium:
        horizontalPadding = 20;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 14;
        defaultHeight = 40;
        break;
      case NeonButtonSize.large:
        horizontalPadding = 32;
        defaultBorderRadius = 999;
        defaultBorderSize = 1;
        defaultFontSize = 16;
        defaultHeight = 64;
        break;
    }

    // Type configuration
    Color borderColor;
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case NeonButtonType.primary:
        borderColor = colorScheme.primary;
        backgroundColor = colorScheme.primary.withOpacity(0.3);
        textColor = colorScheme.primary;
        break;
      case NeonButtonType.secondary:
        borderColor = colorScheme.secondary;
        backgroundColor = colorScheme.secondary.withOpacity(0.3);
        textColor = colorScheme.secondary;
        break;
      case NeonButtonType.tertiary:
        borderColor = Colors.transparent;
        backgroundColor = colorScheme.tertiary;
        textColor = colorScheme.onTertiary;
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
    final effectiveHeight = height ?? defaultHeight;

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveBorderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 56, sigmaY: 56),
        child: Container(
          height: effectiveHeight,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: effectiveBorderSize),
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            child: InkWell(
              onTap: type == NeonButtonType.disabled ? null : onPressed,
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
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
