import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/bottom_sheet_container_widget.dart';
import 'package:ledtemplate/widgets/neon_button.dart';

/// A reusable bottom sheet for entering text messages
/// Used in both PreviewPage and EditorPage
class MessageInputBottomSheet extends StatefulWidget {
  /// Initial text to display in the text field
  final String initialText;

  /// Label for the action button (e.g., "Play", "Save")
  final String buttonLabel;

  const MessageInputBottomSheet({
    super.key,
    required this.initialText,
    required this.buttonLabel,
  });

  @override
  State<MessageInputBottomSheet> createState() =>
      _MessageInputBottomSheetState();
}

class _MessageInputBottomSheetState extends State<MessageInputBottomSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.95,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return BottomSheetContainerWidget(
          title: 'Enter message',
          expandChild: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                // Text Display Area
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.0,
                        vertical: 24.0,
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter message',
                          hintStyle: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(
                              context,
                            ).colorScheme.onBackground.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Action Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: 160,
                    child: NeonButton(
                      size: NeonButtonSize.large,
                      type: NeonButtonType.primary,
                      onPressed: () {
                        Navigator.pop(context, _controller.text);
                      },
                      child: Text(widget.buttonLabel),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
