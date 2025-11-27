import 'package:flutter/material.dart';
import 'package:ledtemplate/widgets/app_text_field_widget.dart';
import 'widgets/neon_button.dart';
import 'data/user_data.dart';
import 'data/template_data.dart';
import 'home_page.dart';
import 'play_page.dart';
import 'models/template.dart';
import 'widgets/preview_widget.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late TabController _tabController;
  Template? _selectedTemplate;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: TemplateData.categories.length,
      vsync: this,
    );
    if (TemplateData.categories.isNotEmpty &&
        TemplateData.categories.first.templates.isNotEmpty) {
      _selectedTemplate = TemplateData.categories.first.templates.first;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _messageController.dispose();
    _focusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPlayPressed(Template template) async {
    // Mark onboarding as complete
    await UserData.completeOnboarding();

    if (!mounted) return;

    // Navigate to play page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (context) => PlayPage(
              text:
                  _messageController.text.isEmpty
                      ? template.text
                      : _messageController.text,
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
              shadowGradientColors: template.shadowGradientColors,
              shadowGradientRotation: template.shadowGradientRotation,
              scrollDirection: template.scrollDirection,
              scrollSpeed: template.scrollSpeed,
              enableBlink: template.enableBlink,
              blinkDuration: template.blinkDuration,
              backgroundColor: template.backgroundColor,
              backgroundGradientColors: template.backgroundGradientColors,
              backgroundGradientRotation: template.backgroundGradientRotation,
              backgroundImage: template.backgroundImage,
              enableFrame: template.enableFrame,
              frameImage: template.frameImage,
              enableFrameGlow: template.enableFrameGlow,
              frameGlowSize: template.frameGlowSize,
              frameGlowBlur: template.frameGlowBlur,
              frameGlowBorderRadius: template.frameGlowBorderRadius,
              frameGlowColor: template.frameGlowColor,
              textColor: template.textColor,
              enableScroll: template.enableScroll,
              enableBounceZoom: template.enableBounceZoom,
              enableBounce: template.enableBounce,
              bounceDirection: template.bounceDirection,
              zoomLevel: template.zoomLevel,
              zoomSpeed: template.zoomSpeed,
              bounceLevel: template.bounceLevel,
              bounceSpeed: template.bounceSpeed,
              enableRotationBounce: template.enableRotationBounce,
              rotationStart: template.rotationStart,
              rotationEnd: template.rotationEnd,
              rotationSpeed: template.rotationSpeed,
              onClose: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Page indicator
            ClipRRect(
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 3,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onSurface,
                ),
                minHeight: 2,
              ),
            ),

            // PageView
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  if (index == 1) {
                    // Request focus when moving to page 2
                    _focusNode.requestFocus();
                  } else {
                    // Unfocus when leaving page 2
                    _focusNode.unfocus();
                  }
                },
                children: [_buildPage1(), _buildPage2(), _buildPage3()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/icon_app.png', width: 100, height: 100),
          const SizedBox(height: 40),
          Text(
            'Welcome to Super Neon',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'Create stunning Neon banner for concerts, events, or just for fun!',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          NeonButton(
            onPressed: _nextPage,
            size: NeonButtonSize.large,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter Your Message',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          AppTextFieldWidget(
            controller: _messageController,
            hintText: 'Enter your message here...',
            maxLines: 1,
            focusNode: _focusNode,
          ),
          const SizedBox(height: 60),
          NeonButton(
            onPressed: _nextPage,
            size: NeonButtonSize.large,
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    final categories = TemplateData.categories;

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
                      child: Text(
                        'Select a Template',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
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
                      Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ];
              },
              body: Stack(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children:
                          categories.map((category) {
                            return GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 24,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 16 / 7.5,
                                  ),
                              itemCount: category.templates.length,
                              itemBuilder: (context, index) {
                                final template = category.templates[index];
                                final isSelected =
                                    _selectedTemplate == template;
                                return ValueListenableBuilder<String>(
                                  valueListenable: UserData.defaultPhoneAsset,
                                  builder: (context, phoneAsset, child) {
                                    return ValueListenableBuilder<
                                      TextEditingValue
                                    >(
                                      valueListenable: _messageController,
                                      builder: (context, messageValue, child) {
                                        final displayText =
                                            messageValue.text.isEmpty
                                                ? template.text
                                                : messageValue.text;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedTemplate = template;
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                              border: Border.all(
                                                color:
                                                    isSelected
                                                        ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                        : Colors.transparent,
                                                width: 2,
                                              ),
                                              color:
                                                  isSelected
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withOpacity(0.2)
                                                      : Colors.transparent,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                    vertical: 2,
                                                  ),
                                              child: PreviewWidget(
                                                template: template,
                                                text: displayText,
                                                showPhoneFrame: true,
                                                phoneAsset: phoneAsset,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: NeonButton(
                      onPressed:
                          _selectedTemplate != null
                              ? () => _onPlayPressed(_selectedTemplate!)
                              : null,
                      size: NeonButtonSize.large,
                      child: const Text('Play'),
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
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _StickyTabBarDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return _tabBar != oldDelegate._tabBar ||
        _backgroundColor != oldDelegate._backgroundColor;
  }
}
