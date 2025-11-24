import 'package:flutter/material.dart';
import 'models/template.dart';
import 'widgets/message_input_widget.dart';
import 'play_page.dart';
import 'editor_page.dart';

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
              scrollDirection: template.scrollDirection,
              scrollSpeed: template.scrollSpeed,
              backgroundColor: template.backgroundColor,
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
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          // Swipe hint
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.swipe_vertical, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Swipe to explore templates',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // PageView with MessageInputWidget
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: widget.templates.length,
              itemBuilder: (context, index) {
                return MessageInputWidget(
                  template: widget.templates[index],
                  textController: _textControllers[index],
                );
              },
            ),
          ),

          // Buttons
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Row(
              children: [
                if (widget.showEditButton)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _navigateToEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                if (widget.showEditButton) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _navigateToPlay,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
