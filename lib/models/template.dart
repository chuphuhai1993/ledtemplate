import 'package:flutter/material.dart';
import '../scrolling_text_renderer.dart';

enum BounceDirection { horizontal, vertical }

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
  final List<Color>? shadowGradientColors;
  final double shadowGradientRotation;

  // Effects - can enable multiple simultaneously
  final bool enableScroll;
  final bool enableBounceZoom;
  final bool enableBounce;
  final BounceDirection bounceDirection;
  final ScrollDirection scrollDirection;

  // Independent controls
  final double scrollSpeed;

  final double zoomLevel;
  final double zoomSpeed;

  final double bounceLevel;
  final double bounceSpeed;

  // Deprecated but kept for migration if needed internally, though we won't expose it

  // Blink effect
  final bool enableBlink;
  final double blinkDuration; // Duration in milliseconds

  // Rotation bounce effect
  final bool enableRotationBounce;
  final double rotationStart; // Start angle in degrees (-45 to 45)
  final double rotationEnd; // End angle in degrees (-45 to 45)
  final double rotationSpeed; // Speed (0-100)

  // Background
  final Color backgroundColor;
  final List<Color>? backgroundGradientColors;
  final double backgroundGradientRotation;
  final String? backgroundImage;

  // Frame
  final bool enableFrame;
  final String? frameImage;

  // Frame Glow
  final bool enableFrameGlow;
  final double frameGlowSize;
  final double frameGlowBlur;
  final double frameGlowBorderRadius;
  final Color frameGlowColor;
  final List<Color>? frameGlowGradientColors;
  final double frameGlowGradientRotation;

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
    this.shadowGradientColors,
    this.shadowGradientRotation = 0,
    this.enableScroll = true,
    this.enableBounceZoom = false,
    this.enableBounce = false,
    this.bounceDirection = BounceDirection.horizontal,
    this.scrollDirection = ScrollDirection.rightToLeft,
    this.scrollSpeed = 100.0,
    this.zoomLevel = 20.0,
    this.zoomSpeed = 50.0,
    this.bounceLevel = 20.0,
    this.bounceSpeed = 50.0,
    this.enableBlink = false,
    this.blinkDuration = 500.0,
    this.enableRotationBounce = false,
    this.rotationStart = -15.0,
    this.rotationEnd = 15.0,
    this.rotationSpeed = 50.0,
    this.backgroundColor = Colors.black,
    this.backgroundGradientColors,
    this.backgroundGradientRotation = 0,
    this.backgroundImage,
    this.enableFrame = false,
    this.frameImage,
    this.enableFrameGlow = false,
    this.frameGlowSize = 5.0,
    this.frameGlowBlur = 10.0,
    this.frameGlowBorderRadius = 20.0,
    this.frameGlowColor = Colors.blue,
    this.frameGlowGradientColors,
    this.frameGlowGradientRotation = 0,
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
      'shadowGradientColors':
          shadowGradientColors?.map((c) => c.value).toList(),
      'shadowGradientRotation': shadowGradientRotation,
      'enableScroll': enableScroll,
      'enableBounceZoom': enableBounceZoom,
      'enableBounce': enableBounce,
      'bounceDirection': bounceDirection.index,
      'scrollDirection': scrollDirection.index,
      'scrollSpeed': scrollSpeed,
      'zoomLevel': zoomLevel,
      'zoomSpeed': zoomSpeed,
      'bounceLevel': bounceLevel,
      'bounceSpeed': bounceSpeed,
      'enableBlink': enableBlink,
      'blinkDuration': blinkDuration,
      'enableRotationBounce': enableRotationBounce,
      'rotationStart': rotationStart,
      'rotationEnd': rotationEnd,
      'rotationSpeed': rotationSpeed,
      'backgroundColor': backgroundColor.value,
      'backgroundGradientColors':
          backgroundGradientColors?.map((c) => c.value).toList(),
      'backgroundGradientRotation': backgroundGradientRotation,
      'backgroundImage': backgroundImage,
      'enableFrame': enableFrame,
      'frameImage': frameImage,
      'enableFrameGlow': enableFrameGlow,
      'frameGlowSize': frameGlowSize,
      'frameGlowBlur': frameGlowBlur,
      'frameGlowBorderRadius': frameGlowBorderRadius,
      'frameGlowColor': frameGlowColor.value,
      'frameGlowGradientColors':
          frameGlowGradientColors?.map((c) => c.value).toList(),
      'frameGlowGradientRotation': frameGlowGradientRotation,
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

    // Migration logic: convert old effectType to new effect flags
    bool enableScroll = json['enableScroll'] ?? true;
    bool enableBounceZoom = json['enableBounceZoom'] ?? false;
    bool enableBounce = json['enableBounce'] ?? false;
    BounceDirection bounceDirection =
        json['bounceDirection'] != null
            ? BounceDirection.values[json['bounceDirection']]
            : BounceDirection.horizontal;

    // If old effectType exists, migrate it
    if (json['effectType'] != null && json['enableScroll'] == null) {
      // Old format detected, migrate
      final oldEffectType = json['effectType'] as int;
      enableScroll = false;
      enableBounceZoom = false;
      enableBounce = false;

      switch (oldEffectType) {
        case 0: // EffectType.scroll
          enableScroll = true;
          break;
        case 1: // EffectType.bounceZoom
          enableBounceZoom = true;
          break;
        case 2: // EffectType.bounceHorizontal
          enableBounce = true;
          bounceDirection = BounceDirection.horizontal;
          break;
        case 3: // EffectType.bounceVertical
          enableBounce = true;
          bounceDirection = BounceDirection.vertical;
          break;
      }
    }

    // Migration for separated speeds/levels
    // If new fields are missing, try to use old 'bounceValue' or 'scrollSpeed'
    double bounceValue = (json['bounceValue'] as num?)?.toDouble() ?? 20.0;
    double scrollSpeed = (json['scrollSpeed'] as num?)?.toDouble() ?? 100.0;

    double zoomLevel = (json['zoomLevel'] as num?)?.toDouble() ?? bounceValue;
    double zoomSpeed =
        (json['zoomSpeed'] as num?)?.toDouble() ?? 50.0; // Default

    double bounceLevel =
        (json['bounceLevel'] as num?)?.toDouble() ?? bounceValue;
    double bounceSpeed =
        (json['bounceSpeed'] as num?)?.toDouble() ?? 50.0; // Default

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
      shadowGradientColors: parseGradientColors(json['shadowGradientColors']),
      shadowGradientRotation:
          (json['shadowGradientRotation'] as num?)?.toDouble() ?? 0,
      enableScroll: enableScroll,
      enableBounceZoom: enableBounceZoom,
      enableBounce: enableBounce,
      bounceDirection: bounceDirection,
      scrollDirection:
          json['scrollDirection'] != null
              ? ScrollDirection.values[json['scrollDirection']]
              : ScrollDirection.rightToLeft,
      scrollSpeed: scrollSpeed,
      zoomLevel: zoomLevel,
      zoomSpeed: zoomSpeed,
      bounceLevel: bounceLevel,
      bounceSpeed: bounceSpeed,
      enableBlink: json['enableBlink'] ?? false,
      blinkDuration: (json['blinkDuration'] as num?)?.toDouble() ?? 500.0,
      enableRotationBounce: json['enableRotationBounce'] ?? false,
      rotationStart: (json['rotationStart'] as num?)?.toDouble() ?? -15.0,
      rotationEnd: (json['rotationEnd'] as num?)?.toDouble() ?? 15.0,
      rotationSpeed: (json['rotationSpeed'] as num?)?.toDouble() ?? 50.0,
      backgroundColor: Color(json['backgroundColor'] ?? 0xFF000000),
      backgroundGradientColors: parseGradientColors(
        json['backgroundGradientColors'],
      ),
      backgroundGradientRotation:
          (json['backgroundGradientRotation'] as num?)?.toDouble() ?? 0,
      backgroundImage: json['backgroundImage'],
      enableFrame: json['enableFrame'] ?? false,
      frameImage: json['frameImage'],
      enableFrameGlow: json['enableFrameGlow'] ?? false,
      frameGlowSize: (json['frameGlowSize'] as num?)?.toDouble() ?? 5.0,
      frameGlowBlur: (json['frameGlowBlur'] as num?)?.toDouble() ?? 10.0,
      frameGlowBorderRadius:
          (json['frameGlowBorderRadius'] as num?)?.toDouble() ?? 20.0,
      frameGlowColor: Color(json['frameGlowColor'] ?? 0xFF2196F3),
      frameGlowGradientColors: parseGradientColors(
        json['frameGlowGradientColors'],
      ),
      frameGlowGradientRotation:
          (json['frameGlowGradientRotation'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TemplateCategory {
  final String name;
  final List<Template> templates;

  const TemplateCategory({required this.name, required this.templates});
}
