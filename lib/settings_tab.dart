import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ledtemplate/widgets/neon_button.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'data/user_data.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar
            SliverAppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              scrolledUnderElevation: 0.0,
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 0,
              forceElevated: true,
              title: const Text('Cài đặt'),
              centerTitle: false,
            ),
            // Sticky Upgrade to Pro Banner
            SliverPersistentHeader(
              pinned: true,
              delegate: _UpgradeBannerDelegate(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF0090), Color(0xFFFF6F00)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/proIcon.svg',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Upgrade to pro to use full features and remove ads.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        NeonButton(
                          size: NeonButtonSize.small,
                          type: NeonButtonType.tertiary,
                          onPressed: () {
                            // TODO: Navigate to upgrade page
                          },
                          child: const Text(
                            'Upgrade',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hệ thống Section
                  _SectionHeader(title: 'Hệ thống'),
                  _SettingItem(
                    title: 'Language',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'English',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('🇬🇧', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    onTap: () {
                      // TODO: Implement Language selection
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 8,
                    height: 8,
                  ),
                  const SizedBox(height: 24),

                  // Dữ liệu Section
                  _SectionHeader(title: 'Dữ liệu'),
                  _SettingItem(
                    title: 'Export templates',
                    trailing: Icon(
                      Icons.file_download_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    onTap: () => _exportTemplates(context),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 8,
                    height: 8,
                  ),
                  const SizedBox(height: 24),

                  // Đóng góp Section
                  _SectionHeader(title: 'Đóng góp'),
                  _SettingItem(
                    title: 'Rate us',
                    onTap: () {
                      // TODO: Implement Rate us
                    },
                  ),
                  _SettingItem(
                    title: 'Feedback',
                    onTap: () {
                      // TODO: Implement Feedback
                    },
                  ),
                  _SettingItem(
                    title: 'Share app',
                    onTap: () {
                      // TODO: Implement Share app
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surface,
                    thickness: 8,
                    height: 8,
                  ),
                  const SizedBox(height: 24),

                  // Bảo mật Section
                  _SectionHeader(title: 'Bảo mật'),
                  _SettingItem(
                    title: 'Privacy policy',
                    onTap: () {
                      // TODO: Implement Privacy policy
                    },
                  ),
                  _SettingItem(
                    title: 'Term of service',
                    onTap: () {
                      // TODO: Implement Term of service
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportTemplates(BuildContext context) async {
    try {
      // Get user templates
      final templates = UserData.savedTemplates.value;

      if (templates.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No templates to export'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return;
      }

      // Convert to JSON
      final jsonData = {
        'templates': templates.map((template) => template.toJson()).toList(),
        'exportedAt': DateTime.now().toIso8601String(),
        'version': '1.0',
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      // Save to temporary file
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/my_templates_$timestamp.json');
      await file.writeAsString(jsonString);

      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'My LED Templates',
        text: 'Export of ${templates.length} template(s)',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${templates.length} template(s)'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}

// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

// Setting Item Widget
class _SettingItem extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingItem({required this.title, this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
      onTap: onTap,
    );
  }
}

// Custom delegate for sticky upgrade banner
class _UpgradeBannerDelegate extends SliverPersistentHeaderDelegate {
  const _UpgradeBannerDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 104;

  @override
  double get maxExtent => 104;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_UpgradeBannerDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
