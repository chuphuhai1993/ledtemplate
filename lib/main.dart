import 'package:flutter/material.dart';
import 'splash_page.dart';
import 'data/user_data.dart';
import 'app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LED Scroller',
      theme: AppTheme.darkTheme,
      home: const SplashPage(),
    );
  }
}
