import 'package:flutter/material.dart';
import 'preview_page.dart';
import 'data/template_data.dart';

import 'widgets/preview_widget.dart';

class TemplateTab extends StatefulWidget {
  const TemplateTab({super.key});

  @override
  State<TemplateTab> createState() => _TemplateTabState();
}

class _TemplateTabState extends State<TemplateTab> {
  bool _enableTextScroll = true;

  @override
  Widget build(BuildContext context) {
    final categories = TemplateData.categories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LED Scroller Templates'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerHeight: 0.5,
            dividerColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.2),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 1,
            labelColor: Theme.of(context).colorScheme.onSurface,
            indicatorColor: Theme.of(context).colorScheme.onSurface,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withOpacity(0.5),
            tabs:
                categories.map((category) => Tab(text: category.name)).toList(),
          ),
        ),
        body: Column(
          children: [
            // TabBarView for Categories
            Expanded(
              child: TabBarView(
                children:
                    categories.map((category) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(12.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 16 / 7.5,
                            ),
                        itemCount: category.templates.length,
                        itemBuilder: (context, index) {
                          final template = category.templates[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => PreviewPage(
                                        templates: category.templates,
                                        initialIndex: index,
                                        categoryName: category.name,
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
                          );
                        },
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
