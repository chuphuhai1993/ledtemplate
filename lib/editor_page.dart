import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/app_appbar_widget.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
import 'scrolling_text_renderer.dart';
import 'widgets/color_picker_bottom_sheet.dart';
import 'models/template.dart';
import 'saving_page.dart';

class EditorPage extends StatefulWidget {
  final Template? template;
  final int? templateIndex; // Index in UserData.savedTemplates if editing

  const EditorPage({super.key, this.template, this.templateIndex});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  // State variables
  late String _text;
  late String _fontFamily;
  late double _fontSize;

  // Text color
  late Color _textColor;
  List<Color>? _textGradientColors;
  late double _textGradientRotation;

  // Stroke
  late bool _enableStroke;
  late double _strokeWidth;
  late Color _strokeColor;
  List<Color>? _strokeGradientColors;
  late double _strokeGradientRotation;

  // Outline
  late bool _enableOutline;
  late double _outlineWidth;
  late double _outlineBlur;
  late Color _outlineColor;
  List<Color>? _outlineGradientColors;
  late double _outlineGradientRotation;

  // Shadow
  late bool _enableShadow;
  late double _shadowOffsetX;
  late double _shadowOffsetY;
  late double _shadowBlur;
  late Color _shadowColor;

  // Scroll
  late ScrollDirection _scrollDirection;
  late double _scrollSpeed;

  // Background
  late Color _backgroundColor;
  List<Color>? _backgroundGradientColors;
  late double _backgroundGradientRotation;
  late String? _backgroundImage;

  // Frame
  late bool _enableFrame;
  late String? _frameImage;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    final t = widget.template;
    _text = t?.text ?? 'HELLO WORLD';
    _fontFamily = t?.fontFamily ?? 'Beon';
    _fontSize = (t?.fontSize ?? 30.0).clamp(15.0, 90.0);

    _textColor = t?.textColor ?? Colors.white;
    _textGradientColors = t?.textGradientColors;
    _textGradientRotation = t?.textGradientRotation ?? 0;

    _enableStroke = t?.enableStroke ?? false;
    _strokeWidth = t?.strokeWidth ?? 2.0;
    _strokeColor = t?.strokeColor ?? Colors.red;
    _strokeGradientColors = t?.strokeGradientColors;
    _strokeGradientRotation = t?.strokeGradientRotation ?? 0;

    _enableOutline = t?.enableOutline ?? true;
    _outlineWidth = t?.outlineWidth ?? 0.0;
    _outlineBlur = t?.outlineBlur ?? 10.0;
    _outlineColor = t?.outlineColor ?? Colors.blue;
    _outlineGradientColors = t?.outlineGradientColors;
    _outlineGradientRotation = t?.outlineGradientRotation ?? 0;

    _enableShadow = t?.enableShadow ?? false;
    _shadowOffsetX = t?.shadowOffsetX ?? 2.0;
    _shadowOffsetY = t?.shadowOffsetY ?? 2.0;
    _shadowBlur = t?.shadowBlur ?? 3.0;
    _shadowColor = t?.shadowColor ?? Colors.black;

    _scrollDirection = t?.scrollDirection ?? ScrollDirection.rightToLeft;
    _scrollSpeed = t?.scrollSpeed ?? 100.0;

    _backgroundColor = t?.backgroundColor ?? Colors.black;
    _backgroundGradientColors = t?.backgroundGradientColors;
    _backgroundGradientRotation = t?.backgroundGradientRotation ?? 0;
    _backgroundImage = t?.backgroundImage;

    _enableFrame = t?.enableFrame ?? false;
    _frameImage = t?.frameImage ?? 'assets/frames/frame_1.png';
  }

  void _showConfirmBackBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Discard template?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      _saveTemplate();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Template'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Discard Template'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showOverwriteBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Overwrite?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      _saveAsNewTemplate();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create New'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close bottom sheet
                      _overwriteTemplate();
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Overwrite'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _saveTemplate() {
    // Check if we're editing an existing template from My Templates
    if (widget.templateIndex != null) {
      _showOverwriteBottomSheet();
    } else {
      _saveAsNewTemplate();
    }
  }

  void _saveAsNewTemplate() {
    final currentTemplate = Template(
      text: _text,
      fontFamily: _fontFamily,
      fontSize: _fontSize,
      textColor: _textColor,
      textGradientColors: _textGradientColors,
      textGradientRotation: _textGradientRotation,
      enableStroke: _enableStroke,
      strokeWidth: _strokeWidth,
      strokeColor: _strokeColor,
      strokeGradientColors: _strokeGradientColors,
      strokeGradientRotation: _strokeGradientRotation,
      enableOutline: _enableOutline,
      outlineWidth: _outlineWidth,
      outlineBlur: _outlineBlur,
      outlineColor: _outlineColor,
      outlineGradientColors: _outlineGradientColors,
      outlineGradientRotation: _outlineGradientRotation,
      enableShadow: _enableShadow,
      shadowOffsetX: _shadowOffsetX,
      shadowOffsetY: _shadowOffsetY,
      shadowBlur: _shadowBlur,
      shadowColor: _shadowColor,
      scrollDirection: _scrollDirection,
      scrollSpeed: _scrollSpeed,
      backgroundColor: _backgroundColor,
      backgroundGradientColors: _backgroundGradientColors,
      backgroundGradientRotation: _backgroundGradientRotation,
      backgroundImage: _backgroundImage,
      enableFrame: _enableFrame,
      frameImage: _frameImage,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => SavingPage(template: currentTemplate),
      ),
    );
  }

  void _overwriteTemplate() async {
    if (widget.templateIndex != null) {
      final currentTemplate = Template(
        text: _text,
        fontFamily: _fontFamily,
        fontSize: _fontSize,
        textColor: _textColor,
        textGradientColors: _textGradientColors,
        textGradientRotation: _textGradientRotation,
        enableStroke: _enableStroke,
        strokeWidth: _strokeWidth,
        strokeColor: _strokeColor,
        strokeGradientColors: _strokeGradientColors,
        strokeGradientRotation: _strokeGradientRotation,
        enableOutline: _enableOutline,
        outlineWidth: _outlineWidth,
        outlineBlur: _outlineBlur,
        outlineColor: _outlineColor,
        outlineGradientColors: _outlineGradientColors,
        outlineGradientRotation: _outlineGradientRotation,
        enableShadow: _enableShadow,
        shadowOffsetX: _shadowOffsetX,
        shadowOffsetY: _shadowOffsetY,
        shadowBlur: _shadowBlur,
        shadowColor: _shadowColor,
        scrollDirection: _scrollDirection,
        scrollSpeed: _scrollSpeed,
        backgroundColor: _backgroundColor,
        backgroundGradientColors: _backgroundGradientColors,
        backgroundGradientRotation: _backgroundGradientRotation,
        backgroundImage: _backgroundImage,
        enableFrame: _enableFrame,
        frameImage: _frameImage,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => SavingPage(
                template: currentTemplate,
                templateIndex: widget.templateIndex,
              ),
        ),
      );
    } else {
      _saveAsNewTemplate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showConfirmBackBottomSheet();
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        appBar: AppAppBarWidget(
          actions: [
            TextButton.icon(
              onPressed: _saveTemplate,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple, // Or appropriate color
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Preview Area
            PreviewWidget(
              showPhoneFrame: true,
              template: Template(
                text: _text,
                fontFamily: _fontFamily,
                fontSize: _fontSize,
                enableStroke: _enableStroke,
                strokeWidth: _strokeWidth,
                strokeColor: _strokeColor,
                strokeGradientColors: _strokeGradientColors,
                strokeGradientRotation: _strokeGradientRotation,
                enableOutline: _enableOutline,
                outlineWidth: _outlineWidth,
                outlineBlur: _outlineBlur,
                outlineColor: _outlineColor,
                outlineGradientColors: _outlineGradientColors,
                outlineGradientRotation: _outlineGradientRotation,
                enableShadow: _enableShadow,
                shadowOffsetX: _shadowOffsetX,
                shadowOffsetY: _shadowOffsetY,
                shadowBlur: _shadowBlur,
                shadowColor: _shadowColor,
                scrollDirection: _scrollDirection,
                scrollSpeed: _scrollSpeed,
                backgroundColor: _backgroundColor,
                backgroundGradientColors: _backgroundGradientColors,
                backgroundGradientRotation: _backgroundGradientRotation,
                backgroundImage: _backgroundImage,
                enableFrame: _enableFrame,
                frameImage: _frameImage,
                textColor: _textColor,
                textGradientColors: _textGradientColors,
                textGradientRotation: _textGradientRotation,
              ),
              text: _text,
            ),

            // Settings Area with Tabs
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: const [
                        Tab(text: 'Effect'),
                        Tab(text: 'Text'),
                        Tab(text: 'Backdrop'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Effect Tab
                          _EffectSettingsPanel(
                            scrollDirection: _scrollDirection,
                            onScrollDirectionChanged:
                                (v) => setState(() => _scrollDirection = v),
                            scrollSpeed: _scrollSpeed,
                            onScrollSpeedChanged:
                                (v) => setState(() => _scrollSpeed = v),
                          ),
                          // Text Tab
                          _TextSettingsPanel(
                            text: _text,
                            onTextChanged: (v) => setState(() => _text = v),
                            fontFamily: _fontFamily,
                            onFontFamilyChanged:
                                (v) => setState(() => _fontFamily = v),
                            fontSize: _fontSize,
                            onFontSizeChanged:
                                (v) => setState(() => _fontSize = v),
                            textColor: _textColor,
                            onTextColorChanged:
                                (v) => setState(() => _textColor = v),
                            textGradientColors: _textGradientColors,
                            textGradientRotation: _textGradientRotation,
                            onTextGradientChanged:
                                (colors, rotation) => setState(() {
                                  _textGradientColors = colors;
                                  _textGradientRotation = rotation;
                                }),
                            enableStroke: _enableStroke,
                            onEnableStrokeChanged:
                                (v) => setState(() => _enableStroke = v),
                            strokeWidth: _strokeWidth,
                            onStrokeWidthChanged:
                                (v) => setState(() => _strokeWidth = v),
                            strokeColor: _strokeColor,
                            onStrokeColorChanged:
                                (v) => setState(() => _strokeColor = v),
                            strokeGradientColors: _strokeGradientColors,
                            strokeGradientRotation: _strokeGradientRotation,
                            onStrokeGradientChanged:
                                (colors, rotation) => setState(() {
                                  _strokeGradientColors = colors;
                                  _strokeGradientRotation = rotation;
                                }),
                            enableOutline: _enableOutline,
                            onEnableOutlineChanged:
                                (v) => setState(() => _enableOutline = v),
                            outlineWidth: _outlineWidth,
                            onOutlineWidthChanged:
                                (v) => setState(() => _outlineWidth = v),
                            outlineBlur: _outlineBlur,
                            onOutlineBlurChanged:
                                (v) => setState(() => _outlineBlur = v),
                            outlineColor: _outlineColor,
                            onOutlineColorChanged:
                                (v) => setState(() => _outlineColor = v),
                            outlineGradientColors: _outlineGradientColors,
                            outlineGradientRotation: _outlineGradientRotation,
                            onOutlineGradientChanged:
                                (colors, rotation) => setState(() {
                                  _outlineGradientColors = colors;
                                  _outlineGradientRotation = rotation;
                                }),
                            enableShadow: _enableShadow,
                            onEnableShadowChanged:
                                (v) => setState(() => _enableShadow = v),
                            shadowOffsetX: _shadowOffsetX,
                            onShadowOffsetXChanged:
                                (v) => setState(() => _shadowOffsetX = v),
                            shadowOffsetY: _shadowOffsetY,
                            onShadowOffsetYChanged:
                                (v) => setState(() => _shadowOffsetY = v),
                            shadowBlur: _shadowBlur,
                            onShadowBlurChanged:
                                (v) => setState(() => _shadowBlur = v),
                            shadowColor: _shadowColor,
                            onShadowColorChanged:
                                (v) => setState(() => _shadowColor = v),
                          ),
                          // Backdrop Tab
                          _BackdropSettingsPanel(
                            backgroundColor: _backgroundColor,
                            onBackgroundColorChanged:
                                (v) => setState(() => _backgroundColor = v),
                            backgroundGradientColors: _backgroundGradientColors,
                            backgroundGradientRotation:
                                _backgroundGradientRotation,
                            onBackgroundGradientChanged:
                                (colors, rotation) => setState(() {
                                  _backgroundGradientColors = colors;
                                  _backgroundGradientRotation = rotation;
                                }),
                            backgroundImage: _backgroundImage,
                            onBackgroundImageChanged:
                                (v) => setState(() => _backgroundImage = v),
                            enableFrame: _enableFrame,
                            onEnableFrameChanged:
                                (v) => setState(() => _enableFrame = v),
                            frameImage: _frameImage,
                            onFrameImageChanged:
                                (v) => setState(() => _frameImage = v),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Effect Settings Panel
class _EffectSettingsPanel extends StatelessWidget {
  final ScrollDirection scrollDirection;
  final ValueChanged<ScrollDirection> onScrollDirectionChanged;
  final double scrollSpeed;
  final ValueChanged<double> onScrollSpeedChanged;

  const _EffectSettingsPanel({
    required this.scrollDirection,
    required this.onScrollDirectionChanged,
    required this.scrollSpeed,
    required this.onScrollSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
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
        const SizedBox(height: 16),
        const Text(
          'Scroll Speed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Slider(
          value: scrollSpeed,
          min: 0,
          max: 500,
          onChanged: onScrollSpeedChanged,
        ),
      ],
    );
  }
}

// Text Settings Panel
class _TextSettingsPanel extends StatelessWidget {
  final String text;
  final ValueChanged<String> onTextChanged;
  final String fontFamily;
  final ValueChanged<String> onFontFamilyChanged;
  final double fontSize;
  final ValueChanged<double> onFontSizeChanged;
  final Color textColor;
  final ValueChanged<Color> onTextColorChanged;
  final List<Color>? textGradientColors;
  final double textGradientRotation;
  final Function(List<Color>?, double) onTextGradientChanged;
  final bool enableStroke;
  final ValueChanged<bool> onEnableStrokeChanged;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final Color strokeColor;
  final ValueChanged<Color> onStrokeColorChanged;
  final List<Color>? strokeGradientColors;
  final double strokeGradientRotation;
  final Function(List<Color>?, double) onStrokeGradientChanged;
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

  const _TextSettingsPanel({
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
          decoration: const InputDecoration(hintText: 'Enter text here'),
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
            DropdownMenuItem(value: 'Mohaw', child: Text('Mohaw')),
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
        const SizedBox(height: 50),
      ],
    );
  }
}

// Backdrop Settings Panel
class _BackdropSettingsPanel extends StatelessWidget {
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

  const _BackdropSettingsPanel({
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

// Helper widget: Color Picker
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
                if (onGradientChanged != null) {
                  onGradientChanged!(
                    result.gradientColors,
                    result.gradientRotation,
                  );
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

// Helper widget: Image Option
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
