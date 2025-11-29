import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'template_tab.dart';
import 'my_templates_tab.dart';
import 'settings_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TemplateTab(),
    MyTemplatesTab(),
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/icon_template.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/icon_my_template.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'My Templates',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/icon_settings.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
      ),
    );
  }
}
