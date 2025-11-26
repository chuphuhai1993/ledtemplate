import 'package:flutter/material.dart';
import 'widgets/preview_widget.dart';
import 'widgets/neon_button.dart';
import 'widgets/bottom_sheet_container_widget.dart';
import 'data/user_data.dart';
import 'preview_page.dart';
import 'editor_page.dart';
import 'models/template.dart';

class MyTemplatesTab extends StatefulWidget {
  const MyTemplatesTab({super.key});

  @override
  State<MyTemplatesTab> createState() => _MyTemplatesTabState();
}

class _MyTemplatesTabState extends State<MyTemplatesTab> {
  bool _enableTextScroll = true;

  void _showMoreOptions(
    BuildContext context, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => BottomSheetContainerWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Templates')),
      body: ValueListenableBuilder<List<Template>>(
        valueListenable: UserData.savedTemplates,
        builder: (context, templates, child) {
          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có template nào, tạo template đầu tiên',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    child: NeonButton(
                      size: NeonButtonSize.large,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditorPage(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Create New',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

          return Column(
            children: [
              // Fixed Create New Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  child: NeonButton(
                    size: NeonButtonSize.large,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditorPage(),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 8),
                        Text('Create New'),
                      ],
                    ),
                  ),
                ),
              ),

              // Grid of Templates
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 16 / 7.5,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => PreviewPage(
                                      templates: templates,
                                      initialIndex: index,
                                      categoryName: 'My Templates',
                                      showEditButton: true,
                                      templateIndex: index,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.2),
                                width: 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: PreviewWidget(
                                template: template,
                                text: template.text,
                                enableTextScroll: false,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Material(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              onTap:
                                  () => _showMoreOptions(
                                    context,
                                    onEdit: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditorPage(
                                                template: template,
                                                templateIndex: index,
                                              ),
                                        ),
                                      );
                                    },
                                    onDelete: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text(
                                                'Delete Template',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this template?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    UserData.deleteTemplate(
                                                      index,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
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
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
