import 'package:flutter/material.dart';
import 'scrolling_text_renderer.dart';

class SettingsPanel extends StatelessWidget {
  final String text;
  final ValueChanged<String> onTextChanged;
  final String fontFamily;
  final ValueChanged<String> onFontFamilyChanged;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;

  final bool enableStroke;
  final ValueChanged<bool> onEnableStrokeChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final Color strokeColor;
  final ValueChanged<Color> onStrokeColorChanged;

  final bool enableOutline;
  final ValueChanged<bool> onEnableOutlineChanged;
  final double outlineWidth;
  final ValueChanged<double> onOutlineWidthChanged;
  final double outlineBlur;
  final ValueChanged<double> onOutlineBlurChanged;
  final Color outlineColor;
  final ValueChanged<Color> onOutlineColorChanged;

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

  final ScrollDirection scrollDirection;
  final ValueChanged<ScrollDirection> onScrollDirectionChanged;
  final double scrollSpeed;
  final ValueChanged<double> onScrollSpeedChanged;

  final Color backgroundColor;
  final ValueChanged<Color> onBackgroundColorChanged;
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
    required this.enableStroke,
    required this.onEnableStrokeChanged,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.strokeColor,
    required this.onStrokeColorChanged,
    required this.enableOutline,
    required this.onEnableOutlineChanged,
    required this.outlineWidth,
    required this.onOutlineWidthChanged,
    required this.outlineBlur,
    required this.onOutlineBlurChanged,
    required this.outlineColor,
    required this.onOutlineColorChanged,
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
            DropdownMenuItem(value: 'NeonClub', child: Text('NeonClub')),
          ],
          onChanged: (v) => onFontFamilyChanged(v!),
        ),

        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: fontSize,
          min: 10,
          max: 200,
          onChanged: onFontSizeChanged,
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
                assetPath: 'assets/frames/frame_1.png',
                isSelected: frameImage == 'assets/frames/frame_1.png',
                onTap: () => onFrameImageChanged('assets/frames/frame_1.png'),
              ),
              _ImageOption(
                assetPath: 'assets/frames/frame_2.png',
                isSelected: frameImage == 'assets/frames/frame_2.png',
                onTap: () => onFrameImageChanged('assets/frames/frame_2.png'),
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

  const _ColorPicker({
    required this.selectedColor,
    required this.onColorChanged,
  });

  final List<Color> colors = const [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
    Colors.lime,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          colors.map((color) {
            return GestureDetector(
              onTap: () => onColorChanged(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selectedColor == color
                            ? Colors.grey
                            : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.blue, width: 3) : null,
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
