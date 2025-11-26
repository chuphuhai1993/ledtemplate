import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'models/template.dart';

enum ScrollDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
  none,
}

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
  final bool enableScroll;
  final bool enableBounceZoom;
  final bool enableBounce;
  final BounceDirection bounceDirection;
  final ScrollDirection scrollDirection;

  final double scrollSpeed;

  final double zoomLevel;
  final double zoomSpeed;

  final double bounceLevel;
  final double bounceSpeed;

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
    required this.enableScroll,
    required this.enableBounceZoom,
    required this.enableBounce,
    required this.bounceDirection,
    required this.scrollDirection,
    required this.scrollSpeed,
    required this.zoomLevel,
    required this.zoomSpeed,
    required this.bounceLevel,
    required this.bounceSpeed,
    this.isPaused = false,
    this.enableBlink = false,
    this.blinkDuration = 500.0,
  });

  @override
  State<ScrollingTextRenderer> createState() => _ScrollingTextRendererState();
}

class _ScrollingTextRendererState extends State<ScrollingTextRenderer>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _zoomController;
  late AnimationController _bounceController;
  late AnimationController _blinkController;

  double _textWidth = 0;
  double _textHeight = 0;
  double _containerWidth = 0;
  double _containerHeight = 0;

  final GlobalKey _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Scroll Controller
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() => setState(() {}));

    // Zoom Controller
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() => setState(() {}));

    // Bounce Controller
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() => setState(() {}));

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
        oldWidget.scrollDirection != widget.scrollDirection ||
        oldWidget.enableScroll != widget.enableScroll ||
        oldWidget.enableBounceZoom != widget.enableBounceZoom ||
        oldWidget.enableBounce != widget.enableBounce ||
        oldWidget.zoomSpeed != widget.zoomSpeed ||
        oldWidget.bounceSpeed != widget.bounceSpeed) {
      _updateDurations();
    }

    if (oldWidget.isPaused != widget.isPaused) {
      if (widget.isPaused) {
        _scrollController.stop();
        _zoomController.stop();
        _bounceController.stop();
      } else {
        _updateDurations(); // Restart enabled animations
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
        _blinkController.value = 1.0;
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
        _updateDurations();
      });
    }
  }

  void _updateDurations() {
    if (widget.isPaused) return;

    // --- SCROLL ---
    if (widget.enableScroll &&
        widget.scrollSpeed > 0 &&
        widget.scrollDirection != ScrollDirection.none) {
      const double containerGap = 200.0;
      double totalDistance;

      // Calculate distance based on scroll direction
      if (widget.scrollDirection == ScrollDirection.topToBottom ||
          widget.scrollDirection == ScrollDirection.bottomToTop) {
        // Vertical scrolling - use text height
        totalDistance = _textHeight + containerGap;
      } else {
        // Horizontal scrolling - use text width
        totalDistance = _textWidth + containerGap;
      }

      if (totalDistance > 0) {
        final durationSeconds = totalDistance / widget.scrollSpeed;
        final newDuration = Duration(
          milliseconds: (durationSeconds * 1000).toInt(),
        );

        // Only restart if duration changed
        if (_scrollController.duration != newDuration) {
          _scrollController.stop();
          _scrollController.duration = newDuration;
          _scrollController.repeat();
        } else if (!_scrollController.isAnimating) {
          _scrollController.repeat();
        }
      }
    } else {
      _scrollController.stop();
      _scrollController.reset();
    }

    // --- ZOOM ---
    if (widget.enableBounceZoom && widget.zoomSpeed > 0) {
      // Speed 0-100. 50 is normal (~2s). 100 is fast (~0.5s). 1 is slow (~10s).
      // Formula: duration = 2000 * (50 / speed)
      final durationMs = (2000 * (50 / widget.zoomSpeed)).toInt().clamp(
        100,
        10000,
      );
      final newDuration = Duration(milliseconds: durationMs);

      // Only restart if duration changed
      if (_zoomController.duration != newDuration) {
        _zoomController.stop();
        _zoomController.duration = newDuration;
        _zoomController.repeat();
      } else if (!_zoomController.isAnimating) {
        _zoomController.repeat();
      }
    } else {
      _zoomController.stop();
      _zoomController.reset();
    }

    // --- BOUNCE ---
    if (widget.enableBounce && widget.bounceSpeed > 0) {
      final durationMs = (2000 * (50 / widget.bounceSpeed)).toInt().clamp(
        100,
        10000,
      );
      final newDuration = Duration(milliseconds: durationMs);

      // Only restart if duration changed
      if (_bounceController.duration != newDuration) {
        _bounceController.stop();
        _bounceController.duration = newDuration;
        _bounceController.repeat();
      } else if (!_bounceController.isAnimating) {
        _bounceController.repeat();
      }
    } else {
      _bounceController.stop();
      _bounceController.reset();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _zoomController.dispose();
    _bounceController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        _containerHeight = constraints.maxHeight;

        final double offsetY = (_containerHeight - _textHeight) / 2;

        bool hasScrollEffect =
            widget.enableScroll &&
            widget.scrollDirection != ScrollDirection.none;

        // Build the text widget with bounce transforms applied
        Widget buildTransformedText() {
          Widget textWidget = _buildTextWidget();

          // Apply Zoom
          if (widget.enableBounceZoom) {
            final double zoomValue = _zoomController.value;
            // Sine wave 0->1->0->-1->0
            final double oscillation = math.sin(zoomValue * 2 * math.pi);
            final double level = widget.zoomLevel / 100.0;
            final double scale = 1.0 + (oscillation * level);

            textWidget = Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: textWidget,
            );
          }

          // Apply Bounce
          if (widget.enableBounce) {
            final double bounceVal = _bounceController.value;
            final double oscillation = math.sin(bounceVal * 2 * math.pi);
            final double level = widget.bounceLevel / 100.0;

            if (widget.bounceDirection == BounceDirection.horizontal) {
              final double maxOffset = _textWidth * level;
              final double dx = oscillation * maxOffset;
              textWidget = Transform.translate(
                offset: Offset(dx, 0),
                child: textWidget,
              );
            } else {
              final double maxOffset =
                  _textHeight *
                  level; // Use text height for vertical bounce scale
              // Or maybe container height? Usually text height is better for relative bounce.
              // Let's use a fixed reasonable value or text height.
              // If text is small, bounce might be small.
              // Let's use 50% of container height as base? No, text height is safer.
              final double dy = oscillation * maxOffset;
              textWidget = Transform.translate(
                offset: Offset(0, dy),
                child: textWidget,
              );
            }
          }

          return textWidget;
        }

        if (hasScrollEffect) {
          // --- SCROLL EFFECT ---
          final double scrollValue = _scrollController.value;
          const double containerGap = 200.0;

          // Determine if scrolling is horizontal or vertical
          final bool isHorizontalScroll =
              widget.scrollDirection == ScrollDirection.rightToLeft ||
              widget.scrollDirection == ScrollDirection.leftToRight;
          final bool isVerticalScroll =
              widget.scrollDirection == ScrollDirection.topToBottom ||
              widget.scrollDirection == ScrollDirection.bottomToTop;

          List<Widget> visibleWidgets = [];

          if (isHorizontalScroll) {
            // Horizontal scrolling logic
            final double containerWidth = _textWidth + containerGap;
            final double startX = _containerWidth * 0.75;
            final double messageOffsetInContainer = containerGap / 2;

            void addIfVisible(double xPos) {
              final double msgLeft = xPos + messageOffsetInContainer;
              final double msgRight = msgLeft + _textWidth;

              if (msgRight > 0 && msgLeft < _containerWidth) {
                visibleWidgets.add(
                  Positioned(
                    left: msgLeft,
                    top: offsetY,
                    child: buildTransformedText(),
                  ),
                );
              }
            }

            for (int k = -10; k <= 10; k++) {
              double containerX = 0;
              if (widget.scrollDirection == ScrollDirection.rightToLeft) {
                containerX =
                    startX -
                    (scrollValue * containerWidth) +
                    (k * containerWidth);
              } else {
                containerX =
                    startX +
                    (scrollValue * containerWidth) -
                    (k * containerWidth);
              }
              addIfVisible(containerX);
            }
          } else if (isVerticalScroll) {
            // Vertical scrolling logic
            final double containerHeight = _textHeight + containerGap;
            final double startY = _containerHeight * 0.75;
            final double messageOffsetInContainer = containerGap / 2;
            final double centerX = (_containerWidth - _textWidth) / 2;

            void addIfVisible(double yPos) {
              final double msgTop = yPos + messageOffsetInContainer;
              final double msgBottom = msgTop + _textHeight;

              if (msgBottom > 0 && msgTop < _containerHeight) {
                visibleWidgets.add(
                  Positioned(
                    left: centerX,
                    top: msgTop,
                    child: buildTransformedText(),
                  ),
                );
              }
            }

            for (int k = -10; k <= 10; k++) {
              double containerY = 0;
              if (widget.scrollDirection == ScrollDirection.bottomToTop) {
                containerY =
                    startY -
                    (scrollValue * containerHeight) +
                    (k * containerHeight);
              } else {
                containerY =
                    startY +
                    (scrollValue * containerHeight) -
                    (k * containerHeight);
              }
              addIfVisible(containerY);
            }
          }

          return ClipRect(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scrollController,
                _zoomController,
                _bounceController,
                _blinkController,
              ]),
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
          // --- CENTERED ---
          double centerX = (_containerWidth - _textWidth) / 2;
          double centerY = offsetY;

          return ClipRect(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _zoomController,
                _bounceController,
                _blinkController,
              ]),
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
                    Positioned(
                      left: centerX,
                      top: centerY,
                      child: buildTransformedText(),
                    ),
                  ],
                );

                if (widget.enableBlink) {
                  transformedChild = Opacity(
                    opacity: _blinkController.value,
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
