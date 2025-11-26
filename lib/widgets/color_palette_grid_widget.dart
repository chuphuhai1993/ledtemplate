import 'package:flutter/material.dart';
import 'color_picker_bottom_sheet.dart';

/// A widget that displays a grid of preset colors and gradients for quick selection
class ColorPaletteGridWidget extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color>? gradientColors;
  final double gradientRotation;
  final Function(List<Color>?, double)? onGradientChanged;
  final String label;

  const ColorPaletteGridWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    this.gradientColors,
    this.gradientRotation = 0,
    this.onGradientChanged,
    this.label = 'Pick Color',
  });

  // Preset solid colors
  static const List<Color> _presetColors = [
    Colors.white,
    Colors.black,
    Color(0xFFFF6B9D), // Pink
    Color(0xFFFFEB3B), // Yellow
    Color(0xFF76FF03), // Lime
    Color(0xFF00E5FF), // Cyan
    Color(0xFFE91E63), // Deep Pink
    Color(0xFF00BFA5), // Teal
    Color(0xFFFF6F00), // Orange
    Color(0xFFAA00FF), // Purple
    Color(0xFFFFC1E3), // Light Pink
    Color(0xFFFFD54F), // Amber
  ];

  // Preset gradients (each is a list of colors)
  static const List<List<Color>> _presetGradients = [
    [Color(0xFFFF006E), Color(0xFF8338EC)], // Pink to Purple
    [Color(0xFF06FFA5), Color(0xFF3A86FF)], // Mint to Blue
    [Color(0xFFFFBE0B), Color(0xFFFB5607)], // Yellow to Orange
    [Color(0xFF8338EC), Color(0xFF3A86FF)], // Purple to Blue
  ];

  void _openColorPicker(BuildContext context) async {
    final isGradient = gradientColors != null && gradientColors!.isNotEmpty;
    final result = await showModalBottomSheet<ColorPickerResult>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ColorPickerBottomSheet(
            initialValue: ColorPickerResult(
              isGradient: isGradient,
              solidColor: selectedColor,
              gradientColors: gradientColors,
              gradientRotation: gradientRotation,
            ),
            title: label,
          ),
    );

    if (result != null) {
      if (result.isGradient) {
        if (onGradientChanged != null) {
          onGradientChanged!(result.gradientColors, result.gradientRotation);
        }
        if (result.gradientColors != null &&
            result.gradientColors!.isNotEmpty) {
          onColorChanged(result.gradientColors!.first);
        }
      } else {
        if (result.solidColor != null) {
          onColorChanged(result.solidColor!);
        }
        if (onGradientChanged != null) {
          onGradientChanged!(null, 0);
        }
      }
    }
  }

  void _selectSolidColor(Color color) {
    onColorChanged(color);
    if (onGradientChanged != null) {
      onGradientChanged!(null, 0);
    }
  }

  void _selectGradient(List<Color> colors) {
    if (onGradientChanged != null) {
      onGradientChanged!(colors, 0);
    }
    onColorChanged(colors.first);
  }

  bool _isSelected(dynamic item) {
    final isGradient = gradientColors != null && gradientColors!.isNotEmpty;

    if (item is Color) {
      return !isGradient && selectedColor == item;
    } else if (item is List<Color>) {
      if (!isGradient) return false;
      if (gradientColors!.length != item.length) return false;
      for (int i = 0; i < item.length; i++) {
        if (gradientColors![i] != item[i]) return false;
      }
      return true;
    }
    return false;
  }

  bool _isCustomColor() {
    final isGradient = gradientColors != null && gradientColors!.isNotEmpty;

    // Check if current color/gradient is in presets
    if (isGradient) {
      // Check if gradient matches any preset gradient
      for (final preset in _presetGradients) {
        if (preset.length == gradientColors!.length) {
          bool matches = true;
          for (int i = 0; i < preset.length; i++) {
            if (preset[i] != gradientColors![i]) {
              matches = false;
              break;
            }
          }
          if (matches) return false;
        }
      }
      return true; // Custom gradient
    } else {
      // Check if solid color matches any preset color
      return !_presetColors.contains(selectedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 16),
          // First item: Color picker icon
          GestureDetector(
            onTap: () => _openColorPicker(context),
            child: Container(
              padding: const EdgeInsets.all(2),
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      _isCustomColor()
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(
                  'assets/images/color_picker.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          // Preset solid colors
          ..._presetColors.map((color) {
            final isSelected = _isSelected(color);
            return GestureDetector(
              onTap: () => _selectSolidColor(color),
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
          // Preset gradients
          ..._presetGradients.map((gradientColors) {
            final isSelected = _isSelected(gradientColors);
            return GestureDetector(
              onTap: () => _selectGradient(gradientColors),
              child: Container(
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
