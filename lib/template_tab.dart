import 'package:flutter/material.dart';
import 'editor_page.dart';
import 'message_input_page.dart';
import 'data/template_data.dart';

import 'widgets/template_card.dart';

class TemplateTab extends StatefulWidget {
  const TemplateTab({super.key});

  @override
  State<TemplateTab> createState() => _TemplateTabState();
}

class _TemplateTabState extends State<TemplateTab> {
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    final categories = TemplateData.categories;
    final currentCategory = categories[_selectedCategoryIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('LED Scroller Templates')),
      body: Column(
        children: [
          // Create New Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditorPage()),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'Create New',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // Category Selector (Segmented Control style)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: List.generate(categories.length, (index) {
                final isSelected = index == _selectedCategoryIndex;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(categories[index].name),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      }
                    },
                    selectedColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // Templates Grid (1 Column)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 16 / 9,
              ),
              itemCount: currentCategory.templates.length,
              itemBuilder: (context, index) {
                final template = currentCategory.templates[index];
                return TemplateCard(
                  template: template,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => MessageInputPage(template: template),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
