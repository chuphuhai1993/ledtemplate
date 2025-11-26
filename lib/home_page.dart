import 'package:flutter/material.dart';
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
        iconSize: 20,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'My Templates',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,

        onTap: _onItemTapped,
      ),
    );
  }
}
