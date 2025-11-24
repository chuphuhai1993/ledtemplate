import 'package:flutter/material.dart';
import '../models/template.dart';
import 'preview_widget.dart';

class MessageInputWidget extends StatelessWidget {
  final Template template;
  final TextEditingController textController;

  const MessageInputWidget({
    super.key,
    required this.template,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Preview Area
        PreviewWidget(template: template, text: textController.text, showPhoneFrame: true),

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
                  controller: textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Type something...',
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
