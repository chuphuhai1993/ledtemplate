import 'package:flutter/material.dart';
import '../models/template.dart';
import '../scrolling_text_renderer.dart';

/// A reusable preview widget displaying the scrolling text with background and optional frame.
///
/// The widget maintains a fixed aspect ratio of 16:7.5 (width:height).
/// It takes a [template] describing visual settings and the current [text] to render.
class PreviewWidget extends StatelessWidget {
  final Template template;
  final String text;
  final bool showPhoneFrame;
  final bool enableTextScroll;

  const PreviewWidget({
    super.key,
    required this.template,
    required this.text,
    this.showPhoneFrame = false,
    this.enableTextScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 7.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate actual font size as a percentage of widget height
          // template.fontSize is stored as 0-100 (percentage)
          final double actualFontSize =
              constraints.maxHeight * (template.fontSize / 100);

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient:
                  template.backgroundGradientColors != null &&
                          template.backgroundImage == null
                      ? LinearGradient(
                        colors: template.backgroundGradientColors!,
                        transform: GradientRotation(
                          template.backgroundGradientRotation * 3.14159 / 180,
                        ),
                      )
                      : null,
              color:
                  template.backgroundGradientColors == null &&
                          template.backgroundImage == null
                      ? template.backgroundColor
                      : null,
              image:
                  template.backgroundImage != null
                      ? DecorationImage(
                        image: AssetImage(template.backgroundImage!),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ScrollingTextRenderer(
                  text: text,
                  fontFamily: template.fontFamily,
                  fontSize: actualFontSize,
                  textColor: template.textColor,
                  textGradientColors: template.textGradientColors,
                  textGradientRotation: template.textGradientRotation,
                  enableStroke: template.enableStroke,
                  strokeWidth: template.strokeWidth,
                  strokeColor: template.strokeColor,
                  strokeGradientColors: template.strokeGradientColors,
                  strokeGradientRotation: template.strokeGradientRotation,
                  enableOutline: template.enableOutline,
                  outlineWidth: template.outlineWidth,
                  outlineBlur: template.outlineBlur,
                  outlineColor: template.outlineColor,
                  outlineGradientColors: template.outlineGradientColors,
                  outlineGradientRotation: template.outlineGradientRotation,
                  enableShadow: template.enableShadow,
                  shadowOffsetX: template.shadowOffsetX,
                  shadowOffsetY: template.shadowOffsetY,
                  shadowBlur: template.shadowBlur,
                  shadowColor: template.shadowColor,
                  shadowGradientColors: template.shadowGradientColors,
                  shadowGradientRotation: template.shadowGradientRotation,
                  enableScroll: enableTextScroll && template.enableScroll,
                  enableBounceZoom: template.enableBounceZoom,
                  enableBounce: template.enableBounce,
                  bounceDirection: template.bounceDirection,
                  scrollDirection:
                      enableTextScroll
                          ? template.scrollDirection
                          : ScrollDirection.none,
                  scrollSpeed: template.scrollSpeed,
                  enableBlink: template.enableBlink,
                  blinkDuration: template.blinkDuration,
                  zoomLevel: template.zoomLevel,
                  zoomSpeed: template.zoomSpeed,
                  bounceLevel: template.bounceLevel,
                  bounceSpeed: template.bounceSpeed,
                  enableRotationBounce: template.enableRotationBounce,
                  rotationStart: template.rotationStart,
                  rotationEnd: template.rotationEnd,
                  rotationSpeed: template.rotationSpeed,
                ),
                if (template.enableFrame && template.frameImage != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Image.asset(
                        template.frameImage!,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                if (showPhoneFrame)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Image.asset(
                        'assets/phones/iphone_16.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
