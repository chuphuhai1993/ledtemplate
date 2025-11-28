import 'package:flutter/material.dart';
import 'scrolling_text_renderer.dart';
import 'widgets/color_picker_bottom_sheet.dart';

class SettingsPanel extends StatelessWidget {
  final String text;
  final ValueChanged<String> onTextChanged;
  final String fontFamily;
  final ValueChanged<String> onFontFamilyChanged;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  // Text Color
  final Color textColor;
  final ValueChanged<Color> onTextColorChanged;
  final List<Color>? textGradientColors;
  final double textGradientRotation;
  final Function(List<Color>?, double) onTextGradientChanged;

  // Stroke
  final bool enableStroke;
  final ValueChanged<bool> onEnableStrokeChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final Color strokeColor;
  final ValueChanged<Color> onStrokeColorChanged;
  final List<Color>? strokeGradientColors;
  final double strokeGradientRotation;
  final Function(List<Color>?, double) onStrokeGradientChanged;

  // Outline
  final bool enableOutline;
  final ValueChanged<bool> onEnableOutlineChanged;
  final double outlineWidth;
  final ValueChanged<double> onOutlineWidthChanged;
  final double outlineBlur;
  final ValueChanged<double> onOutlineBlurChanged;
  final Color outlineColor;
  final ValueChanged<Color> onOutlineColorChanged;
  final List<Color>? outlineGradientColors;
  final double outlineGradientRotation;
  final Function(List<Color>?, double) onOutlineGradientChanged;

  // Shadow (Solid only for simplicity)
  final bool enableShadow;
  final ValueChanged<bool> onEnableShadowChanged;
  final double shadowOffsetX;
  final ValueChanged<double> onShadowOffsetXChanged;
  final double shadowOffsetY;
  final ValueChanged<double> onShadowOffsetYChanged;
  final double shadowBlur;
  final ValueChanged<double> onShadowBlurChanged;
  final Color shadowColor;
  final ValueChanged<Color> onShadowColorChanged;

  // Scroll
  final ScrollDirection scrollDirection;
  final ValueChanged<ScrollDirection> onScrollDirectionChanged;
  final double scrollSpeed;
  final ValueChanged<double> onScrollSpeedChanged;

  // Background
  final Color backgroundColor;
  final ValueChanged<Color> onBackgroundColorChanged;
  final List<Color>? backgroundGradientColors;
  final double backgroundGradientRotation;
  final Function(List<Color>?, double) onBackgroundGradientChanged;

  final String? backgroundImage;
  final ValueChanged<String?> onBackgroundImageChanged;

  final bool enableFrame;
  final ValueChanged<bool> onEnableFrameChanged;
  final String? frameImage;
  final ValueChanged<String?> onFrameImageChanged;

  const SettingsPanel({
    super.key,
    required this.text,
    required this.onTextChanged,
    required this.fontFamily,
    required this.onFontFamilyChanged,
    required this.fontSize,
    required this.onFontSizeChanged,

    required this.textColor,
    required this.onTextColorChanged,
    this.textGradientColors,
    this.textGradientRotation = 0,
    required this.onTextGradientChanged,

    required this.enableStroke,
    required this.onEnableStrokeChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.strokeColor,
    required this.onStrokeColorChanged,
    this.strokeGradientColors,
    this.strokeGradientRotation = 0,
    required this.onStrokeGradientChanged,

    required this.enableOutline,
    required this.onEnableOutlineChanged,
    required this.outlineWidth,
    required this.onOutlineWidthChanged,
    required this.outlineBlur,
    required this.onOutlineBlurChanged,
    required this.outlineColor,
    required this.onOutlineColorChanged,
    this.outlineGradientColors,
    this.outlineGradientRotation = 0,
    required this.onOutlineGradientChanged,

    required this.enableShadow,
    required this.onEnableShadowChanged,
    required this.shadowOffsetX,
    required this.onShadowOffsetXChanged,
    required this.shadowOffsetY,
    required this.onShadowOffsetYChanged,
    required this.shadowBlur,
    required this.onShadowBlurChanged,
    required this.shadowColor,
    required this.onShadowColorChanged,

    required this.scrollDirection,
    required this.onScrollDirectionChanged,
    required this.scrollSpeed,
    required this.onScrollSpeedChanged,

    required this.backgroundColor,
    required this.onBackgroundColorChanged,
    this.backgroundGradientColors,
    this.backgroundGradientRotation = 0,
    required this.onBackgroundGradientChanged,

    required this.backgroundImage,
    required this.onBackgroundImageChanged,
    required this.enableFrame,
    required this.onEnableFrameChanged,
    required this.frameImage,
    required this.onFrameImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: TextEditingController(text: text)
            ..selection = TextSelection.collapsed(offset: text.length),
          onChanged: onTextChanged,
          decoration: const InputDecoration(
            hintText: 'Enter text here',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Font', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: fontFamily,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'Roboto', child: Text('Default (Roboto)')),
            DropdownMenuItem(value: 'Beon', child: Text('Beon')),
            DropdownMenuItem(value: 'Amaline', child: Text('Amaline')),
            DropdownMenuItem(
              value: 'BetterOutline',
              child: Text('Better Outline'),
            ),
            DropdownMenuItem(value: 'Crosseline', child: Text('Crosseline')),
            DropdownMenuItem(value: 'Glowtone', child: Text('Glowtone')),
            DropdownMenuItem(value: 'Honeyline', child: Text('Honeyline')),
            DropdownMenuItem(value: 'Klaxons', child: Text('Klaxons')),
            DropdownMenuItem(value: 'NeonBines', child: Text('Neon Bines')),
            DropdownMenuItem(value: 'NeonBlitz', child: Text('Neon Blitz')),
            DropdownMenuItem(value: 'NeonDerthaw', child: Text('Neon Derthaw')),
            DropdownMenuItem(value: 'NeonLight', child: Text('Neon Light')),
            DropdownMenuItem(value: 'NeonSans', child: Text('Neon Sans')),
            DropdownMenuItem(value: 'Rookworst', child: Text('Rookworst')),
            DropdownMenuItem(value: 'Ryga', child: Text('Ryga')),
            DropdownMenuItem(value: 'SunsetClub', child: Text('Sunset Club')),
            DropdownMenuItem(value: 'Wednesline', child: Text('Wednesline')),
            DropdownMenuItem(
              value: 'WonderfulAustralia',
              child: Text('Wonderful Australia'),
            ),
            DropdownMenuItem(value: 'TenPixel', child: Text('10 Pixel')),
            DropdownMenuItem(value: 'AlbertSans', child: Text('Albert Sans')),
            DropdownMenuItem(value: 'DynaPuff', child: Text('Dyna Puff')),
            DropdownMenuItem(value: 'Creepster', child: Text('Creepster')),
            DropdownMenuItem(value: 'Mali', child: Text('Mali')),
            DropdownMenuItem(value: 'Pacifico', child: Text('Pacifico')),
            DropdownMenuItem(value: 'PlaypenSans', child: Text('Playpen Sans')),
          ],
          onChanged: (v) => onFontFamilyChanged(v!),
        ),

        Text(
          'Font Size: ${fontSize.toStringAsFixed(0)}%',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(value: fontSize, min: 15, max: 90, onChanged: onFontSizeChanged),

        const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
        _ColorPicker(
          selectedColor: textColor,
          onColorChanged: onTextColorChanged,
          gradientColors: textGradientColors,
          gradientRotation: textGradientRotation,
          onGradientChanged: onTextGradientChanged,
          label: 'Text Color',
        ),

        const Divider(),
        SwitchListTile(
          title: const Text('Enable Stroke'),
          value: enableStroke,
          onChanged: onEnableStrokeChanged,
        ),
        if (enableStroke) ...[
          Text('Stroke Width: ${strokeWidth.toStringAsFixed(1)}'),
          Slider(
            value: strokeWidth,
            min: 0,
            max: 50,
            onChanged: onStrokeWidthChanged,
          ),
          const Text('Stroke Color'),
          _ColorPicker(
            selectedColor: strokeColor,
            onColorChanged: onStrokeColorChanged,
            gradientColors: strokeGradientColors,
            gradientRotation: strokeGradientRotation,
            onGradientChanged: onStrokeGradientChanged,
            label: 'Stroke Color',
          ),
        ],

        const Divider(),
        SwitchListTile(
          title: const Text('Enable Outline (Glow)'),
          value: enableOutline,
          onChanged: onEnableOutlineChanged,
        ),
        if (enableOutline) ...[
          Text('Outline Size: ${outlineWidth.toStringAsFixed(1)}'),
          Slider(
            value: outlineWidth,
            min: 0,
            max: 50,
            onChanged: onOutlineWidthChanged,
          ),
          Text('Outline Blur: ${outlineBlur.toStringAsFixed(1)}'),
          Slider(
            value: outlineBlur,
            min: 0,
            max: 50,
            onChanged: onOutlineBlurChanged,
          ),
          const Text('Outline Color'),
          _ColorPicker(
            selectedColor: outlineColor,
            onColorChanged: onOutlineColorChanged,
            gradientColors: outlineGradientColors,
            gradientRotation: outlineGradientRotation,
            onGradientChanged: onOutlineGradientChanged,
            label: 'Outline Color',
          ),
        ],

        const Divider(),
        SwitchListTile(
          title: const Text('Enable Shadow'),
          value: enableShadow,
          onChanged: onEnableShadowChanged,
        ),
        if (enableShadow) ...[
          Text('Shadow Offset X: ${shadowOffsetX.toStringAsFixed(1)}'),
          Slider(
            value: shadowOffsetX,
            min: -20,
            max: 20,
            onChanged: onShadowOffsetXChanged,
          ),
          Text('Shadow Offset Y: ${shadowOffsetY.toStringAsFixed(1)}'),
          Slider(
            value: shadowOffsetY,
            min: -20,
            max: 20,
            onChanged: onShadowOffsetYChanged,
          ),
          Text('Shadow Blur: ${shadowBlur.toStringAsFixed(1)}'),
          Slider(
            value: shadowBlur,
            min: 0,
            max: 40,
            onChanged: onShadowBlurChanged,
          ),
          const Text('Shadow Color'),
          _ColorPicker(
            selectedColor: shadowColor,
            onColorChanged: onShadowColorChanged,
            label: 'Shadow Color',
          ),
        ],

        const Divider(),
        const Text(
          'Scroll Direction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButton<ScrollDirection>(
          value: scrollDirection,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: ScrollDirection.rightToLeft,
              child: Text('Right to Left'),
            ),
            DropdownMenuItem(
              value: ScrollDirection.leftToRight,
              child: Text('Left to Right'),
            ),
            DropdownMenuItem(
              value: ScrollDirection.none,
              child: Text('None (Static)'),
            ),
          ],
          onChanged: (v) => onScrollDirectionChanged(v!),
        ),

        const Text('Scroll Speed'),
        Slider(
          value: scrollSpeed,
          min: 0,
          max: 500,
          onChanged: onScrollSpeedChanged,
        ),

        const Divider(),
        const Text('Background', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Color'),
                value: false,
                groupValue: backgroundImage != null,
                onChanged: (v) => onBackgroundImageChanged(null),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('Image'),
                value: true,
                groupValue: backgroundImage != null,
                onChanged:
                    (v) => onBackgroundImageChanged(
                      'assets/backgrounds/background_1.jpg',
                    ),
              ),
            ),
          ],
        ),
        if (backgroundImage == null)
          _ColorPicker(
            selectedColor: backgroundColor,
            onColorChanged: onBackgroundColorChanged,
            gradientColors: backgroundGradientColors,
            gradientRotation: backgroundGradientRotation,
            onGradientChanged: onBackgroundGradientChanged,
            label: 'Background Color',
          )
        else
          Wrap(
            spacing: 8,
            children: [
              _ImageOption(
                assetPath: 'assets/backgrounds/background_1.jpg',
                isSelected:
                    backgroundImage == 'assets/backgrounds/background_1.jpg',
                onTap:
                    () => onBackgroundImageChanged(
                      'assets/backgrounds/background_1.jpg',
                    ),
              ),
              _ImageOption(
                assetPath: 'assets/backgrounds/background_2.jpg',
                isSelected:
                    backgroundImage == 'assets/backgrounds/background_2.jpg',
                onTap:
                    () => onBackgroundImageChanged(
                      'assets/backgrounds/background_2.jpg',
                    ),
              ),
            ],
          ),

        const Divider(),
        SwitchListTile(
          title: const Text('Enable Frame'),
          value: enableFrame,
          onChanged: onEnableFrameChanged,
        ),
        if (enableFrame)
          Wrap(
            spacing: 8,
            children: [
              _ImageOption(
                assetPath: 'assets/frames/frame_1.json',
                isSelected: frameImage == 'assets/frames/frame_1.json',
                onTap: () => onFrameImageChanged('assets/frames/frame_1.json'),
              ),
              _ImageOption(
                assetPath: 'assets/frames/frame_2.json',
                isSelected: frameImage == 'assets/frames/frame_2.json',
                onTap: () => onFrameImageChanged('assets/frames/frame_2.json'),
              ),
            ],
          ),

        const SizedBox(height: 50),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color>? gradientColors;
  final double gradientRotation;
  final Function(List<Color>?, double)? onGradientChanged;
  final String label;

  const _ColorPicker({
    required this.selectedColor,
    required this.onColorChanged,
    this.gradientColors,
    this.gradientRotation = 0,
    this.onGradientChanged,
    this.label = 'Pick Color',
  });

  @override
  Widget build(BuildContext context) {
    final isGradient = gradientColors != null && gradientColors!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton(
          onPressed: () async {
            final result = await showModalBottomSheet<ColorPickerResult>(
              context: context,
              isScrollControlled: true,
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
                // Update gradient
                if (onGradientChanged != null) {
                  onGradientChanged!(
                    result.gradientColors,
                    result.gradientRotation,
                  );
                }
                // Also update solid color to first gradient color for compatibility/preview
                if (result.gradientColors != null &&
                    result.gradientColors!.isNotEmpty) {
                  onColorChanged(result.gradientColors!.first);
                }
              } else {
                // Update solid color
                if (result.solidColor != null) {
                  onColorChanged(result.solidColor!);
                }
                // Clear gradient
                if (onGradientChanged != null) {
                  onGradientChanged!(null, 0);
                }
              }
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isGradient ? null : selectedColor,
                  gradient:
                      isGradient
                          ? LinearGradient(
                            colors: gradientColors!,
                            transform: GradientRotation(
                              gradientRotation * 3.14159 / 180,
                            ),
                          )
                          : null,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ],
    );
  }
}

class _ImageOption extends StatelessWidget {
  final String assetPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _ImageOption({
    required this.assetPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Convert frame path to thumbnail path (frame_1.json -> frame_1.jpg)
    final thumbnailPath = assetPath.replaceAll('.json', '.jpg');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(thumbnailPath, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
