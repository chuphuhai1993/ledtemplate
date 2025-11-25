import 'package:flutter/material.dart';
import '../scrolling_text_renderer.dart';

class Template {
  final String text;
  final String fontFamily;

  /// Font size as a percentage of widget height (0-100)
  /// The actual pixel size is calculated dynamically based on container height
  final double fontSize;

  // Text color (new for gradient support)
  final Color textColor;
  final List<Color>? textGradientColors;
  final double textGradientRotation;

  // Stroke
  final bool enableStroke;
  final double strokeWidth;
  final Color strokeColor;
  final List<Color>? strokeGradientColors;
  final double strokeGradientRotation;

  // Outline
  final bool enableOutline;
  final double outlineWidth;
  final double outlineBlur;
  final Color outlineColor;
  final List<Color>? outlineGradientColors;
  final double outlineGradientRotation;

  // Shadow (keeping solid color only for simplicity)
  final bool enableShadow;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;
  final Color shadowColor;

  // Scroll
  final ScrollDirection scrollDirection;
  final double scrollSpeed;

  // Background
  final Color backgroundColor;
  final List<Color>? backgroundGradientColors;
  final double backgroundGradientRotation;
  final String? backgroundImage;

  // Frame
  final bool enableFrame;
  final String? frameImage;

  const Template({
    required this.text,
    this.fontFamily = 'Roboto',
    this.fontSize = 30.0, // 30% of widget height
    this.textColor = Colors.white,
    this.textGradientColors,
    this.textGradientRotation = 0,
    this.enableStroke = false,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.red,
    this.strokeGradientColors,
    this.strokeGradientRotation = 0,
    this.enableOutline = false,
    this.outlineWidth = 0.0,
    this.outlineBlur = 10.0,
    this.outlineColor = Colors.blue,
    this.outlineGradientColors,
    this.outlineGradientRotation = 0,
    this.enableShadow = false,
    this.shadowOffsetX = 2.0,
    this.shadowOffsetY = 2.0,
    this.shadowBlur = 3.0,
    this.shadowColor = Colors.black,
    this.scrollDirection = ScrollDirection.rightToLeft,
    this.scrollSpeed = 100.0,
    this.backgroundColor = Colors.black,
    this.backgroundGradientColors,
    this.backgroundGradientRotation = 0,
    this.backgroundImage,
    this.enableFrame = false,
    this.frameImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'textColor': textColor.value,
      'textGradientColors': textGradientColors?.map((c) => c.value).toList(),
      'textGradientRotation': textGradientRotation,
      'enableStroke': enableStroke,
      'strokeWidth': strokeWidth,
      'strokeColor': strokeColor.value,
      'strokeGradientColors':
          strokeGradientColors?.map((c) => c.value).toList(),
      'strokeGradientRotation': strokeGradientRotation,
      'enableOutline': enableOutline,
      'outlineWidth': outlineWidth,
      'outlineBlur': outlineBlur,
      'outlineColor': outlineColor.value,
      'outlineGradientColors':
          outlineGradientColors?.map((c) => c.value).toList(),
      'outlineGradientRotation': outlineGradientRotation,
      'enableShadow': enableShadow,
      'shadowOffsetX': shadowOffsetX,
      'shadowOffsetY': shadowOffsetY,
      'shadowBlur': shadowBlur,
      'shadowColor': shadowColor.value,
      'scrollDirection': scrollDirection.index,
      'scrollSpeed': scrollSpeed,
      'backgroundColor': backgroundColor.value,
      'backgroundGradientColors':
          backgroundGradientColors?.map((c) => c.value).toList(),
      'backgroundGradientRotation': backgroundGradientRotation,
      'backgroundImage': backgroundImage,
      'enableFrame': enableFrame,
      'frameImage': frameImage,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    // Helper to parse gradient colors
    List<Color>? parseGradientColors(dynamic value) {
      if (value == null) return null;
      if (value is List) {
        return value.map((v) => Color(v as int)).toList();
      }
      return null;
    }

    return Template(
      text: json['text'] ?? '',
      fontFamily: json['fontFamily'] ?? 'Roboto',
      fontSize: ((json['fontSize'] as num?)?.toDouble() ?? 30.0).clamp(
        15.0,
        90.0,
      ),
      textColor: Color(json['textColor'] ?? 0xFFFFFFFF),
      textGradientColors: parseGradientColors(json['textGradientColors']),
      textGradientRotation:
          (json['textGradientRotation'] as num?)?.toDouble() ?? 0,
      enableStroke: json['enableStroke'] ?? false,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2.0,
      strokeColor: Color(json['strokeColor'] ?? 0xFFFF0000),
      strokeGradientColors: parseGradientColors(json['strokeGradientColors']),
      strokeGradientRotation:
          (json['strokeGradientRotation'] as num?)?.toDouble() ?? 0,
      enableOutline: json['enableOutline'] ?? false,
      outlineWidth: (json['outlineWidth'] as num?)?.toDouble() ?? 0.0,
      outlineBlur: (json['outlineBlur'] as num?)?.toDouble() ?? 10.0,
      outlineColor: Color(json['outlineColor'] ?? 0xFF0000FF),
      outlineGradientColors: parseGradientColors(json['outlineGradientColors']),
      outlineGradientRotation:
          (json['outlineGradientRotation'] as num?)?.toDouble() ?? 0,
      enableShadow: json['enableShadow'] ?? false,
      shadowOffsetX: (json['shadowOffsetX'] as num?)?.toDouble() ?? 2.0,
      shadowOffsetY: (json['shadowOffsetY'] as num?)?.toDouble() ?? 2.0,
      shadowBlur: (json['shadowBlur'] as num?)?.toDouble() ?? 3.0,
      shadowColor: Color(json['shadowColor'] ?? 0xFF000000),
      scrollDirection: ScrollDirection.values[json['scrollDirection'] ?? 0],
      scrollSpeed: (json['scrollSpeed'] as num?)?.toDouble() ?? 100.0,
      backgroundColor: Color(json['backgroundColor'] ?? 0xFF000000),
      backgroundGradientColors: parseGradientColors(
        json['backgroundGradientColors'],
      ),
      backgroundGradientRotation:
          (json['backgroundGradientRotation'] as num?)?.toDouble() ?? 0,
      backgroundImage: json['backgroundImage'],
      enableFrame: json['enableFrame'] ?? false,
      frameImage: json['frameImage'],
    );
  }
}

class TemplateCategory {
  final String name;
  final List<Template> templates;

  const TemplateCategory({required this.name, required this.templates});
}
