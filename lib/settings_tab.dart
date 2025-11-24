import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Language selection
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text('Rate App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Rate App
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Feedback
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Share App
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Privacy Policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Terms of Service
            },
          ),
        ],
      ),
    );
  }
}
