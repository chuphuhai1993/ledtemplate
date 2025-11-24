import 'package:flutter/material.dart';
import 'dart:async';
import 'models/template.dart';
import 'result_page.dart';
import 'data/user_data.dart';

class SavingPage extends StatefulWidget {
  final Template template;
  final int? templateIndex;

  const SavingPage({super.key, required this.template, this.templateIndex});

  @override
  State<SavingPage> createState() => _SavingPageState();
}

class _SavingPageState extends State<SavingPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        if (widget.templateIndex != null) {
          await UserData.updateTemplate(widget.templateIndex!, widget.template);
        } else {
          await UserData.addTemplate(widget.template);
        }
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ResultPage(template: widget.template),
            ),
          );
        }
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
