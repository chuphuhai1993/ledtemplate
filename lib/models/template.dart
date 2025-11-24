import 'package:flutter/material.dart';
import '../scrolling_text_renderer.dart';

class Template {
  final String text;
  final String fontFamily;
  final double fontSize;
  final bool enableStroke;
  final double strokeWidth;
  final Color strokeColor;
  final bool enableOutline;
  final double outlineWidth;
  final double outlineBlur;
  final Color outlineColor;
  final bool enableShadow;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;
  final Color shadowColor;
  final ScrollDirection scrollDirection;
  final double scrollSpeed;
  final Color backgroundColor;
  final String? backgroundImage;
  final bool enableFrame;
  final String? frameImage;

  const Template({
    required this.text,
    this.fontFamily = 'Roboto',
    this.fontSize = 80.0,
    this.enableStroke = false,
    this.strokeWidth = 2.0,
    this.strokeColor = Colors.red,
    this.enableOutline = false,
    this.outlineWidth = 0.0,
    this.outlineBlur = 10.0,
    this.outlineColor = Colors.blue,
    this.enableShadow = false,
    this.shadowOffsetX = 2.0,
    this.shadowOffsetY = 2.0,
    this.shadowBlur = 3.0,
    this.shadowColor = Colors.black,
    this.scrollDirection = ScrollDirection.rightToLeft,
    this.scrollSpeed = 100.0,
    this.backgroundColor = Colors.black,
    this.backgroundImage,
    this.enableFrame = false,
    this.frameImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'enableStroke': enableStroke,
      'strokeWidth': strokeWidth,
      'strokeColor': strokeColor.value,
      'enableOutline': enableOutline,
      'outlineWidth': outlineWidth,
      'outlineBlur': outlineBlur,
      'outlineColor': outlineColor.value,
      'enableShadow': enableShadow,
      'shadowOffsetX': shadowOffsetX,
      'shadowOffsetY': shadowOffsetY,
      'shadowBlur': shadowBlur,
      'shadowColor': shadowColor.value,
      'scrollDirection': scrollDirection.index,
      'scrollSpeed': scrollSpeed,
      'backgroundColor': backgroundColor.value,
      'backgroundImage': backgroundImage,
      'enableFrame': enableFrame,
      'frameImage': frameImage,
    };
  }

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      text: json['text'] ?? '',
      fontFamily: json['fontFamily'] ?? 'Roboto',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 80.0,
      enableStroke: json['enableStroke'] ?? false,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble() ?? 2.0,
      strokeColor: Color(json['strokeColor'] ?? 0xFFFF0000),
      enableOutline: json['enableOutline'] ?? false,
      outlineWidth: (json['outlineWidth'] as num?)?.toDouble() ?? 0.0,
      outlineBlur: (json['outlineBlur'] as num?)?.toDouble() ?? 10.0,
      outlineColor: Color(json['outlineColor'] ?? 0xFF0000FF),
      enableShadow: json['enableShadow'] ?? false,
      shadowOffsetX: (json['shadowOffsetX'] as num?)?.toDouble() ?? 2.0,
      shadowOffsetY: (json['shadowOffsetY'] as num?)?.toDouble() ?? 2.0,
      shadowBlur: (json['shadowBlur'] as num?)?.toDouble() ?? 3.0,
      shadowColor: Color(json['shadowColor'] ?? 0xFF000000),
      scrollDirection: ScrollDirection.values[json['scrollDirection'] ?? 0],
      scrollSpeed: (json['scrollSpeed'] as num?)?.toDouble() ?? 100.0,
      backgroundColor: Color(json['backgroundColor'] ?? 0xFF000000),
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
