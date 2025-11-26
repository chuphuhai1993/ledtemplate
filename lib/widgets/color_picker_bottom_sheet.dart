import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ledtemplate/widgets/neon_button.dart';
import 'app_switch_widget.dart';

/// Result from color picker
class ColorPickerResult {
  final bool isGradient;
  final Color? solidColor;
  final List<Color>? gradientColors;
  final double gradientRotation; // 0-360 degrees

  ColorPickerResult({
    required this.isGradient,
    this.solidColor,
    this.gradientColors,
    this.gradientRotation = 0,
  });

  // Helper to get a single color for backward compatibility
  Color get primaryColor =>
      solidColor ?? (gradientColors?.first ?? Colors.white);
}

class ColorPickerBottomSheet extends StatefulWidget {
  final ColorPickerResult initialValue;
  final String title;

  const ColorPickerBottomSheet({
    super.key,
    required this.initialValue,
    this.title = 'Pick Color',
  });

  @override
  State<ColorPickerBottomSheet> createState() => _ColorPickerBottomSheetState();
}

class _ColorPickerBottomSheetState extends State<ColorPickerBottomSheet> {
  late bool _isGradient;
  late HSVColor _currentHSV;
  late List<Color> _gradientColors;
  late double _gradientRotation;
  int _activeChipIndex = 0; // Track which chip is being edited

  @override
  void initState() {
    super.initState();
    _isGradient = widget.initialValue.isGradient;

    _gradientColors = List.from(
      widget.initialValue.gradientColors ??
          [Colors.yellow, Colors.green, Colors.purple],
    );
    _gradientRotation = widget.initialValue.gradientRotation;

    // Initialize color from first gradient chip if in gradient mode, otherwise use solid color
    final initialColor =
        _isGradient
            ? _gradientColors.first
            : (widget.initialValue.solidColor ?? Colors.red);

    // Convert to HSV and ensure saturation and value are not 0
    // (otherwise hue slider won't have any visible effect)
    final hsv = HSVColor.fromColor(initialColor);
    _currentHSV = HSVColor.fromAHSV(
      1.0,
      hsv.hue,
      hsv.saturation == 0 ? 1.0 : hsv.saturation, // Ensure saturation > 0
      hsv.value == 0 ? 1.0 : hsv.value, // Ensure value > 0
    );
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _updateColorFromPosition(Offset position) {
    const boxSize = 320.0;

    // Calculate saturation (0 to 1 from left to right)
    final saturation = (position.dx / boxSize).clamp(0.0, 1.0);

    // Calculate value (1 to 0 from top to bottom)
    final value = (1.0 - (position.dy / boxSize)).clamp(0.0, 1.0);

    setState(() {
      _currentHSV = HSVColor.fromAHSV(1.0, _currentHSV.hue, saturation, value);

      // Update the active gradient chip color
      if (_isGradient && _activeChipIndex < _gradientColors.length) {
        _gradientColors[_activeChipIndex] = _currentHSV.toColor();
      }
    });
  }

  void _addGradientColor() {
    if (_gradientColors.length < 4) {
      setState(() {
        _gradientColors.add(_currentHSV.toColor());
      });
    }
  }

  void _removeGradientColor(int index) {
    if (_gradientColors.length > 2) {
      setState(() {
        _gradientColors.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                NeonButton(
                  onPressed: () {
                    final result = ColorPickerResult(
                      isGradient: _isGradient,
                      solidColor: _isGradient ? null : _currentHSV.toColor(),
                      gradientColors: _isGradient ? _gradientColors : null,
                      gradientRotation: _gradientRotation,
                    );
                    Navigator.pop(context, result);
                  },
                  type: NeonButtonType.tertiary,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Color Picker Box with Preview Overlay
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Color Picker Box
                        GestureDetector(
                          onPanDown:
                              (details) => _updateColorFromPosition(
                                details.localPosition,
                              ),
                          onPanUpdate:
                              (details) => _updateColorFromPosition(
                                details.localPosition,
                              ),
                          child: Container(
                            width: 360,
                            height: 360,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  HSVColor.fromAHSV(
                                    1.0,
                                    _currentHSV.hue,
                                    1.0,
                                    1.0,
                                  ).toColor(),
                                ],
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Preview Box Overlay (Full Coverage)
                        IgnorePointer(
                          child: Container(
                            width: 360,
                            height: 360,
                            decoration: BoxDecoration(
                              color: _currentHSV.toColor(),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Hue Slider (Rainbow Gradient)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0000), // Red
                            Color(0xFFFFFF00), // Yellow
                            Color(0xFF00FF00), // Green
                            Color(0xFF00FFFF), // Cyan
                            Color(0xFF0000FF), // Blue
                            Color(0xFFFF00FF), // Magenta
                            Color(0xFFFF0000), // Red (loop)
                          ],
                        ),
                      ),
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 40,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 16,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 24,
                          ),
                          thumbColor: Colors.white,
                          overlayColor: Colors.white.withOpacity(0.3),
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                        ),
                        child: Slider(
                          value: _currentHSV.hue,
                          min: 0,
                          max: 360,
                          onChanged: (value) {
                            setState(() {
                              _currentHSV = _currentHSV.withHue(value);

                              // Update the active gradient chip color
                              if (_isGradient &&
                                  _activeChipIndex < _gradientColors.length) {
                                _gradientColors[_activeChipIndex] =
                                    _currentHSV.toColor();
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Gradient Toggle
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Gradient',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 18,
                                child:
                                    _isGradient
                                        ? Text(
                                          'Long press to remove',
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 12,
                                          ),
                                        )
                                        : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                        AppSwitchWidget(
                          value: _isGradient,
                          onChanged: (value) {
                            setState(() {
                              _isGradient = value;
                              if (value && _gradientColors.isEmpty) {
                                _gradientColors = [
                                  Colors.yellow,
                                  Colors.green,
                                  Colors.purple,
                                ];
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Gradient Color Chips (Always show, but limit based on gradient mode)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        const SizedBox(width: 16),
                        // Show first chip always, rest only if gradient is enabled
                        ...(_isGradient
                                ? _gradientColors
                                : [_currentHSV.toColor()])
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final color =
                                  _isGradient
                                      ? entry.value
                                      : _currentHSV.toColor();
                              final isActive = index == _activeChipIndex;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _activeChipIndex = index;
                                    _currentHSV = HSVColor.fromColor(color);
                                  });
                                },
                                onLongPress: () {
                                  if (_isGradient &&
                                      _gradientColors.length > 2) {
                                    _removeGradientColor(index);
                                    if (_activeChipIndex >=
                                        _gradientColors.length) {
                                      _activeChipIndex =
                                          _gradientColors.length - 1;
                                    }
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2C2C2E),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isActive
                                              ? Theme.of(
                                                context,
                                              ).colorScheme.onSurface
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _colorToHex(color),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList(),
                        if (_isGradient && _gradientColors.length < 4)
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            ),
                            onPressed: _addGradientColor,
                          ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
