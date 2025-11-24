import 'package:flutter/material.dart';

enum ScrollDirection { rightToLeft, leftToRight, none }

class ScrollingTextRenderer extends StatefulWidget {
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
  final double scrollSpeed; // Pixels per second
  final bool isPaused;

  const ScrollingTextRenderer({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.enableStroke,
    required this.strokeWidth,
    required this.strokeColor,
    required this.enableOutline,
    required this.outlineWidth,
    required this.outlineBlur,
    required this.outlineColor,
    required this.enableShadow,
    required this.shadowOffsetX,
    required this.shadowOffsetY,
    required this.shadowBlur,
    required this.shadowColor,
    required this.scrollDirection,
    required this.scrollSpeed,
    this.isPaused = false,
  });

  @override
  State<ScrollingTextRenderer> createState() => _ScrollingTextRendererState();
}

class _ScrollingTextRendererState extends State<ScrollingTextRenderer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
        oldWidget.shadowBlur != widget.shadowBlur) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _measureText());
    }
    if (oldWidget.scrollSpeed != widget.scrollSpeed) {
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
    // Stop animation if speed is 0 or direction is none
    if (widget.scrollSpeed <= 0 ||
        widget.scrollDirection == ScrollDirection.none) {
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

    // Restart animation to apply new duration immediately
    if (!widget.isPaused) {
      _controller
        ..reset()
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        _containerHeight = constraints.maxHeight;

        // Container approach: each container = textWidth + 200
        // Message is centered in container
        const double containerGap = 200.0;
        final double containerWidth = _textWidth + containerGap;

        final double value = _controller.value;
        final double startX = _containerWidth * 0.75;

        // Message is centered in container, so offset by gap/2
        final double messageOffsetInContainer = containerGap / 2;
        final double offsetY = (_containerHeight - _textHeight) / 2;

        List<Widget> visibleWidgets = [];

        // Helper to add widget if visible
        void addIfVisible(double xPos) {
          // Check if message is visible
          // Message starts at xPos + messageOffsetInContainer
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
          // Render enough containers to cover the screen
          // We check a range of indices. -10 to 10 is plenty for most screens.
          for (int k = -10; k <= 10; k++) {
            double containerX = 0;
            if (widget.scrollDirection == ScrollDirection.rightToLeft) {
              // pos = startX - value*W + k*W
              containerX =
                  startX - (value * containerWidth) + (k * containerWidth);
            } else {
              // pos = startX + value*W - k*W
              // Note: k represents previous/next containers.
              // If moving Right, "next" container (k=1) should be to the LEFT.
              containerX =
                  startX + (value * containerWidth) - (k * containerWidth);
            }
            addIfVisible(containerX);
          }
        }

        return ClipRect(
          child: Stack(
            children: [
              // Hidden text for measurement
              Positioned(
                left: -10000,
                child: Container(key: _textKey, child: _buildTextWidget()),
              ),

              ...visibleWidgets,
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextWidget() {
    TextStyle baseStyle = TextStyle(
      fontFamily: widget.fontFamily,
      fontSize: widget.fontSize,
      color: Colors.white,
    );

    List<Widget> layers = [];

    // 1. Shadow Layer (Bottom-most)
    if (widget.enableShadow) {
      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(
            color:
                Colors
                    .transparent, // Use transparent text so only shadow is visible?
            // Note: If text is transparent, shadow might not render in some Flutter versions/configs.
            // However, usually shadow alpha is multiplied by text alpha.
            // To be safe and since it's covered anyway, let's use the shadow color for the text too,
            // or just keep baseStyle but we rely on it being covered.
            // Actually, to ensure the shadow is "below" everything, we just render it first.
            // If we render the text opaque here, it might show artifacts if top layers don't cover it perfectly (e.g. anti-aliasing).
            // But standard practice is fine.
            // Let's try using the shadow color for the text itself to blend better if visible?
            // No, let's just use baseStyle but with the shadow.
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

    // 2. Outline Layer (Glow)
    if (widget.enableOutline) {
      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.outlineWidth
                  ..color = widget.outlineColor
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round
                  ..maskFilter = MaskFilter.blur(
                    BlurStyle.normal,
                    widget.outlineBlur,
                  ),
          ),
        ),
      );
    }

    // 3. Stroke Layer (Optional)
    if (widget.enableStroke) {
      layers.add(
        Text(
          widget.text,
          style: baseStyle.copyWith(
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.strokeWidth
                  ..color = widget.strokeColor
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round,
          ),
        ),
      );
    }

    // 4. Fill Layer (Main Text)
    layers.add(Text(widget.text, style: baseStyle));

    return Stack(children: layers);
  }
}
