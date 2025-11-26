import 'package:flutter/material.dart';
import 'models/template.dart';

enum ScrollDirection { rightToLeft, leftToRight, none }

class ScrollingTextRenderer extends StatefulWidget {
  final String text;
  final String fontFamily;
  final double fontSize;

  // Text color
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

  // Shadow
  final bool enableShadow;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;
  final Color shadowColor;
  final List<Color>? shadowGradientColors;
  final double shadowGradientRotation;

  // Scroll & Effects
  final EffectType effectType;
  final ScrollDirection scrollDirection;
  final double
  scrollSpeed; // Pixels per second for scroll, frequency/speed for bounce
  final double bounceValue; // Level for bounce effects
  final bool isPaused;

  // Blink effect
  final bool enableBlink;
  final double blinkDuration; // Duration in milliseconds

  const ScrollingTextRenderer({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    this.textColor = Colors.white,
    this.textGradientColors,
    this.textGradientRotation = 0,
    required this.enableStroke,
    required this.strokeWidth,
    required this.strokeColor,
    this.strokeGradientColors,
    this.strokeGradientRotation = 0,
    required this.enableOutline,
    required this.outlineWidth,
    required this.outlineBlur,
    required this.outlineColor,
    this.outlineGradientColors,
    this.outlineGradientRotation = 0,
    required this.enableShadow,
    required this.shadowOffsetX,
    required this.shadowOffsetY,
    required this.shadowBlur,
    required this.shadowColor,
    this.shadowGradientColors,
    this.shadowGradientRotation = 0,
    required this.effectType,
    required this.scrollDirection,
    required this.scrollSpeed,
    required this.bounceValue,
    this.isPaused = false,
    this.enableBlink = false,
    this.blinkDuration = 500.0,
  });

  @override
  State<ScrollingTextRenderer> createState() => _ScrollingTextRendererState();
}

class _ScrollingTextRendererState extends State<ScrollingTextRenderer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _blinkController;
  double _textWidth = 0;
  double _textHeight = 0;
  double _containerWidth = 0;
  double _containerHeight = 0;

  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
      setState(() {});
    });
    _controller.repeat();

    // Initialize blink controller
    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.blinkDuration.toInt()),
    );
    if (widget.enableBlink) {
      _blinkController.repeat(reverse: true);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureText());
  }

  @override
  void didUpdateWidget(ScrollingTextRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.fontFamily != widget.fontFamily ||
        oldWidget.fontSize != widget.fontSize ||
        oldWidget.enableStroke != widget.enableStroke ||
        oldWidget.strokeWidth != widget.strokeWidth ||
        oldWidget.enableOutline != widget.enableOutline ||
        oldWidget.outlineWidth != widget.outlineWidth ||
        oldWidget.enableShadow != widget.enableShadow ||
        oldWidget.shadowOffsetX != widget.shadowOffsetX ||
        oldWidget.shadowOffsetY != widget.shadowOffsetY ||
        oldWidget.shadowBlur != widget.shadowBlur ||
        oldWidget.shadowGradientColors != widget.shadowGradientColors ||
        oldWidget.shadowGradientRotation != widget.shadowGradientRotation) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureText());
    }
    if (oldWidget.scrollSpeed != widget.scrollSpeed ||
        oldWidget.effectType != widget.effectType ||
        oldWidget.bounceValue != widget.bounceValue) {
      _updateDuration();
    }

    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        if (!_controller.isAnimating && widget.scrollSpeed > 0) {
          _controller.repeat();
        }
      }
    }

    // Handle blink effect changes
    if (oldWidget.enableBlink != widget.enableBlink ||
        oldWidget.blinkDuration != widget.blinkDuration) {
      _blinkController.duration = Duration(
        milliseconds: widget.blinkDuration.toInt(),
      );
      if (widget.enableBlink) {
        _blinkController.repeat(reverse: true);
      } else {
        _blinkController.stop();
        _blinkController.value = 1.0; // Ensure full opacity when disabled
      }
    }
  }

  void _measureText() {
    final RenderBox? renderBox =
        _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _textWidth = renderBox.size.width;
        _textHeight = renderBox.size.height;
        _updateDuration();
      });
    }
  }

  void _updateDuration() {
    // Stop animation if speed is 0
    if (widget.scrollSpeed <= 0) {
      _controller.stop();
      return;
    }

    if (widget.effectType == EffectType.scroll) {
      if (widget.scrollDirection == ScrollDirection.none) {
        _controller.stop();
        return;
      }

      // Container width = message width + 200px gap
      const double containerGap = 200.0;
      double totalDistance = 0;

      if (widget.scrollDirection == ScrollDirection.leftToRight ||
          widget.scrollDirection == ScrollDirection.rightToLeft) {
        // Animation cycle = one container width (textWidth + gap)
        totalDistance = _textWidth + containerGap;
      }

      if (totalDistance == 0) return;

      final durationSeconds = totalDistance / widget.scrollSpeed;
      _controller.duration = Duration(
        milliseconds: (durationSeconds * 1000).toInt(),
      );
    } else {
      // Bounce effects
      // Speed controls frequency. Higher speed = faster bounce.
      // Let's say speed 100 = 1 second duration for full cycle?
      // Adjust mapping as needed.
      // Base duration 2 seconds at speed 50.
      // Duration = Constant / Speed
      final durationMilliseconds = (2000 * (50 / widget.scrollSpeed)).toInt();
      _controller.duration = Duration(
        milliseconds: durationMilliseconds.clamp(100, 5000),
      );
    }

    // Restart animation to apply new duration immediately
    if (!widget.isPaused) {
      _controller
        ..reset()
        ..repeat(reverse: widget.effectType != EffectType.scroll);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        _containerHeight = constraints.maxHeight;

        // Common variables
        final double value = _controller.value; // 0.0 to 1.0
        final double offsetY = (_containerHeight - _textHeight) / 2;

        if (widget.effectType == EffectType.scroll) {
          // --- SCROLL EFFECT ---
          // Container approach: each container = textWidth + 200
          // Message is centered in container
          const double containerGap = 200.0;
          final double containerWidth = _textWidth + containerGap;
          final double startX = _containerWidth * 0.75;
          final double messageOffsetInContainer = containerGap / 2;

          List<Widget> visibleWidgets = [];

          // Helper to add widget if visible
          void addIfVisible(double xPos) {
            final double msgLeft = xPos + messageOffsetInContainer;
            final double msgRight = msgLeft + _textWidth;

            if (msgRight > 0 && msgLeft < _containerWidth) {
              visibleWidgets.add(
                Positioned(
                  left: msgLeft,
                  top: offsetY,
                  child: _buildTextWidget(),
                ),
              );
            }
          }

          if (widget.scrollDirection == ScrollDirection.none) {
            visibleWidgets.add(
              Positioned(
                left: (_containerWidth - _textWidth) / 2,
                top: offsetY,
                child: _buildTextWidget(),
              ),
            );
          } else {
            for (int k = -10; k <= 10; k++) {
              double containerX = 0;
              if (widget.scrollDirection == ScrollDirection.rightToLeft) {
                containerX =
                    startX - (value * containerWidth) + (k * containerWidth);
              } else {
                containerX =
                    startX + (value * containerWidth) - (k * containerWidth);
              }
              addIfVisible(containerX);
            }
          }

          return ClipRect(
            child: AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                return Opacity(
                  opacity: widget.enableBlink ? _blinkController.value : 1.0,
                  child: child,
                );
              },
              child: Stack(
                children: [
                  Positioned(
                    left: -10000,
                    child: Container(key: _textKey, child: _buildTextWidget()),
                  ),
                  ...visibleWidgets,
                ],
              ),
            ),
          );
        } else {
          // --- BOUNCE EFFECTS ---
          // Center the text first
          double centerX = (_containerWidth - _textWidth) / 2;
          double centerY = offsetY;

          Widget content = Positioned(
            left: centerX,
            top: centerY,
            child: _buildTextWidget(),
          );

          // Apply transformations based on effect type
          // value goes 0->1->0 because of reverse: true
          // We want sine wave behavior for smooth bounce?
          // Controller is linear 0->1.
          // Let's use a curve or just map 0->1 directly.
          // Since we use repeat(reverse:true), value goes 0->1 then 1->0.

          return ClipRect(
            child: AnimatedBuilder(
              animation: Listenable.merge([_controller, _blinkController]),
              builder: (context, child) {
                Widget transformedChild = Stack(
                  children: [
                    Positioned(
                      left: -10000,
                      child: Container(
                        key: _textKey,
                        child: _buildTextWidget(),
                      ),
                    ),
                    content,
                  ],
                );

                // Apply Blink
                if (widget.enableBlink) {
                  transformedChild = Opacity(
                    opacity: _blinkController.value,
                    child: transformedChild,
                  );
                }

                // Apply Bounce
                // Normalize value to -1 to 1 for some effects if needed,
                // or 0 to 1 is fine.
                // Current value: 0.0 -> 1.0 -> 0.0

                if (widget.effectType == EffectType.bounceZoom) {
                  // Zoom: -20%/20% -> -200%/200%
                  // Level (bounceValue) is percentage (e.g. 20 to 200)
                  // Let's assume bounceValue is 20.0 to 200.0.
                  // Scale factor: 1.0 +/- (bounceValue / 100)
                  // We want to oscillate.
                  // Let's make it zoom IN and OUT.
                  // 0.0 -> 1.0 (max zoom) -> 0.0 (normal)
                  // Wait, user said "-20%/20%". Maybe min/max scale?
                  // Let's implement: Scale varies from 1.0 to (1.0 + bounceValue/100).
                  // Or better: 1.0 is center.
                  // Scale = 1.0 + (value * (bounceValue / 100))
                  // If value goes 0->1->0, then scale goes 1.0 -> 1.2 -> 1.0.
                  // If we want zoom OUT too, we might need offset.
                  // Let's assume simple zoom in for now, or zoom in/out around 1.0?
                  // "bounce zoom: level(-20%/20% -> -200%/200%)"
                  // This notation suggests range.
                  // Let's map 0..1 to -1..1 for sine wave feel?
                  // But controller is linear.
                  // Let's use sin(value * 2 * pi)? No, value is 0->1.
                  // With reverse: true, it's a triangle wave 0->1->0.
                  // Let's use that.
                  // Scale = 1.0 + ((value - 0.5) * 2) * (bounceValue / 100)
                  // If value=0, scale = 1 - level. Value=0.5, scale=1. Value=1, scale=1+level.
                  // This gives full range -level to +level.

                  final double level = widget.bounceValue / 100.0;
                  // value is 0->1.
                  // We want -1 -> 1 range for oscillation.
                  // (value - 0.5) * 2 gives -1 -> 1.
                  final double oscillation = (value - 0.5) * 2;
                  final double scale = 1.0 + (oscillation * level);

                  // Clamp scale to avoid negative or zero if level is high (>100%)
                  // If level is 200% (2.0), scale goes 1 - 2 = -1 (flipped) to 3.
                  // Flipped text might be intended? "bounce zoom" usually implies getting bigger/smaller.
                  // Let's allow it.

                  transformedChild = Transform.scale(
                    scale: scale,
                    alignment: Alignment.center,
                    child: transformedChild,
                  );
                } else if (widget.effectType == EffectType.bounceHorizontal) {
                  // Horizontal: -5%/5% -> -100%/100% of text WIDTH
                  final double level = widget.bounceValue / 100.0;
                  final double maxOffset = _textWidth * level;
                  final double oscillation = (value - 0.5) * 2; // -1 to 1
                  final double dx = oscillation * maxOffset;

                  transformedChild = Transform.translate(
                    offset: Offset(dx, 0),
                    child: transformedChild,
                  );
                } else if (widget.effectType == EffectType.bounceVertical) {
                  // Vertical: -5%/5% -> -100%/100% of text HEIGHT
                  final double level = widget.bounceValue / 100.0;
                  final double maxOffset = _textHeight * level;
                  final double oscillation = (value - 0.5) * 2; // -1 to 1
                  final double dy = oscillation * maxOffset;

                  transformedChild = Transform.translate(
                    offset: Offset(0, dy),
                    child: transformedChild,
                  );
                }

                return transformedChild;
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildTextWidget() {
    // Helper to create gradient shader
    Shader? _createGradientShader(
      List<Color>? colors,
      double rotation,
      Rect bounds,
    ) {
      if (colors == null || colors.isEmpty) return null;
      if (bounds.isEmpty) return null;

      // Ensure at least 2 colors for LinearGradient
      final effectiveColors =
          colors.length == 1 ? [colors.first, colors.first] : colors;

      final gradient = LinearGradient(
        colors: effectiveColors,
        transform: GradientRotation(rotation * 3.14159 / 180),
      );

      return gradient.createShader(bounds);
    }

    TextStyle baseStyle = TextStyle(
      fontFamily: widget.fontFamily,
      fontSize: widget.fontSize,
      color: widget.textColor,
    );

    List<Widget> layers = [];

    // Calculate text bounds for gradient shader
    final textBounds = Rect.fromLTWH(0, 0, _textWidth, _textHeight);

    // 1. Shadow Layer (Bottom-most)
    // 1. Shadow Layer (Bottom-most)
    if (widget.enableShadow) {
      // Create shader for shadow if gradient is enabled
      final shadowShader = _createGradientShader(
        widget.shadowGradientColors,
        widget.shadowGradientRotation,
        textBounds,
      );

      if (shadowShader != null) {
        // Gradient Shadow: Render as a separate blurred text layer
        layers.add(
          Transform.translate(
            offset: Offset(widget.shadowOffsetX, widget.shadowOffsetY),
            child: Text(
              widget.text,
              style: baseStyle.copyWith(
                foreground:
                    Paint()
                      ..style = PaintingStyle.fill
                      ..maskFilter = MaskFilter.blur(
                        BlurStyle.normal,
                        widget.shadowBlur,
                      )
                      ..shader = shadowShader,
              ),
            ),
          ),
        );
      } else {
        // Solid Color Shadow: Use standard TextStyle shadows
        layers.add(
          Text(
            widget.text,
            style: baseStyle.copyWith(
              shadows: [
                Shadow(
                  offset: Offset(widget.shadowOffsetX, widget.shadowOffsetY),
                  blurRadius: widget.shadowBlur,
                  color: widget.shadowColor,
                ),
              ],
            ),
          ),
        );
      }
    }

    // 2. Outline Layer (Glow)
    if (widget.enableOutline) {
      final outlineShader = _createGradientShader(
        widget.outlineGradientColors,
        widget.outlineGradientRotation,
        textBounds,
      );

      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.outlineWidth
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round
                  ..maskFilter = MaskFilter.blur(
                    BlurStyle.normal,
                    widget.outlineBlur,
                  )
                  ..shader = outlineShader
                  ..color =
                      outlineShader == null
                          ? widget.outlineColor
                          : Colors.white,
          ),
        ),
      );
    }

    // 3. Stroke Layer (Optional)
    if (widget.enableStroke) {
      final strokeShader = _createGradientShader(
        widget.strokeGradientColors,
        widget.strokeGradientRotation,
        textBounds,
      );

      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.strokeWidth
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round
                  ..shader = strokeShader
                  ..color =
                      strokeShader == null ? widget.strokeColor : Colors.white,
          ),
        ),
      );
    }

    // 4. Fill Layer (Main Text)
    final textShader = _createGradientShader(
      widget.textGradientColors,
      widget.textGradientRotation,
      textBounds,
    );

    if (textShader != null) {
      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(foreground: Paint()..shader = textShader),
        ),
      );
    } else {
      layers.add(Text(widget.text, style: baseStyle));
    }

    return Stack(children: layers);
  }
}
