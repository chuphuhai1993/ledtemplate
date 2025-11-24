import 'package:flutter/material.dart';
import 'dart:async';
import 'models/template.dart';
import 'result_page.dart';
import 'data/user_data.dart';

class SavingPage extends StatefulWidget {
  final Template template;

  const SavingPage({super.key, required this.template});

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        UserData.addTemplate(widget.template);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultPage(template: widget.template),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.deepPurple),
            const SizedBox(height: 24),
            Text(
              'Saving...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
