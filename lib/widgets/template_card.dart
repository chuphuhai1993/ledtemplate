import 'package:flutter/material.dart';
import '../models/template.dart';

class TemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final bool showMoreButton;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    this.width,
    this.height,
    this.showMoreButton = false,
    this.onEdit,
    this.onDelete,
  });

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit?.call();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete?.call();
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 16 / 7.5,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Stack(
            children: [
              ClipRRect(
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
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
              if (showMoreButton)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () => _showMoreOptions(context),
                      borderRadius: BorderRadius.circular(20),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
