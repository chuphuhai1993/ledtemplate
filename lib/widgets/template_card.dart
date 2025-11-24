import 'package:flutter/material.dart';
import '../models/template.dart';

class TemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
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
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      template.text,
                      style: TextStyle(
                        fontFamily: template.fontFamily,
                        color: Colors.white, // Simplified for preview
                        fontWeight: FontWeight.bold,
                        // Add stroke if enabled to make it more accurate?
                        // For now, keep it simple as per original code
                      ),
                    ),
                  ),
                  if (template.enableFrame && template.frameImage != null)
                    Positioned.fill(
                      child: Image.asset(
                        template.frameImage!,
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
