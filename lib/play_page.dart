import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'scrolling_text_renderer.dart';

class PlayPage extends StatefulWidget {
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

  const PlayPage({
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
    required this.backgroundColor,
    required this.backgroundImage,
    required this.enableFrame,
    required this.frameImage,
  });

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool _controlsVisible = true;
  bool _isLocked = false;
  bool _isPaused = false;
  Timer? _hideTimer;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
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
                color:
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
              fontSize: widget.fontSize,
              enableStroke: widget.enableStroke,
              strokeWidth: widget.strokeWidth,
              strokeColor: widget.strokeColor,
              enableOutline: widget.enableOutline,
              outlineWidth: widget.outlineWidth,
              outlineBlur: widget.outlineBlur,
              outlineColor: widget.outlineColor,
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
                  child: Image.asset(widget.frameImage!, fit: BoxFit.fill),
                ),
              ),

            // Controls Overlay
            AnimatedOpacity(
              opacity: _controlsVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                children: [
                  // Close Button (Top Right) - Only if NOT locked
                  if (!_isLocked)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: SafeArea(
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                    ),

                  // Lock/Unlock Button (Bottom Right)
                  Positioned(
                    bottom: 20,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
