import 'package:flutter/material.dart';
import 'widgets/neon_button.dart';

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
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Implement Terms of Service
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Neon Button Preview'),
                const SizedBox(height: 10),
                NeonButton(
                  size: NeonButtonSize.small,
                  onPressed: () {},
                  child: const Text('Small Button'),
                ),
                const SizedBox(height: 10),
                NeonButton(
                  size: NeonButtonSize.medium,
                  onPressed: () {},
                  child: const Text('Medium Button'),
                ),
                const SizedBox(height: 10),
                NeonButton(
                  size: NeonButtonSize.large,
                  onPressed: () {},
                  child: const Text('Large Button'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
