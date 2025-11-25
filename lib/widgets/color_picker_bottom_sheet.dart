import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  late Color _solidColor;
  late List<Color> _gradientColors;
  late double _gradientRotation;
  late TextEditingController _hexController;

  // Predefined color palette
  final List<Color> _paletteColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    // Neon colors
    Color(0xFFFF006E), // Hot pink
    Color(0xFF8338EC), // Purple
    Color(0xFF3A86FF), // Blue
    Color(0xFFFB5607), // Orange
    Color(0xFFFFBE0B), // Yellow
    Color(0xFF06FFA5), // Mint
  ];

  @override
  void initState() {
    super.initState();
    _isGradient = widget.initialValue.isGradient;
    _solidColor = widget.initialValue.solidColor ?? Colors.white;
    _gradientColors = List.from(
      widget.initialValue.gradientColors ?? [Colors.white, Colors.black],
    );
    _gradientRotation = widget.initialValue.gradientRotation;
    _hexController = TextEditingController(
      text: _colorToHex(_isGradient ? _gradientColors[0] : _solidColor),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color? _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      try {
        return Color(int.parse('FF$hex', radix: 16));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  void _updateHexFromColor(Color color) {
    _hexController.text = _colorToHex(color);
  }

  void _onPaletteColorTap(Color color) {
    setState(() {
      if (_isGradient) {
        // Update first gradient color
        _gradientColors[0] = color;
      } else {
        _solidColor = color;
      }
      _updateHexFromColor(color);
    });
  }

  void _onHexChanged(String hex) {
    final color = _hexToColor(hex);
    if (color != null) {
      setState(() {
        if (_isGradient) {
          _gradientColors[0] = color;
        } else {
          _solidColor = color;
        }
      });
    }
  }

  void _addGradientColor() {
    if (_gradientColors.length < 3) {
      setState(() {
        _gradientColors.add(Colors.white);
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

  void _updateGradientColor(int index, Color color) {
    setState(() {
      _gradientColors[index] = color;
      if (index == 0) {
        _updateHexFromColor(color);
      }
    });
  }

  Widget _buildPreview() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        gradient:
            _isGradient
                ? LinearGradient(
                  colors: _gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  transform: GradientRotation(
                    _gradientRotation * 3.14159 / 180,
                  ),
                )
                : null,
        color: _isGradient ? null : _solidColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preview
            _buildPreview(),
            const SizedBox(height: 16),

            // Gradient Toggle
            SwitchListTile(
              title: const Text('Gradient Mode'),
              value: _isGradient,
              onChanged: (value) {
                setState(() {
                  _isGradient = value;
                  if (value && _gradientColors.length < 2) {
                    _gradientColors = [_solidColor, Colors.black];
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Gradient Controls
            if (_isGradient) ...[
              const Text(
                'Gradient Colors',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._gradientColors.asMap().entries.map((entry) {
                final index = entry.key;
                final color = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Show palette for this gradient color
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Color ${index + 1}'),
                                  content: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        _paletteColors.map((c) {
                                          return GestureDetector(
                                            onTap: () {
                                              _updateGradientColor(index, c);
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: c,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text('Color ${index + 1}')),
                      if (_gradientColors.length > 2)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => _removeGradientColor(index),
                        ),
                    ],
                  ),
                );
              }).toList(),
              if (_gradientColors.length < 3)
                OutlinedButton.icon(
                  onPressed: _addGradientColor,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Color'),
                ),
              const SizedBox(height: 16),

              // Rotation Slider
              const Text(
                'Gradient Rotation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _gradientRotation,
                      min: 0,
                      max: 360,
                      divisions: 72,
                      label: '${_gradientRotation.toInt()}°',
                      onChanged: (value) {
                        setState(() {
                          _gradientRotation = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text('${_gradientRotation.toInt()}°'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Color Palette
            const Text(
              'Color Palette',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _paletteColors.map((color) {
                    final isSelected = !_isGradient && _solidColor == color;
                    return GestureDetector(
                      onTap: () => _onPaletteColorTap(color),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey,
                            width: isSelected ? 3 : 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),

            // Hex Input
            const Text(
              'Hex Color',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _hexController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '#FFFFFF',
                prefixText: '#',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(6),
              ],
              onChanged: (value) {
                if (value.length == 6) {
                  _onHexChanged('#$value');
                }
              },
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final result = ColorPickerResult(
                        isGradient: _isGradient,
                        solidColor: _isGradient ? null : _solidColor,
                        gradientColors: _isGradient ? _gradientColors : null,
                        gradientRotation: _gradientRotation,
                      );
                      Navigator.pop(context, result);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
