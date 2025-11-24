import 'package:flutter/material.dart';
import 'models/template.dart';
import 'scrolling_text_renderer.dart';
import 'play_page.dart';
import 'editor_page.dart';

class MessageInputPage extends StatefulWidget {
  final List<Template> templates; // List of templates in category
  final int initialIndex; // Starting template index
  final String categoryName; // Category name for title
  final bool showEditButton;
  final int?
  templateIndex; // Index in UserData.savedTemplates if from My Templates

  const MessageInputPage({
    super.key,
    required this.templates,
    required this.initialIndex,
    required this.categoryName,
    this.showEditButton = false,
    this.templateIndex,
  });

  @override
  State<MessageInputPage> createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  late PageController _pageController;
  late int _currentIndex;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _textController = TextEditingController(
      text: widget.templates[widget.initialIndex].text,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _textController.text = widget.templates[index].text;
    });
  }

  void _navigateToPlay() {
    final template = widget.templates[_currentIndex];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PlayPage(
              text: _textController.text,
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
            ),
      ),
    );
  }

  void _navigateToEdit() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => EditorPage(
              template: widget.templates[_currentIndex],
              templateIndex: widget.templateIndex,
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

          // Preview Area with PageView
          Expanded(
            flex: 2,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: widget.templates.length,
              itemBuilder: (context, index) {
                final template = widget.templates[index];
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        template.backgroundImage == null
                            ? template.backgroundColor
                            : null,
                    image:
                        template.backgroundImage != null
                            ? DecorationImage(
                              image: AssetImage(template.backgroundImage!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child: Stack(
                    children: [
                      ScrollingTextRenderer(
                        text: _textController.text,
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
                      ),
                      if (template.enableFrame && template.frameImage != null)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Image.asset(
                              template.frameImage!,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Area
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter your message:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Type something...',
                    ),
                    style: const TextStyle(fontSize: 20),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  // Buttons row
                  Row(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
