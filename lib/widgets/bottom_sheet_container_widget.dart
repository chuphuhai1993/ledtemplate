import 'package:flutter/material.dart';

/// A simple reusable bottom sheet container with handle bar, optional title, and border radius
class BottomSheetContainerWidget extends StatelessWidget {
  /// The main content of the bottom sheet
  final Widget child;

  /// Optional title to display at the top of the bottom sheet
  final String? title;

  /// **NEW:** Controls whether the child should be wrapped in Expanded.
  /// Set to true when used inside DraggableScrollableSheet.
  final bool expandChild;

  /// **NEW:** Controls whether to show the handle bar.
  /// Set to true when used inside DraggableScrollableSheet.
  final bool showHandleBar;

  const BottomSheetContainerWidget({
    super.key,
    required this.child,
    this.title,
    this.expandChild =
        false, // Mặc định là false (cho showModalBottomSheet thường)
    this.showHandleBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        // **Quan trọng:** Giữ mainAxisSize.min để Container co lại
        // (trước khi Expanded ép nó mở rộng khi cần)
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          showHandleBar
              ? Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
              )
              : const SizedBox(height: 16),
          // Title (optional)
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          // Content
          if (expandChild)
            // Dành cho DraggableScrollableSheet: ListView cần chiều cao cố định
            Expanded(child: child)
          else
            // Dành cho showModalBottomSheet: Chiều cao tự động co lại
            child,
        ],
      ),
    );
  }
}
