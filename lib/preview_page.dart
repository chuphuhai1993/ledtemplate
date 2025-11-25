import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/app_appbar_widget.dart';
import 'package:ledtemplate/widgets/blur_container_widget.dart';
import 'package:ledtemplate/widgets/preview_widget.dart';
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
              scrollDirection: template.scrollDirection,
              scrollSpeed: template.scrollSpeed,
              backgroundColor: template.backgroundColor,
              backgroundGradientColors: template.backgroundGradientColors,
              backgroundGradientRotation: template.backgroundGradientRotation,
              backgroundImage: template.backgroundImage,
              enableFrame: template.enableFrame,
              frameImage: template.frameImage,
              templateIndex: widget.showEditButton ? _currentIndex : null,
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
    return Scaffold(
      body: Stack(
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
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        // Input Area
                        Container(
                          padding: const EdgeInsets.all(32.0),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: textController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Type something...',
                            ),
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
            bottom: 0,
            left: 0,
            right: 0,
            child: BlurContainerWidget(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  if (widget.showEditButton)
                    Expanded(
                      child: NeonButton(
                        type: NeonButtonType.secondary,
                        onPressed: _navigateToEdit,
                        size: NeonButtonSize.large,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    ),
                  if (widget.showEditButton) const SizedBox(width: 16),
                  Expanded(
                    child: NeonButton(
                      onPressed: _navigateToPlay,
                      size: NeonButtonSize.large,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.play_arrow, size: 18),
                          SizedBox(width: 8),
                          Text('Play'),
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
    );
  }
}
