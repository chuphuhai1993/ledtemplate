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
              color:
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
                  enableStroke: template.enableStroke,
                  strokeWidth: template.strokeWidth,
                  strokeColor: template.strokeColor,
                  enableOutline: template.enableOutline,
                  outlineWidth: template.outlineWidth,
                  outlineBlur: template.outlineBlur,
                  outlineColor: template.outlineColor,
                  enableShadow: template.enableShadow,
                  shadowOffsetX: template.shadowOffsetX,
                  shadowOffsetY: template.shadowOffsetY,
                  shadowBlur: template.shadowBlur,
                  shadowColor: template.shadowColor,
                  scrollDirection:
                      enableTextScroll
                          ? template.scrollDirection
                          : ScrollDirection.none,
                  scrollSpeed: template.scrollSpeed,
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
