import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/app_config.dart';
import '../../../core/widgets/onepost_mark.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.onShowOnboarding});

  final Future<void> Function() onShowOnboarding;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const OnePostMark(size: 44),
              title: Text(user?.email ?? 'Signed-in user'),
              subtitle: Text('User ID: ${user?.id ?? 'Unavailable'}'),
            ),
          ),
          const SizedBox(height: 14),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link_rounded),
              title: const Text('Manage connected accounts'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/accounts'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy and account deletion'),
              subtitle: const Text(
                'Contact your service administrator to request data export or deletion.',
              ),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text(AppConfig.appName),
              subtitle: const Text('Version 1.0.0 · Backend-configured build'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.slideshow_outlined),
              title: const Text('Show onboarding again'),
              subtitle: const Text('Replay the welcome introduction.'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                try {
                  await onShowOnboarding();
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Could not reset onboarding: $error'),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) context.go('/sign-in');
            },
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
