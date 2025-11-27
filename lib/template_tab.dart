import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/neon_button.dart';
import 'package:ledtemplate/widgets/pro_button_widget.dart';
import 'preview_page.dart';
import 'data/template_data.dart';
import 'editor_page.dart';

import 'widgets/preview_widget.dart';

class TemplateTab extends StatefulWidget {
  const TemplateTab({super.key});

  @override
  State<TemplateTab> createState() => _TemplateTabState();
}

class _TemplateTabState extends State<TemplateTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final categories = TemplateData.categories;
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = TemplateData.categories;

    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              // SliverAppBar
              SliverAppBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                scrolledUnderElevation: 0.0,
                floating: true,
                pinned: false,
                snap: true,
                expandedHeight: 0,
                forceElevated: true,
                title: const Text('LED Scroller'),
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
              // Create New Button (hides when scrolling)
              SliverToBoxAdapter(
                child: Padding(
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
              // Sticky TabBar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
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
                        categories
                            .map((category) => Tab(text: category.name))
                            .toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children:
                categories.map((category) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
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
                              enableEffect: false,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }
}

// Custom delegate for sticky TabBar
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
