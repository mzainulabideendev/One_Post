import 'package:flutter/material.dart';

import '../../core/config/app_config.dart';
import 'onepost_mark.dart';

class AppConfigurationScreen extends StatelessWidget {
  const AppConfigurationScreen({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const OnePostMark(size: 64),
                  const SizedBox(height: 24),
                  Text(
                    '${AppConfig.appName} needs backend setup',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This build does not contain a Supabase project URL and public client key. Authentication, account data, media storage and publishing are intentionally unavailable until your backend is configured.',
                    style: TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SelectableText(
                        'Build with:\n'
                        'flutter build apk --release '
                        '--dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co '
                        '--dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_KEY',
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Use only an HTTPS Supabase project URL and its publishable/anon key in the app. Never put a service-role key, provider secret, OAuth token or encryption key in the APK.',
                    style: TextStyle(height: 1.5, color: Colors.black54),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      'Backend initialization failed: $error',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
