import 'dart:ui';
import 'package:flutter/material.dart';

class BlurContainerWidget extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final double blur;
  final BoxBorder? border;

  const BlurContainerWidget({
    super.key,
    this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.blur = 16.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.zero;

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color:
                  color ??
                  Theme.of(context).colorScheme.background.withOpacity(0.9),
              borderRadius: effectiveBorderRadius,
              border: border,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
