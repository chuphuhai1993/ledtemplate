import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ledtemplate/widgets/app_appbar_widget.dart';
import 'package:ledtemplate/widgets/blur_button.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
import 'package:ledtemplate/widgets/message_input_bottom_sheet.dart';
import 'models/template.dart';
import 'play_page.dart';
import 'editor_page.dart';
import 'data/user_data.dart';

import 'widgets/neon_button.dart';

class PreviewPage extends StatefulWidget {
  final List<Template> templates;
  final int initialIndex;
  final String categoryName;
  final bool showEditButton;
  final int? templateIndex;

  const PreviewPage({
    super.key,
    required this.templates,
    required this.initialIndex,
    required this.categoryName,
    this.showEditButton = false,
    this.templateIndex,
  });

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _showMessageInputAndPlay() async {
    final template = widget.templates[_currentIndex];

    // Show message input dialog
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => MessageInputBottomSheet(
            initialText: template.text,
            buttonLabel: 'Play',
            showIcon: true,
          ),
    );

    // Navigate to play page if text was entered
    if (text != null && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => PlayPage(
                text: text,
                fontFamily: template.fontFamily,
                fontSize: template.fontSize,
                textColor: template.textColor,
                textGradientColors: template.textGradientColors,
                textGradientRotation: template.textGradientRotation,
                enableStroke: template.enableStroke,
                strokeWidth: template.strokeWidth,
                strokeColor: template.strokeColor,
                strokeGradientColors: template.strokeGradientColors,
                strokeGradientRotation: template.strokeGradientRotation,
                enableOutline: template.enableOutline,
                outlineWidth: template.outlineWidth,
                outlineBlur: template.outlineBlur,
                outlineColor: template.outlineColor,
                outlineGradientColors: template.outlineGradientColors,
                outlineGradientRotation: template.outlineGradientRotation,
                enableShadow: template.enableShadow,
                shadowOffsetX: template.shadowOffsetX,
                shadowOffsetY: template.shadowOffsetY,
                shadowBlur: template.shadowBlur,
                shadowColor: template.shadowColor,
                shadowGradientColors: template.shadowGradientColors,
                shadowGradientRotation: template.shadowGradientRotation,
                scrollDirection: template.scrollDirection,
                scrollSpeed: template.scrollSpeed,
                enableBlink: template.enableBlink,
                blinkDuration: template.blinkDuration,
                backgroundColor: template.backgroundColor,
                backgroundGradientColors: template.backgroundGradientColors,
                backgroundGradientRotation: template.backgroundGradientRotation,
                backgroundImage: template.backgroundImage,
                enableFrame: template.enableFrame,
                frameImage: template.frameImage,
                enableFrameGlow: template.enableFrameGlow,
                frameGlowSize: template.frameGlowSize,
                frameGlowBlur: template.frameGlowBlur,
                frameGlowBorderRadius: template.frameGlowBorderRadius,
                frameGlowColor: template.frameGlowColor,
                frameGlowGradientColors: template.frameGlowGradientColors,
                frameGlowGradientRotation: template.frameGlowGradientRotation,
                templateIndex: widget.showEditButton ? _currentIndex : null,
                enableScroll: template.enableScroll,
                enableBounceZoom: template.enableBounceZoom,
                enableBounce: template.enableBounce,
                bounceDirection: template.bounceDirection,
                zoomLevel: template.zoomLevel,
                zoomSpeed: template.zoomSpeed,
                bounceLevel: template.bounceLevel,
                bounceSpeed: template.bounceSpeed,
                enableRotationBounce: template.enableRotationBounce,
                rotationStart: template.rotationStart,
                rotationEnd: template.rotationEnd,
                rotationSpeed: template.rotationSpeed,
              ),
        ),
      );
    }
  }

  void _navigateToEdit() {
    // For My Templates, templateIndex should be the current swipe index
    final editIndex =
        widget.showEditButton ? _currentIndex : widget.templateIndex;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EditorPage(
              template: widget.templates[_currentIndex],
              templateIndex: editIndex,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTemplate = widget.templates[_currentIndex];
    final backgroundImage = currentTemplate.backgroundImage;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Base layer: Image, gradient, or solid color
          Container(
            decoration: BoxDecoration(
              // Gradient
              gradient:
                  backgroundImage == null &&
                          currentTemplate.backgroundGradientColors != null
                      ? LinearGradient(
                        colors: currentTemplate.backgroundGradientColors!,
                        transform: GradientRotation(
                          currentTemplate.backgroundGradientRotation *
                              3.14159 /
                              180,
                        ),
                      )
                      : null,
              // Image
              image:
                  backgroundImage != null
                      ? DecorationImage(
                        image: AssetImage(backgroundImage),
                        fit: BoxFit.cover,
                      )
                      : null,
              // Solid color
              color:
                  backgroundImage == null &&
                          currentTemplate.backgroundGradientColors == null
                      ? currentTemplate.backgroundColor
                      : null,
            ),
          ),

          // Overlay: Blur for image, or just darken for color/gradient
          if (backgroundImage != null)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
              child: Container(color: Colors.black.withOpacity(0.4)),
            )
          else
            Container(color: Colors.black.withOpacity(0.4)),

          // Original content
          Stack(
            children: [
              // PageView with MessageInputWidget
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      onPageChanged: _onPageChanged,
                      itemCount: widget.templates.length,
                      itemBuilder: (context, index) {
                        final template = widget.templates[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Preview Area
                            ValueListenableBuilder<String>(
                              valueListenable: UserData.defaultPhoneAsset,
                              builder: (context, phoneAsset, child) {
                                return Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: PreviewWidget(
                                    template: template,
                                    text: template.text,
                                    showPhoneFrame: true,
                                    phoneAsset: phoneAsset,
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Swipe to explore more templates',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),

              // Appbar
              Positioned(
                top: 56,
                left: 16,
                child: BlurButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Buttons
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      NeonButton(
                        onPressed: _showMessageInputAndPlay,
                        size: NeonButtonSize.large,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/icon_cursor.svg',
                              width: 20,
                              height: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text('Enter message & play'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.showEditButton)
                        Row(
                          children: [
                            Expanded(
                              child: NeonButton(
                                type: NeonButtonType.tonal,
                                onPressed: _navigateToEdit,
                                size: NeonButtonSize.large,
                                child: Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: NeonButton(
                                type: NeonButtonType.tonal,
                                onPressed: _navigateToEdit,
                                size: NeonButtonSize.large,
                                child:
                                    widget.showEditButton
                                        ? Text('Duplicate')
                                        : Text('Duplicate template'),
                              ),
                            ),
                          ],
                        )
                      else
                        NeonButton(
                          type: NeonButtonType.tonal,
                          onPressed: _navigateToEdit,
                          size: NeonButtonSize.large,
                          child: Text('Duplicate template'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
