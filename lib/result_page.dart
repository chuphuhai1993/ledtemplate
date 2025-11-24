import 'package:flutter/material.dart';
import 'models/template.dart';
import 'play_page.dart';
import 'editor_page.dart';

class ResultPage extends StatelessWidget {
  final Template template;

  const ResultPage({super.key, required this.template});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'Success!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Your template has been saved.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 48),

              // Play Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => PlayPage(
                              text: template.text,
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
                              fromResultPage: true,
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Create New Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const EditorPage(),
                      ),
                      (route) =>
                          route.isFirst, // Keep Home at bottom? Or just push?
                      // User said "Create New", usually implies starting fresh.
                      // Let's push a fresh EditorPage.
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create New'),
                ),
              ),
              const SizedBox(height: 16),

              // Home Button
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
