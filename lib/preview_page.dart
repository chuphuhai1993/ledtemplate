import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/app_appbar_widget.dart';
import 'package:ledtemplate/widgets/blur_container_widget.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
import 'package:ledtemplate/widgets/app_textfield_widget.dart';
import 'models/template.dart';
import 'play_page.dart';
import 'editor_page.dart';

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
  late List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Create a text controller for each template
    _textControllers =
        widget.templates
            .map((template) => TextEditingController(text: template.text))
            .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToPlay() {
    final template = widget.templates[_currentIndex];
    final text = _textControllers[_currentIndex].text;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PlayPage(
              text: text,
              fontFamily: template.fontFamily,
              fontSize: template.fontSize,
              enableStroke: template.enableStroke,
              strokeWidth: template.strokeWidth,
              strokeColor: template.strokeColor,
              enableOutline: template.enableOutline,
              outlineWidth: template.outlineWidth,
              outlineBlur: template.outlineBlur,
              outlineColor: template.outlineColor,
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
              templateIndex: widget.showEditButton ? _currentIndex : null,
              textColor: template.textColor,
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
                        final textController = _textControllers[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Preview Area
                            PreviewWidget(
                              template: template,
                              text: textController.text,
                              showPhoneFrame: true,
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Enter message to playing or swipe to explore more',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),

                            // Input Area
                            Container(
                              padding: const EdgeInsets.all(32.0),
                              child: AppTextFieldWidget(
                                controller: textController,
                                onChanged: (value) => setState(() {}),
                                hintText: 'Type something...',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Appbar
              Positioned(top: 0, left: 0, right: 0, child: AppAppBarWidget()),

              // Buttons
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      if (widget.showEditButton)
                        Expanded(
                          child: NeonButton(
                            type: NeonButtonType.tonal,
                            onPressed: _navigateToEdit,
                            size: NeonButtonSize.large,
                            child: Text('Edit'),
                          ),
                        ),
                      if (widget.showEditButton) const SizedBox(width: 16),
                      Expanded(
                        child: NeonButton(
                          onPressed: _navigateToPlay,
                          size: NeonButtonSize.large,
                          child: Text('Play'),
                        ),
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
