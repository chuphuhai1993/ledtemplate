import 'package:flutter/material.dart';
import 'models/template.dart';
import 'scrolling_text_renderer.dart';
import 'play_page.dart';
import 'editor_page.dart';

class MessageInputPage extends StatefulWidget {
  final Template template;
  final bool showEditButton;

  const MessageInputPage({
    super.key,
    required this.template,
    this.showEditButton = false,
  });

  @override
  State<MessageInputPage> createState() => _MessageInputPageState();
}

class _MessageInputPageState extends State<MessageInputPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.template.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _navigateToPlay() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => PlayPage(
              text: _textController.text,
              fontFamily: widget.template.fontFamily,
              fontSize: widget.template.fontSize,
              enableStroke: widget.template.enableStroke,
              strokeWidth: widget.template.strokeWidth,
              strokeColor: widget.template.strokeColor,
              enableOutline: widget.template.enableOutline,
              outlineWidth: widget.template.outlineWidth,
              outlineBlur: widget.template.outlineBlur,
              outlineColor: widget.template.outlineColor,
              enableShadow: widget.template.enableShadow,
              shadowOffsetX: widget.template.shadowOffsetX,
              shadowOffsetY: widget.template.shadowOffsetY,
              shadowBlur: widget.template.shadowBlur,
              shadowColor: widget.template.shadowColor,
              scrollDirection: widget.template.scrollDirection,
              scrollSpeed: widget.template.scrollSpeed,
              backgroundColor: widget.template.backgroundColor,
              backgroundImage: widget.template.backgroundImage,
              enableFrame: widget.template.enableFrame,
              frameImage: widget.template.frameImage,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Message'),
        actions: [
          if (widget.showEditButton)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditorPage(template: widget.template),
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Preview Area (Top Half)
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    widget.template.backgroundImage == null
                        ? widget.template.backgroundColor
                        : null,
                image:
                    widget.template.backgroundImage != null
                        ? DecorationImage(
                          image: AssetImage(widget.template.backgroundImage!),
                          fit: BoxFit.cover,
                        )
                        : null,
              ),
              child: Stack(
                children: [
                  ScrollingTextRenderer(
                    text: _textController.text,
                    fontFamily: widget.template.fontFamily,
                    fontSize: widget.template.fontSize,
                    enableStroke: widget.template.enableStroke,
                    strokeWidth: widget.template.strokeWidth,
                    strokeColor: widget.template.strokeColor,
                    enableOutline: widget.template.enableOutline,
                    outlineWidth: widget.template.outlineWidth,
                    outlineBlur: widget.template.outlineBlur,
                    outlineColor: widget.template.outlineColor,
                    enableShadow: widget.template.enableShadow,
                    shadowOffsetX: widget.template.shadowOffsetX,
                    shadowOffsetY: widget.template.shadowOffsetY,
                    shadowBlur: widget.template.shadowBlur,
                    shadowColor: widget.template.shadowColor,
                    scrollDirection: widget.template.scrollDirection,
                    scrollSpeed: widget.template.scrollSpeed,
                  ),
                  if (widget.template.enableFrame &&
                      widget.template.frameImage != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Image.asset(
                          widget.template.frameImage!,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Input Area (Bottom Half)
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
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToPlay,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Play'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
