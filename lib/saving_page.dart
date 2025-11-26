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

class _SavingPageState extends State<SavingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    // Save template after 3 seconds
    Timer(const Duration(seconds: 2), () async {
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: Stack(
                      children: [
                        // Background
                        Container(
                          width: double.infinity,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.1),
                        ),
                        // Progress with gradient
                        FractionallySizedBox(
                          widthFactor: _animation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.6),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Saving Text
                const Text(
                  'Saving...',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
