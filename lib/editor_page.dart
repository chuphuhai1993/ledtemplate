import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/app_appbar_widget.dart';
import 'package:ledtemplate/widgets/app_slider_widget.dart';
import 'package:ledtemplate/widgets/icon_chip_button_widget.dart';
import 'package:ledtemplate/widgets/message_input_bottom_sheet.dart';
import 'package:ledtemplate/widgets/neon_button.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
import 'scrolling_text_renderer.dart';
import 'widgets/app_switch_widget.dart';
import 'widgets/bottom_sheet_container_widget.dart';
import 'widgets/select_button_widget.dart';
import 'widgets/color_palette_grid_widget.dart';
import 'widgets/text_chip_button_widget.dart';
import 'models/template.dart';
import 'saving_page.dart';
import 'widgets/phone_selection_bottom_sheet.dart';
import 'data/user_data.dart';

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
  List<Color>? _shadowGradientColors;
  late double _shadowGradientRotation;

  // Scroll
  late ScrollDirection _scrollDirection;
  late double _scrollSpeed;

  // Blink effect
  late bool _enableBlink;
  late double _blinkDuration;

  // Background
  late Color _backgroundColor;
  List<Color>? _backgroundGradientColors;
  late double _backgroundGradientRotation;
  late String? _backgroundImage;

  // Frame
  late bool _enableFrame;
  late String? _frameImage;

  // Frame Glow
  late bool _enableFrameGlow;
  late double _frameGlowSize;
  late double _frameGlowBlur;
  late double _frameGlowBorderRadius;
  late Color _frameGlowColor;
  List<Color>? _frameGlowGradientColors;
  late double _frameGlowGradientRotation;

  // Effects
  late bool _enableScroll;
  late bool _enableBounceZoom;
  late bool _enableBounce;
  late BounceDirection _bounceDirection;

  late double _zoomLevel;
  late double _zoomSpeed;

  late double _bounceLevel;
  late double _bounceSpeed;

  // Rotation bounce
  late bool _enableRotationBounce;
  late double _rotationStart;
  late double _rotationEnd;
  late double _rotationSpeed;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  void _initializeState() {
    final t = widget.template;
    _text = t?.text ?? 'NEON BANNER';
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

    _enableOutline = t?.enableOutline ?? false;
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
    _shadowGradientColors = t?.shadowGradientColors;
    _shadowGradientRotation = t?.shadowGradientRotation ?? 0;

    _scrollDirection = t?.scrollDirection ?? ScrollDirection.rightToLeft;
    _scrollSpeed = t?.scrollSpeed ?? 100.0;

    _enableBlink = t?.enableBlink ?? false;
    _blinkDuration = t?.blinkDuration ?? 500.0;

    _backgroundColor = t?.backgroundColor ?? Colors.black;
    _backgroundGradientColors = t?.backgroundGradientColors;
    _backgroundGradientRotation = t?.backgroundGradientRotation ?? 0;
    _backgroundImage = t?.backgroundImage;

    _enableFrame = t?.enableFrame ?? false;
    _frameImage = t?.frameImage ?? 'assets/frames/frame_1.json';

    _enableFrameGlow = t?.enableFrameGlow ?? false;
    _frameGlowSize = t?.frameGlowSize ?? 5.0;
    _frameGlowBlur = t?.frameGlowBlur ?? 10.0;
    _frameGlowBorderRadius = t?.frameGlowBorderRadius ?? 20.0;
    _frameGlowColor = t?.frameGlowColor ?? Colors.blue;
    _frameGlowGradientColors = t?.frameGlowGradientColors;
    _frameGlowGradientRotation = t?.frameGlowGradientRotation ?? 0;

    _enableScroll = t?.enableScroll ?? true;
    _enableBounceZoom = t?.enableBounceZoom ?? false;
    _enableBounce = t?.enableBounce ?? false;
    _bounceDirection = t?.bounceDirection ?? BounceDirection.horizontal;

    _zoomLevel = t?.zoomLevel ?? 20.0;
    _zoomSpeed = t?.zoomSpeed ?? 50.0;

    _bounceLevel = t?.bounceLevel ?? 20.0;
    _bounceSpeed = t?.bounceSpeed ?? 50.0;

    _enableRotationBounce = t?.enableRotationBounce ?? false;
    _rotationStart = t?.rotationStart ?? -15.0;
    _rotationEnd = t?.rotationEnd ?? 15.0;
    _rotationSpeed = t?.rotationSpeed ?? 50.0;
  }

  void _showConfirmBackBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => BottomSheetContainerWidget(
            title: 'Discard template?',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to exit, any changes will not be saved?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        _saveTemplate();
                      },
                      type: NeonButtonType.tertiary,
                      size: NeonButtonSize.large,
                      child: Text('Save Template'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      type: NeonButtonType.tonal,
                      size: NeonButtonSize.large,
                      child: Text('Discard Template'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }

  void _showOverwriteBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => BottomSheetContainerWidget(
            title: 'Overwrite template?',
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Do you wanto to overwrite this change?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        _saveAsNewTemplate();
                      },
                      type: NeonButtonType.tertiary,
                      size: NeonButtonSize.large,
                      child: Text('Create New'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: NeonButton(
                      onPressed: () {
                        Navigator.pop(context); // Close bottom sheet
                        _overwriteTemplate();
                      },
                      type: NeonButtonType.tonal,
                      size: NeonButtonSize.large,
                      child: Text('Overwrite'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
    );
  }

  void _showPhoneSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => PhoneSelectionBottomSheet(
            selectedPhoneAsset: UserData.defaultPhoneAsset.value,
            onPhoneSelected: (asset) {
              UserData.setPhoneAsset(asset);
            },
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
      shadowGradientColors: _shadowGradientColors,
      shadowGradientRotation: _shadowGradientRotation,
      scrollDirection: _scrollDirection,
      scrollSpeed: _scrollSpeed,
      enableBlink: _enableBlink,
      blinkDuration: _blinkDuration,
      backgroundColor: _backgroundColor,
      backgroundGradientColors: _backgroundGradientColors,
      backgroundGradientRotation: _backgroundGradientRotation,
      backgroundImage: _backgroundImage,
      enableFrame: _enableFrame,
      frameImage: _frameImage,
      enableFrameGlow: _enableFrameGlow,
      frameGlowSize: _frameGlowSize,
      frameGlowBlur: _frameGlowBlur,
      frameGlowBorderRadius: _frameGlowBorderRadius,
      frameGlowColor: _frameGlowColor,
      frameGlowGradientColors: _frameGlowGradientColors,
      frameGlowGradientRotation: _frameGlowGradientRotation,
      enableScroll: _enableScroll,
      enableBounceZoom: _enableBounceZoom,
      enableBounce: _enableBounce,
      bounceDirection: _bounceDirection,
      zoomLevel: _zoomLevel,
      zoomSpeed: _zoomSpeed,
      bounceLevel: _bounceLevel,
      bounceSpeed: _bounceSpeed,
      enableRotationBounce: _enableRotationBounce,
      rotationStart: _rotationStart,
      rotationEnd: _rotationEnd,
      rotationSpeed: _rotationSpeed,
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
        shadowGradientColors: _shadowGradientColors,
        shadowGradientRotation: _shadowGradientRotation,
        scrollDirection: _scrollDirection,
        scrollSpeed: _scrollSpeed,
        enableBlink: _enableBlink,
        blinkDuration: _blinkDuration,
        backgroundColor: _backgroundColor,
        backgroundGradientColors: _backgroundGradientColors,
        backgroundGradientRotation: _backgroundGradientRotation,
        backgroundImage: _backgroundImage,
        enableFrame: _enableFrame,
        frameImage: _frameImage,
        enableFrameGlow: _enableFrameGlow,
        frameGlowSize: _frameGlowSize,
        frameGlowBlur: _frameGlowBlur,
        frameGlowBorderRadius: _frameGlowBorderRadius,
        frameGlowColor: _frameGlowColor,
        frameGlowGradientColors: _frameGlowGradientColors,
        frameGlowGradientRotation: _frameGlowGradientRotation,
        enableScroll: _enableScroll,
        enableBounceZoom: _enableBounceZoom,
        enableBounce: _enableBounce,
        bounceDirection: _bounceDirection,
        zoomLevel: _zoomLevel,
        zoomSpeed: _zoomSpeed,
        bounceLevel: _bounceLevel,
        bounceSpeed: _bounceSpeed,
        enableRotationBounce: _enableRotationBounce,
        rotationStart: _rotationStart,
        rotationEnd: _rotationEnd,
        rotationSpeed: _rotationSpeed,
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
            NeonButton(
              size: NeonButtonSize.small,
              type: NeonButtonType.tertiary,
              onPressed: _saveTemplate,
              child: const Text('Save'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: Column(
          children: [
            // Preview Area
            // Preview Area
            Stack(
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: UserData.defaultPhoneAsset,
                  builder: (context, phoneAsset, child) {
                    return PreviewWidget(
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
                        shadowGradientColors: _shadowGradientColors,
                        shadowGradientRotation: _shadowGradientRotation,
                        scrollDirection: _scrollDirection,
                        scrollSpeed: _scrollSpeed,
                        enableBlink: _enableBlink,
                        blinkDuration: _blinkDuration,
                        backgroundColor: _backgroundColor,
                        backgroundGradientColors: _backgroundGradientColors,
                        backgroundGradientRotation: _backgroundGradientRotation,
                        backgroundImage: _backgroundImage,
                        enableFrame: _enableFrame,
                        frameImage: _frameImage,
                        enableFrameGlow: _enableFrameGlow,
                        frameGlowSize: _frameGlowSize,
                        frameGlowBlur: _frameGlowBlur,
                        frameGlowBorderRadius: _frameGlowBorderRadius,
                        frameGlowColor: _frameGlowColor,
                        frameGlowGradientColors: _frameGlowGradientColors,
                        frameGlowGradientRotation: _frameGlowGradientRotation,
                        textColor: _textColor,
                        textGradientColors: _textGradientColors,
                        textGradientRotation: _textGradientRotation,
                        enableScroll: _enableScroll,
                        enableBounceZoom: _enableBounceZoom,
                        enableBounce: _enableBounce,
                        bounceDirection: _bounceDirection,
                        zoomLevel: _zoomLevel,
                        zoomSpeed: _zoomSpeed,
                        bounceLevel: _bounceLevel,
                        bounceSpeed: _bounceSpeed,
                        enableRotationBounce: _enableRotationBounce,
                        rotationStart: _rotationStart,
                        rotationEnd: _rotationEnd,
                        rotationSpeed: _rotationSpeed,
                      ),
                      text: _text,
                      phoneAsset: phoneAsset,
                    );
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.ad_units, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      onPressed: _showPhoneSelectionBottomSheet,
                    ),
                  ),
                ),
              ],
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
                      dividerHeight: 0.5,
                      dividerColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.2),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 1,
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      indicatorColor: Theme.of(context).colorScheme.onSurface,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.5),
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            // Effect Tab
                            _EffectSettingsPanel(
                              enableScroll: _enableScroll,
                              onEnableScrollChanged:
                                  (v) => setState(() => _enableScroll = v),
                              enableBounceZoom: _enableBounceZoom,
                              onEnableBounceZoomChanged:
                                  (v) => setState(() => _enableBounceZoom = v),
                              enableBounce: _enableBounce,
                              onEnableBounceChanged:
                                  (v) => setState(() => _enableBounce = v),
                              bounceDirection: _bounceDirection,
                              onBounceDirectionChanged:
                                  (v) => setState(() => _bounceDirection = v),
                              scrollDirection: _scrollDirection,
                              onScrollDirectionChanged:
                                  (v) => setState(() => _scrollDirection = v),
                              scrollSpeed: _scrollSpeed,
                              onScrollSpeedChanged:
                                  (v) => setState(() => _scrollSpeed = v),
                              zoomLevel: _zoomLevel,
                              onZoomLevelChanged:
                                  (v) => setState(() => _zoomLevel = v),
                              zoomSpeed: _zoomSpeed,
                              onZoomSpeedChanged:
                                  (v) => setState(() => _zoomSpeed = v),
                              bounceLevel: _bounceLevel,
                              onBounceLevelChanged:
                                  (v) => setState(() => _bounceLevel = v),
                              bounceSpeed: _bounceSpeed,
                              onBounceSpeedChanged:
                                  (v) => setState(() => _bounceSpeed = v),
                              enableBlink: _enableBlink,
                              onEnableBlinkChanged:
                                  (v) => setState(() => _enableBlink = v),
                              blinkDuration: _blinkDuration,
                              onBlinkDurationChanged:
                                  (v) => setState(() => _blinkDuration = v),
                              enableRotationBounce: _enableRotationBounce,
                              onEnableRotationBounceChanged:
                                  (v) =>
                                      setState(() => _enableRotationBounce = v),
                              rotationStart: _rotationStart,
                              onRotationStartChanged:
                                  (v) => setState(() => _rotationStart = v),
                              rotationEnd: _rotationEnd,
                              onRotationEndChanged:
                                  (v) => setState(() => _rotationEnd = v),
                              rotationSpeed: _rotationSpeed,
                              onRotationSpeedChanged:
                                  (v) => setState(() => _rotationSpeed = v),
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
                              shadowGradientColors: _shadowGradientColors,
                              shadowGradientRotation: _shadowGradientRotation,
                              onShadowGradientChanged:
                                  (colors, rotation) => setState(() {
                                    _shadowGradientColors = colors;
                                    _shadowGradientRotation = rotation;
                                  }),
                            ),
                            // Backdrop Tab
                            _BackdropSettingsPanel(
                              backgroundColor: _backgroundColor,
                              onBackgroundColorChanged:
                                  (v) => setState(() => _backgroundColor = v),
                              backgroundGradientColors:
                                  _backgroundGradientColors,
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
                              enableFrameGlow: _enableFrameGlow,
                              onEnableFrameGlowChanged:
                                  (v) => setState(() => _enableFrameGlow = v),
                              frameGlowSize: _frameGlowSize,
                              onFrameGlowSizeChanged:
                                  (v) => setState(() => _frameGlowSize = v),
                              frameGlowBlur: _frameGlowBlur,
                              onFrameGlowBlurChanged:
                                  (v) => setState(() => _frameGlowBlur = v),
                              frameGlowBorderRadius: _frameGlowBorderRadius,
                              onFrameGlowBorderRadiusChanged:
                                  (v) => setState(
                                    () => _frameGlowBorderRadius = v,
                                  ),
                              frameGlowColor: _frameGlowColor,
                              onFrameGlowColorChanged:
                                  (v) => setState(() => _frameGlowColor = v),
                              frameGlowGradientColors: _frameGlowGradientColors,
                              frameGlowGradientRotation:
                                  _frameGlowGradientRotation,
                              onFrameGlowGradientChanged:
                                  (colors, rotation) => setState(() {
                                    _frameGlowGradientColors = colors;
                                    _frameGlowGradientRotation = rotation;
                                  }),
                            ),
                          ],
                        ),
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
  final bool enableScroll;
  final ValueChanged<bool> onEnableScrollChanged;
  final bool enableBounceZoom;
  final ValueChanged<bool> onEnableBounceZoomChanged;
  final bool enableBounce;
  final ValueChanged<bool> onEnableBounceChanged;
  final BounceDirection bounceDirection;
  final ValueChanged<BounceDirection> onBounceDirectionChanged;

  final ScrollDirection scrollDirection;
  final ValueChanged<ScrollDirection> onScrollDirectionChanged;
  final double scrollSpeed;
  final ValueChanged<double> onScrollSpeedChanged;

  final double zoomLevel;
  final ValueChanged<double> onZoomLevelChanged;
  final double zoomSpeed;
  final ValueChanged<double> onZoomSpeedChanged;

  final double bounceLevel;
  final ValueChanged<double> onBounceLevelChanged;
  final double bounceSpeed;
  final ValueChanged<double> onBounceSpeedChanged;

  final bool enableBlink;
  final ValueChanged<bool> onEnableBlinkChanged;
  final double blinkDuration;
  final ValueChanged<double> onBlinkDurationChanged;

  final bool enableRotationBounce;
  final ValueChanged<bool> onEnableRotationBounceChanged;
  final double rotationStart;
  final ValueChanged<double> onRotationStartChanged;
  final double rotationEnd;
  final ValueChanged<double> onRotationEndChanged;
  final double rotationSpeed;
  final ValueChanged<double> onRotationSpeedChanged;

  const _EffectSettingsPanel({
    required this.enableScroll,
    required this.onEnableScrollChanged,
    required this.enableBounceZoom,
    required this.onEnableBounceZoomChanged,
    required this.enableBounce,
    required this.onEnableBounceChanged,
    required this.bounceDirection,
    required this.onBounceDirectionChanged,
    required this.scrollDirection,
    required this.onScrollDirectionChanged,
    required this.scrollSpeed,
    required this.onScrollSpeedChanged,
    required this.zoomLevel,
    required this.onZoomLevelChanged,
    required this.zoomSpeed,
    required this.onZoomSpeedChanged,
    required this.bounceLevel,
    required this.onBounceLevelChanged,
    required this.bounceSpeed,
    required this.onBounceSpeedChanged,
    required this.enableBlink,
    required this.onEnableBlinkChanged,
    required this.blinkDuration,
    required this.onBlinkDurationChanged,
    required this.enableRotationBounce,
    required this.onEnableRotationBounceChanged,
    required this.rotationStart,
    required this.onRotationStartChanged,
    required this.rotationEnd,
    required this.onRotationEndChanged,
    required this.rotationSpeed,
    required this.onRotationSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        // Scroll Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      icon: Icons.arrow_circle_right_outlined,
                      title: 'Scroll',
                    ),
                    AppSwitchWidget(
                      value: enableScroll,
                      onChanged: onEnableScrollChanged,
                    ),
                  ],
                ),
              ),
              if (enableScroll) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      // Direction
                      Row(
                        children: [
                          const Text(
                            'Direction',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconChipButtonWidget(
                                icon: Icons.arrow_back,
                                isActive:
                                    scrollDirection ==
                                    ScrollDirection.rightToLeft,
                                onPressed:
                                    () => onScrollDirectionChanged(
                                      ScrollDirection.rightToLeft,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              IconChipButtonWidget(
                                icon: Icons.arrow_upward,
                                isActive:
                                    scrollDirection ==
                                    ScrollDirection.bottomToTop,
                                onPressed:
                                    () => onScrollDirectionChanged(
                                      ScrollDirection.bottomToTop,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              IconChipButtonWidget(
                                icon: Icons.arrow_downward,
                                isActive:
                                    scrollDirection ==
                                    ScrollDirection.topToBottom,
                                onPressed:
                                    () => onScrollDirectionChanged(
                                      ScrollDirection.topToBottom,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              IconChipButtonWidget(
                                icon: Icons.arrow_forward,
                                isActive:
                                    scrollDirection ==
                                    ScrollDirection.leftToRight,
                                onPressed:
                                    () => onScrollDirectionChanged(
                                      ScrollDirection.leftToRight,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Speed
                      Text(
                        'Speed (${scrollSpeed.clamp(0.0, 500.0).toStringAsFixed(0)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: scrollSpeed.clamp(0.0, 500.0),
                        min: 0,
                        max: 500,
                        onChanged: onScrollSpeedChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Zoom Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.zoom_in, title: 'Zoom'),
                    AppSwitchWidget(
                      value: enableBounceZoom,
                      onChanged: onEnableBounceZoomChanged,
                    ),
                  ],
                ),
              ),
              if (enableBounceZoom) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      // Level
                      Text(
                        'Level (${zoomLevel.toStringAsFixed(0)}%)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: zoomLevel,
                        min: 0,
                        max: 100,
                        onChanged: onZoomLevelChanged,
                      ),
                      const SizedBox(height: 12),
                      // Speed
                      Text(
                        'Speed (${zoomSpeed.toStringAsFixed(0)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: zoomSpeed,
                        min: 0,
                        max: 100,
                        onChanged: onZoomSpeedChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Bounce Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.animation, title: 'Bounce'),
                    AppSwitchWidget(
                      value: enableBounce,
                      onChanged: onEnableBounceChanged,
                    ),
                  ],
                ),
              ),
              if (enableBounce) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      // Direction
                      Row(
                        children: [
                          const Text(
                            'Direction',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconChipButtonWidget(
                                icon: Icons.swap_vert,
                                isActive:
                                    bounceDirection == BounceDirection.vertical,
                                onPressed:
                                    () => onBounceDirectionChanged(
                                      BounceDirection.vertical,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              IconChipButtonWidget(
                                icon: Icons.swap_horiz,
                                isActive:
                                    bounceDirection ==
                                    BounceDirection.horizontal,
                                onPressed:
                                    () => onBounceDirectionChanged(
                                      BounceDirection.horizontal,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Level
                      Text(
                        'Level (${bounceLevel.toStringAsFixed(0)}%)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: bounceLevel,
                        min: 0,
                        max: 100,
                        onChanged: onBounceLevelChanged,
                      ),
                      const SizedBox(height: 12),
                      // Speed
                      Text(
                        'Speed (${bounceSpeed.toStringAsFixed(0)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: bounceSpeed,
                        min: 0,
                        max: 100,
                        onChanged: onBounceSpeedChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Blink Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.flash_on, title: 'Blink'),
                    AppSwitchWidget(
                      value: enableBlink,
                      onChanged: onEnableBlinkChanged,
                    ),
                  ],
                ),
              ),
              if (enableBlink) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      // Duration
                      Text(
                        'Duration (${blinkDuration.toStringAsFixed(0)}ms)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: blinkDuration,
                        min: 100,
                        max: 2000,
                        onChanged: onBlinkDurationChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Rotation Bounce Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      icon: Icons.rotate_90_degrees_ccw,
                      title: 'Rotation',
                    ),
                    AppSwitchWidget(
                      value: enableRotationBounce,
                      onChanged: onEnableRotationBounceChanged,
                    ),
                  ],
                ),
              ),
              if (enableRotationBounce) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      // Start Angle
                      Text(
                        'Start (${rotationStart.toStringAsFixed(0)}°)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: rotationStart,
                        min: -45,
                        max: 45,
                        onChanged: onRotationStartChanged,
                      ),
                      const SizedBox(height: 12),
                      // End Angle
                      Text(
                        'End (${rotationEnd.toStringAsFixed(0)}°)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: rotationEnd,
                        min: -45,
                        max: 45,
                        onChanged: onRotationEndChanged,
                      ),
                      const SizedBox(height: 12),
                      // Speed
                      Text(
                        'Speed (${rotationSpeed.toStringAsFixed(0)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: rotationSpeed,
                        min: 0,
                        max: 100,
                        onChanged: onRotationSpeedChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
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
  final List<Color>? shadowGradientColors;
  final double shadowGradientRotation;
  final Function(List<Color>?, double) onShadowGradientChanged;

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
    this.shadowGradientColors,
    this.shadowGradientRotation = 0,
    required this.onShadowGradientChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        GestureDetector(
          onTap: () async {
            final result = await showModalBottomSheet<String>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (context) => MessageInputBottomSheet(
                    initialText: text,
                    buttonLabel: 'Save',
                  ),
            );
            if (result != null) {
              onTextChanged(result);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              text.isEmpty ? 'Enter message' : text,
              style: TextStyle(
                fontSize: 16,
                color:
                    text.isEmpty
                        ? Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5)
                        : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Font Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SectionTitle(icon: Icons.font_download_outlined, title: 'Font'),
              SelectButtonWidget(
                value: _getFontDisplayName(fontFamily),
                borderColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.2),
                onPressed: () async {
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.black.withOpacity(0.5),
                    builder:
                        (context) => _FontPickerBottomSheet(
                          selectedFont: fontFamily,
                          previewText: text,
                        ),
                  );
                  if (result != null) {
                    onFontFamilyChanged(result);
                  }
                },
                textStyle: TextStyle(fontFamily: fontFamily),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Font Size Card
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(
                icon: Icons.format_size_outlined,
                title: 'Size',
                value: '${fontSize.toStringAsFixed(0)}%',
              ),
              const SizedBox(height: 4),
              AppSliderWidget(
                value: fontSize,
                min: 15,
                max: 90,
                onChanged: onFontSizeChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Font Color Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SectionTitle(
                  icon: Icons.palette_outlined,
                  title: 'Color',
                  value:
                      textGradientColors != null
                          ? _gradientToString(textGradientColors)
                          : _colorToHex(textColor),
                ),
              ),
              const SizedBox(height: 12),
              ColorPaletteGridWidget(
                selectedColor: textColor,
                onColorChanged: onTextColorChanged,
                gradientColors: textGradientColors,
                gradientRotation: textGradientRotation,
                onGradientChanged: onTextGradientChanged,
                label: 'Font Color',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Stroke Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      icon: Icons.border_outer_outlined,
                      title: 'Stroke',
                    ),
                    AppSwitchWidget(
                      value: enableStroke,
                      onChanged: onEnableStrokeChanged,
                    ),
                  ],
                ),
              ),
              if (enableStroke) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Width (${strokeWidth.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: strokeWidth,
                        min: 0,
                        max: 50,
                        onChanged: onStrokeWidthChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strokeGradientColors != null
                            ? 'Color (${_gradientToString(strokeGradientColors)})'
                            : 'Color (${_colorToHex(strokeColor)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ColorPaletteGridWidget(
                  selectedColor: strokeColor,
                  onColorChanged: onStrokeColorChanged,
                  gradientColors: strokeGradientColors,
                  gradientRotation: strokeGradientRotation,
                  onGradientChanged: onStrokeGradientChanged,
                  label: 'Stroke Color',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Glow Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.blur_on_outlined, title: 'Glow'),
                    AppSwitchWidget(
                      value: enableOutline,
                      onChanged: onEnableOutlineChanged,
                    ),
                  ],
                ),
              ),
              if (enableOutline) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size (${outlineWidth.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: outlineWidth,
                        min: 0,
                        max: 50,
                        onChanged: onOutlineWidthChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Blur (${outlineBlur.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: outlineBlur,
                        min: 0,
                        max: 50,
                        onChanged: onOutlineBlurChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        outlineGradientColors != null
                            ? 'Color (${_gradientToString(outlineGradientColors)})'
                            : 'Color (${_colorToHex(outlineColor)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ColorPaletteGridWidget(
                  selectedColor: outlineColor,
                  onColorChanged: onOutlineColorChanged,
                  gradientColors: outlineGradientColors,
                  gradientRotation: outlineGradientRotation,
                  onGradientChanged: onOutlineGradientChanged,
                  label: 'Outline Color',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Shadow Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.layers_outlined, title: 'Shadow'),
                    AppSwitchWidget(
                      value: enableShadow,
                      onChanged: onEnableShadowChanged,
                    ),
                  ],
                ),
              ),
              if (enableShadow) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      Text(
                        'Blur (${shadowBlur.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      AppSliderWidget(
                        value: shadowBlur,
                        min: 0,
                        max: 40,
                        onChanged: onShadowBlurChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Position X (${shadowOffsetX.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      AppSliderWidget(
                        value: shadowOffsetX,
                        min: -20,
                        max: 20,
                        onChanged: onShadowOffsetXChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Position Y (${shadowOffsetY.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      AppSliderWidget(
                        value: shadowOffsetY,
                        min: -20,
                        max: 20,
                        onChanged: onShadowOffsetYChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        shadowGradientColors != null
                            ? 'Color (${_gradientToString(shadowGradientColors)})'
                            : 'Color (${_colorToHex(shadowColor)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ColorPaletteGridWidget(
                  selectedColor: shadowColor,
                  onColorChanged: onShadowColorChanged,
                  gradientColors: shadowGradientColors,
                  gradientRotation: shadowGradientRotation,
                  onGradientChanged: onShadowGradientChanged,
                  label: 'Shadow Color',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

// Backdrop Settings Panel
class _BackdropSettingsPanel extends StatefulWidget {
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

  final bool enableFrameGlow;
  final ValueChanged<bool> onEnableFrameGlowChanged;
  final double frameGlowSize;
  final ValueChanged<double> onFrameGlowSizeChanged;
  final double frameGlowBlur;
  final ValueChanged<double> onFrameGlowBlurChanged;
  final double frameGlowBorderRadius;
  final ValueChanged<double> onFrameGlowBorderRadiusChanged;
  final Color frameGlowColor;
  final ValueChanged<Color> onFrameGlowColorChanged;
  final List<Color>? frameGlowGradientColors;
  final double frameGlowGradientRotation;
  final Function(List<Color>?, double) onFrameGlowGradientChanged;

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
    required this.enableFrameGlow,
    required this.onEnableFrameGlowChanged,
    required this.frameGlowSize,
    required this.onFrameGlowSizeChanged,
    required this.frameGlowBlur,
    required this.onFrameGlowBlurChanged,
    required this.frameGlowBorderRadius,
    required this.onFrameGlowBorderRadiusChanged,
    required this.frameGlowColor,
    required this.onFrameGlowColorChanged,
    this.frameGlowGradientColors,
    this.frameGlowGradientRotation = 0,
    required this.onFrameGlowGradientChanged,
  });

  @override
  State<_BackdropSettingsPanel> createState() => _BackdropSettingsPanelState();
}

class _BackdropSettingsPanelState extends State<_BackdropSettingsPanel> {
  List<String> _backgroundAssets = [];
  List<String> _frameAssets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final manifestContent = await DefaultAssetBundle.of(
        context,
      ).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final backgrounds =
          manifestMap.keys
              .where((String key) => key.startsWith('assets/backgrounds/'))
              .toList();

      final frames =
          manifestMap.keys
              .where(
                (String key) =>
                    key.startsWith('assets/frames/') && key.endsWith('.json'),
              )
              .toList();

      if (mounted) {
        setState(() {
          _backgroundAssets = backgrounds;
          _frameAssets = frames;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading assets: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(12.0),
      children: [
        // Background Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      icon: Icons.image_outlined,
                      title: 'Background',
                    ),
                    Row(
                      children: [
                        TextChipButtonWidget(
                          label: 'Color',
                          isSelected: widget.backgroundImage == null,
                          onTap: () => widget.onBackgroundImageChanged(null),
                        ),
                        const SizedBox(width: 8),
                        TextChipButtonWidget(
                          label: 'Image',
                          isSelected: widget.backgroundImage != null,
                          onTap: () {
                            if (_backgroundAssets.isNotEmpty) {
                              widget.onBackgroundImageChanged(
                                _backgroundAssets.first,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (widget.backgroundImage == null)
                ColorPaletteGridWidget(
                  selectedColor: widget.backgroundColor,
                  onColorChanged: widget.onBackgroundColorChanged,
                  gradientColors: widget.backgroundGradientColors,
                  gradientRotation: widget.backgroundGradientRotation,
                  onGradientChanged: widget.onBackgroundGradientChanged,
                  label: 'Background Color',
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Row(
                        spacing: 8,
                        children:
                            _backgroundAssets.map((assetPath) {
                              return _ImageOption(
                                assetPath: assetPath,
                                isSelected: widget.backgroundImage == assetPath,
                                onTap:
                                    () => widget.onBackgroundImageChanged(
                                      assetPath,
                                    ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Frame Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(
                      icon: Icons.photo_size_select_large_outlined,
                      title: 'Frame',
                    ),
                    AppSwitchWidget(
                      value: widget.enableFrame,
                      onChanged: widget.onEnableFrameChanged,
                    ),
                  ],
                ),
              ),
              if (widget.enableFrame) ...[
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Row(
                        spacing: 8,
                        children:
                            _frameAssets.map((assetPath) {
                              return _ImageOption(
                                assetPath: assetPath,
                                isSelected: widget.frameImage == assetPath,
                                onTap:
                                    () => widget.onFrameImageChanged(assetPath),
                              );
                            }).toList(),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Frame Glow Card
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SectionTitle(icon: Icons.blur_on, title: 'Frame Glow'),
                    AppSwitchWidget(
                      value: widget.enableFrameGlow,
                      onChanged: widget.onEnableFrameGlowChanged,
                    ),
                  ],
                ),
              ),
              if (widget.enableFrameGlow) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 24,
                        thickness: 0.5,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Size (${widget.frameGlowSize.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: widget.frameGlowSize,
                        min: 1,
                        max: 50,
                        onChanged: widget.onFrameGlowSizeChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Blur (${widget.frameGlowBlur.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: widget.frameGlowBlur,
                        min: 0,
                        max: 50,
                        onChanged: widget.onFrameGlowBlurChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Border Radius (${widget.frameGlowBorderRadius.toStringAsFixed(1)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      AppSliderWidget(
                        value: widget.frameGlowBorderRadius,
                        min: 0,
                        max: 50,
                        onChanged: widget.onFrameGlowBorderRadiusChanged,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Color (${_colorToHex(widget.frameGlowColor)})',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ColorPaletteGridWidget(
                  selectedColor: widget.frameGlowColor,
                  onColorChanged: widget.onFrameGlowColorChanged,
                  gradientColors: widget.frameGlowGradientColors,
                  gradientRotation: widget.frameGlowGradientRotation,
                  onGradientChanged: widget.onFrameGlowGradientChanged,
                  label: 'Glow Color',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 40),
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
    // Convert frame JSON path to thumbnail JPG path
    final thumbnailPath = assetPath.replaceAll('.json', '.jpg');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 80,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: AssetImage(thumbnailPath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widget: Font Picker Bottom Sheet
class _FontPickerBottomSheet extends StatelessWidget {
  final String selectedFont;
  final String previewText;

  const _FontPickerBottomSheet({
    required this.selectedFont,
    required this.previewText,
  });

  static const Map<String, String> _fontMap = {
    'Roboto': 'Default (Roboto)',
    'Beon': 'Beon',
    'Amaline': 'Amaline',
    'BetterOutline': 'Better Outline',
    'Crosseline': 'Crosseline',
    'Glowtone': 'Glowtone',
    'Honeyline': 'Honeyline',
    'Klaxons': 'Klaxons',
    'NeonBines': 'Neon Bines',
    'NeonBlitz': 'Neon Blitz',
    'NeonDerthaw': 'Neon Derthaw',
    'NeonLight': 'Neon Light',
    'NeonSans': 'Neon Sans',
    'Rookworst': 'Rookworst',
    'Ryga': 'Ryga',
    'SunsetClub': 'Sunset Club',
    'Wednesline': 'Wednesline',
    'WonderfulAustralia': 'Wonderful Australia',
    'TenPixel': '10 Pixel',
    'AlbertSans': 'Albert Sans',
    'DynaPuff': 'Dyna Puff',
    'Creepster': 'Creepster',
    'Mali': 'Mali',
    'Pacifico': 'Pacifico',
    'PlaypenSans': 'Playpen Sans',
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return BottomSheetContainerWidget(
          expandChild: true,
          title: 'Select Font',
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _fontMap.length,
            itemBuilder: (context, index) {
              final entry = _fontMap.entries.elementAt(index);
              final fontValue = entry.key;
              final isSelected = selectedFont == fontValue;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context, fontValue),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 24.0,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.15)
                              : Theme.of(
                                context,
                              ).colorScheme.onBackground.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          isSelected
                              ? Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              )
                              : null,
                    ),
                    child: Center(
                      child: Text(
                        previewText.isEmpty ? 'Preview Text' : previewText,
                        style: TextStyle(
                          fontFamily: fontValue,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color:
                              isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Helper function to get font display name
String _getFontDisplayName(String fontFamily) {
  const fontMap = {
    'Roboto': 'Default (Roboto)',
    'Beon': 'Beon',
    'Amaline': 'Amaline',
    'BetterOutline': 'Better Outline',
    'Crosseline': 'Crosseline',
    'Glowtone': 'Glowtone',
    'Honeyline': 'Honeyline',
    'Klaxons': 'Klaxons',
    'NeonBines': 'Neon Bines',
    'NeonBlitz': 'Neon Blitz',
    'NeonDerthaw': 'Neon Derthaw',
    'NeonLight': 'Neon Light',
    'NeonSans': 'Neon Sans',
    'Rookworst': 'Rookworst',
    'Ryga': 'Ryga',
    'SunsetClub': 'Sunset Club',
    'Wednesline': 'Wednesline',
    'WonderfulAustralia': 'Wonderful Australia',
    'TenPixel': '10 Pixel',
    'AlbertSans': 'Albert Sans',
    'DynaPuff': 'Dyna Puff',
    'Creepster': 'Creepster',
    'Mali': 'Mali',
    'Pacifico': 'Pacifico',
    'PlaypenSans': 'Playpen Sans',
  };
  return fontMap[fontFamily] ?? fontFamily;
}

// Helper widget: Section Title with Icon
// Helper functions
String _colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

String _gradientToString(List<Color>? colors) {
  if (colors == null || colors.isEmpty) return '';
  if (colors.length == 1) return _colorToHex(colors[0]);
  return colors.map((c) => _colorToHex(c)).join(' → ');
}

String _getScrollDirectionName(ScrollDirection direction) {
  switch (direction) {
    case ScrollDirection.leftToRight:
      return 'Left → Right';
    case ScrollDirection.rightToLeft:
      return 'Right → Left';
    case ScrollDirection.topToBottom:
      return 'Top → Bottom';
    case ScrollDirection.bottomToTop:
      return 'Bottom → Top';
    case ScrollDirection.none:
      return 'None';
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value; // Optional value to display

  const _SectionTitle({required this.icon, required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (value != null) ...[
          const SizedBox(width: 8),
          Text(
            '($value)',
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}

// Text Input Bottom Sheet
