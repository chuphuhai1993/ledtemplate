import 'package:flutter/material.dart';
import 'widgets/template_card.dart';
import 'data/user_data.dart';
import 'message_input_page.dart';
import 'models/template.dart';

class MyTemplatesTab extends StatefulWidget {
  const MyTemplatesTab({super.key});

  @override
  State<MyTemplatesTab> createState() => _MyTemplatesTabState();
}

class _MyTemplatesTabState extends State<MyTemplatesTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Templates')),
      body: ValueListenableBuilder<List<Template>>(
        valueListenable: UserData.savedTemplates,
        builder: (context, templates, child) {
          return templates.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No templates saved yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 16 / 9,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return TemplateCard(
                    template: template,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => MessageInputPage(
                                template: template,
                                showEditButton: true,
                              ),
                        ),
                      );
                    },
                  );
                },
              );
        },
      ),
    );
  }
}
