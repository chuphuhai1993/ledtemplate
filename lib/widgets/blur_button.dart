import 'dart:ui';
import 'package:flutter/material.dart';

class BlurButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double size;
  final double blurAmount;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const BlurButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 48,
    this.blurAmount = 10,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.black.withOpacity(0.3),
            borderRadius: borderRadius ?? BorderRadius.circular(size / 2),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: icon,
            onPressed: onPressed,
            style: IconButton.styleFrom(backgroundColor: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
