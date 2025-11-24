import 'package:flutter/material.dart';

enum ScrollDirection { leftToRight, rightToLeft, topToBottom, bottomToTop }

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
    if (widget.scrollSpeed <= 0) {
      _controller.stop();
      return;
    }

    double totalDistance = 0;
    if (widget.scrollDirection == ScrollDirection.leftToRight ||
        widget.scrollDirection == ScrollDirection.rightToLeft) {
      totalDistance = _containerWidth + _textWidth;
    } else {
      totalDistance = _containerHeight + _textHeight;
    }

    if (totalDistance == 0) return;

    final durationSeconds = totalDistance / widget.scrollSpeed;
    _controller.duration = Duration(
      milliseconds: (durationSeconds * 1000).toInt(),
    );

    if (!widget.isPaused && !_controller.isAnimating) {
      _controller.repeat();
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

        // Calculate offset based on animation value
        double offsetX = 0;
        double offsetY = 0;

        final double value = _controller.value;

        switch (widget.scrollDirection) {
          case ScrollDirection.rightToLeft:
            // Start at containerWidth, end at -textWidth
            offsetX = _containerWidth - value * (_containerWidth + _textWidth);
            offsetY = (_containerHeight - _textHeight) / 2;
            break;
          case ScrollDirection.leftToRight:
            // Start at -textWidth, end at containerWidth
            offsetX = -_textWidth + value * (_containerWidth + _textWidth);
            offsetY = (_containerHeight - _textHeight) / 2;
            break;
          case ScrollDirection.topToBottom:
            // Start at -textHeight, end at containerHeight
            offsetY = -_textHeight + value * (_containerHeight + _textHeight);
            offsetX = (_containerWidth - _textWidth) / 2;
            break;
          case ScrollDirection.bottomToTop:
            // Start at containerHeight, end at -textHeight
            offsetY =
                _containerHeight - value * (_containerHeight + _textHeight);
            offsetX = (_containerWidth - _textWidth) / 2;
            break;
        }

        return ClipRect(
          child: Stack(
            children: [
              // Hidden text for measurement
              Positioned(
                left: -10000,
                child: Container(key: _textKey, child: _buildTextWidget()),
              ),
              // Visible scrolling text
              Positioned(
                left: offsetX,
                top: offsetY,
                child: _buildTextWidget(),
              ),
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
