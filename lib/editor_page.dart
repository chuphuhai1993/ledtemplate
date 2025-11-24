import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
import 'scrolling_text_renderer.dart';
import 'settings_panel.dart';
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

  late bool _enableStroke;
  late double _strokeWidth;
  late Color _strokeColor;

  late bool _enableOutline;
  late double _outlineWidth;
  late double _outlineBlur;
  late Color _outlineColor;

  late bool _enableShadow;
  late double _shadowOffsetX;
  late double _shadowOffsetY;
  late double _shadowBlur;
  late Color _shadowColor;

  late ScrollDirection _scrollDirection;
  late double _scrollSpeed;

  late Color _backgroundColor;
  late String? _backgroundImage;

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

    _enableStroke = t?.enableStroke ?? false;
    _strokeWidth = t?.strokeWidth ?? 2.0;
    _strokeColor = t?.strokeColor ?? Colors.red;

    _enableOutline = t?.enableOutline ?? true;
    _outlineWidth = t?.outlineWidth ?? 0.0;
    _outlineBlur = t?.outlineBlur ?? 10.0;
    _outlineColor = t?.outlineColor ?? Colors.blue;

    _enableShadow = t?.enableShadow ?? false;
    _shadowOffsetX = t?.shadowOffsetX ?? 2.0;
    _shadowOffsetY = t?.shadowOffsetY ?? 2.0;
    _shadowBlur = t?.shadowBlur ?? 3.0;
    _shadowColor = t?.shadowColor ?? Colors.black;

    _scrollDirection = t?.scrollDirection ?? ScrollDirection.rightToLeft;
    _scrollSpeed = t?.scrollSpeed ?? 100.0;

    _backgroundColor = t?.backgroundColor ?? Colors.black;
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
      enableStroke: _enableStroke,
      strokeWidth: _strokeWidth,
      strokeColor: _strokeColor,
      enableOutline: _enableOutline,
      outlineWidth: _outlineWidth,
      outlineBlur: _outlineBlur,
      outlineColor: _outlineColor,
      enableShadow: _enableShadow,
      shadowOffsetX: _shadowOffsetX,
      shadowOffsetY: _shadowOffsetY,
      shadowBlur: _shadowBlur,
      shadowColor: _shadowColor,
      scrollDirection: _scrollDirection,
      scrollSpeed: _scrollSpeed,
      backgroundColor: _backgroundColor,
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
        enableStroke: _enableStroke,
        strokeWidth: _strokeWidth,
        strokeColor: _strokeColor,
        enableOutline: _enableOutline,
        outlineWidth: _outlineWidth,
        outlineBlur: _outlineBlur,
        outlineColor: _outlineColor,
        enableShadow: _enableShadow,
        shadowOffsetX: _shadowOffsetX,
        shadowOffsetY: _shadowOffsetY,
        shadowBlur: _shadowBlur,
        shadowColor: _shadowColor,
        scrollDirection: _scrollDirection,
        scrollSpeed: _scrollSpeed,
        backgroundColor: _backgroundColor,
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
        appBar: AppBar(
          title: const Text('LED Editor'),
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
                enableOutline: _enableOutline,
                outlineWidth: _outlineWidth,
                outlineBlur: _outlineBlur,
                outlineColor: _outlineColor,
                enableShadow: _enableShadow,
                shadowOffsetX: _shadowOffsetX,
                shadowOffsetY: _shadowOffsetY,
                shadowBlur: _shadowBlur,
                shadowColor: _shadowColor,
                scrollDirection: _scrollDirection,
                scrollSpeed: _scrollSpeed,
                backgroundColor: _backgroundColor,
                backgroundImage: _backgroundImage,
                enableFrame: _enableFrame,
                frameImage: _frameImage,
              ),
              text: _text,
            ),

            // Settings Area
            Expanded(
              flex: 6,
              child: Container(
                color: Colors.grey[100],
                child: SettingsPanel(
                  text: _text,
                  onTextChanged: (v) => setState(() => _text = v),
                  fontFamily: _fontFamily,
                  onFontFamilyChanged: (v) => setState(() => _fontFamily = v),
                  fontSize: _fontSize,
                  onFontSizeChanged: (v) => setState(() => _fontSize = v),
                  enableStroke: _enableStroke,
                  onEnableStrokeChanged:
                      (v) => setState(() => _enableStroke = v),
                  strokeWidth: _strokeWidth,
                  onStrokeWidthChanged: (v) => setState(() => _strokeWidth = v),
                  strokeColor: _strokeColor,
                  onStrokeColorChanged: (v) => setState(() => _strokeColor = v),
                  enableOutline: _enableOutline,
                  onEnableOutlineChanged:
                      (v) => setState(() => _enableOutline = v),
                  outlineWidth: _outlineWidth,
                  onOutlineWidthChanged:
                      (v) => setState(() => _outlineWidth = v),
                  outlineBlur: _outlineBlur,
                  onOutlineBlurChanged: (v) => setState(() => _outlineBlur = v),
                  outlineColor: _outlineColor,
                  onOutlineColorChanged:
                      (v) => setState(() => _outlineColor = v),
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
                  onShadowBlurChanged: (v) => setState(() => _shadowBlur = v),
                  shadowColor: _shadowColor,
                  onShadowColorChanged: (v) => setState(() => _shadowColor = v),
                  scrollDirection: _scrollDirection,
                  onScrollDirectionChanged:
                      (v) => setState(() => _scrollDirection = v),
                  scrollSpeed: _scrollSpeed,
                  onScrollSpeedChanged: (v) => setState(() => _scrollSpeed = v),
                  backgroundColor: _backgroundColor,
                  onBackgroundColorChanged:
                      (v) => setState(() => _backgroundColor = v),
                  backgroundImage: _backgroundImage,
                  onBackgroundImageChanged:
                      (v) => setState(() => _backgroundImage = v),
                  enableFrame: _enableFrame,
                  onEnableFrameChanged: (v) => setState(() => _enableFrame = v),
                  frameImage: _frameImage,
                  onFrameImageChanged: (v) => setState(() => _frameImage = v),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
