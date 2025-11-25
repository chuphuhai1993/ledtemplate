import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'scrolling_text_renderer.dart';

class PlayPage extends StatefulWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final Color textColor;
  final List<Color>? textGradientColors;
  final double textGradientRotation;
  final bool enableStroke;
  final double strokeWidth;
  final Color strokeColor;
  final List<Color>? strokeGradientColors;
  final double strokeGradientRotation;
  final bool enableOutline;
  final double outlineWidth;
  final double outlineBlur;
  final Color outlineColor;
  final List<Color>? outlineGradientColors;
  final double outlineGradientRotation;
  final bool enableShadow;
  final double shadowOffsetX;
  final double shadowOffsetY;
  final double shadowBlur;
  final Color shadowColor;
  final ScrollDirection scrollDirection;
  final double scrollSpeed;
  final Color backgroundColor;
  final List<Color>? backgroundGradientColors;
  final double backgroundGradientRotation;
  final String? backgroundImage;
  final bool enableFrame;
  final String? frameImage;
  final int? templateIndex;
  final bool fromResultPage;

  const PlayPage({
    super.key,
    required this.text,
    required this.fontFamily,
    required this.fontSize,
    required this.textColor,
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
    required this.scrollDirection,
    required this.scrollSpeed,
    required this.backgroundColor,
    this.backgroundGradientColors,
    this.backgroundGradientRotation = 0,
    required this.backgroundImage,
    required this.enableFrame,
    required this.frameImage,
    this.templateIndex,
    this.fromResultPage = false,
  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool _controlsVisible = true;
  bool _isLocked = false;
  bool _isPaused = false;
  Timer? _hideTimer;
  double _brightness = 1.0;

  @override
  void initState() {
    super.initState();
    // Enter full screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startHideTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Force Landscape for "scrolling text across screen"
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Restore orientation
    SystemChrome.setPreferredOrientations([]);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_isLocked) {
        setState(() {
          _controlsVisible = false;
        });
      } else if (mounted && _isLocked) {
        // Also auto-hide if locked (if user tapped to see unlock button)
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) {
      _startHideTimer();
    }
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
      // If we just locked, hide controls immediately
      if (_isLocked) {
        _controlsVisible = false;
      } else {
        // If unlocked, keep controls visible and restart timer
        _controlsVisible = true;
        _startHideTimer();
      }
    });
  }

  Future<void> _setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
      setState(() {
        _brightness = value;
      });
    } catch (e) {
      // Handle error silently
    }
  }

  void _showCloseExploreBottomSheet() {
    // Pause the text
    setState(() {
      _isPaused = true;
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false, // Force user to choose an action
      enableDrag: false,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Are you sure to stop?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close bottom sheet
                          },
                          child: const Text('Resume'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Close bottom sheet
                            if (widget.fromResultPage) {
                              Navigator.of(
                                context,
                              ).popUntil((route) => route.isFirst);
                            } else {
                              Navigator.pop(context); // Close PlayPage
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Stop'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
    ).then((_) {
      // Resume the text when bottom sheet is closed
      if (mounted) {
        setState(() {
          _isPaused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showCloseExploreBottomSheet();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate actual font size as a percentage of screen height
            // widget.fontSize is stored as 0-100 (percentage)
            final double actualFontSize =
                constraints.maxHeight * (widget.fontSize / 100);

            return GestureDetector(
              onTap: _toggleControls,
              onLongPressStart: (_) => setState(() => _isPaused = true),
              onLongPressEnd: (_) => setState(() => _isPaused = false),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  // Background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient:
                          widget.backgroundGradientColors != null &&
                                  widget.backgroundImage == null
                              ? LinearGradient(
                                colors: widget.backgroundGradientColors!,
                                transform: GradientRotation(
                                  widget.backgroundGradientRotation *
                                      3.14159 /
                                      180,
                                ),
                              )
                              : null,
                      color:
                          widget.backgroundGradientColors == null &&
                                  widget.backgroundImage == null
                              ? widget.backgroundColor
                              : null,
                      image:
                          widget.backgroundImage != null
                              ? DecorationImage(
                                image: AssetImage(widget.backgroundImage!),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                  ),

                  // Scrolling Text
                  ScrollingTextRenderer(
                    text: widget.text,
                    fontFamily: widget.fontFamily,
                    fontSize: actualFontSize,
                    textColor: widget.textColor,
                    textGradientColors: widget.textGradientColors,
                    textGradientRotation: widget.textGradientRotation,
                    enableStroke: widget.enableStroke,
                    strokeWidth: widget.strokeWidth,
                    strokeColor: widget.strokeColor,
                    strokeGradientColors: widget.strokeGradientColors,
                    strokeGradientRotation: widget.strokeGradientRotation,
                    enableOutline: widget.enableOutline,
                    outlineWidth: widget.outlineWidth,
                    outlineBlur: widget.outlineBlur,
                    outlineColor: widget.outlineColor,
                    outlineGradientColors: widget.outlineGradientColors,
                    outlineGradientRotation: widget.outlineGradientRotation,
                    enableShadow: widget.enableShadow,
                    shadowOffsetX: widget.shadowOffsetX,
                    shadowOffsetY: widget.shadowOffsetY,
                    shadowBlur: widget.shadowBlur,
                    shadowColor: widget.shadowColor,
                    scrollDirection: widget.scrollDirection,
                    scrollSpeed: widget.scrollSpeed,
                    isPaused: _isPaused,
                  ),

                  // Frame Overlay
                  if (widget.enableFrame && widget.frameImage != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Image.asset(
                          widget.frameImage!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                  // Controls Overlay
                  AnimatedOpacity(
                    opacity: _controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        // Close Button (Top LEFT) - Only if NOT locked
                        if (!_isLocked)
                          Positioned(
                            top: 20,
                            left: 20,
                            child: SafeArea(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: _showCloseExploreBottomSheet,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.black54,
                                ),
                              ),
                            ),
                          ),

                        // Lock/Unlock Button (Top RIGHT)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: SafeArea(
                            child: IconButton(
                              icon: Icon(
                                _isLocked ? Icons.lock : Icons.lock_open,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: _toggleLock,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ),
                        ),

                        // Brightness Slider (Bottom) - Only if NOT locked
                        if (!_isLocked)
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: SafeArea(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.brightness_low,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    Expanded(
                                      child: Slider(
                                        value: _brightness,
                                        onChanged: _setBrightness,
                                        activeColor: Colors.white,
                                        inactiveColor: Colors.white38,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.brightness_high,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
