import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:lottie/lottie.dart';
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
  final bool enableEffect;
  final String? phoneAsset;

  const PreviewWidget({
    super.key,
    required this.template,
    required this.text,
    this.showPhoneFrame = false,
    this.enableEffect = true,
    this.phoneAsset,
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

          return Stack(
            fit: StackFit.expand,
            children: [
              Transform.scale(
                scale: showPhoneFrame ? 0.97 : 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    showPhoneFrame ? constraints.maxWidth * 0.05 : 0,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient:
                              template.backgroundGradientColors != null &&
                                      template.backgroundImage == null
                                  ? LinearGradient(
                                    colors: template.backgroundGradientColors!,
                                    transform: GradientRotation(
                                      template.backgroundGradientRotation *
                                          3.14159 /
                                          180,
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
                                    image: AssetImage(
                                      template.backgroundImage!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                      ),
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
                        outlineGradientRotation:
                            template.outlineGradientRotation,
                        enableShadow: template.enableShadow,
                        shadowOffsetX: template.shadowOffsetX,
                        shadowOffsetY: template.shadowOffsetY,
                        shadowBlur: template.shadowBlur,
                        shadowColor: template.shadowColor,
                        shadowGradientColors: template.shadowGradientColors,
                        shadowGradientRotation: template.shadowGradientRotation,
                        enableScroll: enableEffect && template.enableScroll,
                        enableBounceZoom:
                            enableEffect && template.enableBounceZoom,
                        enableBounce: enableEffect && template.enableBounce,
                        bounceDirection: template.bounceDirection,
                        scrollDirection:
                            enableEffect
                                ? template.scrollDirection
                                : ScrollDirection.none,
                        scrollSpeed: template.scrollSpeed,
                        enableBlink: enableEffect && template.enableBlink,
                        blinkDuration: template.blinkDuration,
                        zoomLevel: template.zoomLevel,
                        zoomSpeed: template.zoomSpeed,
                        bounceLevel: template.bounceLevel,
                        bounceSpeed: template.bounceSpeed,
                        enableRotationBounce:
                            enableEffect && template.enableRotationBounce,
                        rotationStart: template.rotationStart,
                        rotationEnd: template.rotationEnd,
                        rotationSpeed: template.rotationSpeed,
                      ),
                      if (template.enableFrameGlow)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: template.frameGlowBlur,
                                sigmaY: template.frameGlowBlur,
                              ),
                              child:
                                  template.frameGlowGradientColors != null
                                      ? CustomPaint(
                                        painter: _GradientBorderPainter(
                                          gradient: LinearGradient(
                                            colors:
                                                template
                                                    .frameGlowGradientColors!,
                                            transform: GradientRotation(
                                              template.frameGlowGradientRotation *
                                                  3.14159 /
                                                  180,
                                            ),
                                          ),
                                          borderRadius:
                                              template.frameGlowBorderRadius,
                                          strokeWidth: template.frameGlowSize,
                                        ),
                                      )
                                      : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            template.frameGlowBorderRadius,
                                          ),
                                          border: Border.all(
                                            color: template.frameGlowColor,
                                            width: template.frameGlowSize,
                                          ),
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      if (template.enableFrame && template.frameImage != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: _buildFrame(template.frameImage!),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (showPhoneFrame)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Image.asset(
                      phoneAsset ?? 'assets/phones/iphone_16.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Helper method to build frame widget (all frames are Lottie now)
  Widget _buildFrame(String framePath) {
    return Lottie.asset(framePath, fit: BoxFit.fill, repeat: true);
  }
}

/// Custom painter to draw a gradient border
class _GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double borderRadius;
  final double strokeWidth;

  _GradientBorderPainter({
    required this.gradient,
    required this.borderRadius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
