import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/pro_button_widget.dart';
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
      body: ValueListenableBuilder<List<Template>>(
        valueListenable: UserData.savedTemplates,
        builder: (context, templates, child) {
          if (templates.isEmpty) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    scrolledUnderElevation: 0.0,
                    floating: true,
                    pinned: false,
                    snap: true,
                    expandedHeight: 0,
                    forceElevated: true,
                    title: const Text('My Templates'),
                    centerTitle: false,
                    actions: [
                      ProButtonWidget(
                        onPressed: () {
                          // TODO: Navigate to Pro page or show Pro features
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có template nào, tạo template đầu tiên',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          NeonButton(
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
                                const SizedBox(width: 8),
                                const Text('Create New'),
                              ],
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

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // SliverAppBar
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  scrolledUnderElevation: 0.0,
                  floating: true,
                  pinned: false,
                  snap: true,
                  expandedHeight: 0,
                  forceElevated: true,
                  title: const Text('My Templates'),
                  centerTitle: false,
                  actions: [
                    ProButtonWidget(
                      onPressed: () {
                        // TODO: Navigate to Pro page or show Pro features
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                // Sticky Create New Button
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyButtonDelegate(
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                            const SizedBox(width: 8),
                            const Text('Create New'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Grid of Templates
                SliverPadding(
                  padding: const EdgeInsets.all(12.0),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 16 / 7.5,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                                                      foregroundColor:
                                                          Colors.red,
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
                    }, childCount: templates.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Custom delegate for sticky Create New button
class _StickyButtonDelegate extends SliverPersistentHeaderDelegate {
  const _StickyButtonDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 88;

  @override
  double get maxExtent => 88;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyButtonDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
