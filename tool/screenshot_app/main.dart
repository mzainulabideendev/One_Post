// Development-only entry point used to capture the README screenshots.
//
// It mounts the real OnePost screens with the real theme and router, but
// replaces the two Supabase-backed list providers with static data and skips
// the sign-in redirect so each screen can be opened directly in a browser.
//
// This file is not part of the shipped app. Build it with:
//   flutter build web -t tool/screenshot_app/main.dart
//
// The static drafts below exist only for layout previews. No social account is
// fabricated: the account screens intentionally show their real empty state.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:onepost/app/theme.dart';
import 'package:onepost/features/authentication/screens/auth_screen.dart';
import 'package:onepost/features/authentication/screens/onboarding_screen.dart';
import 'package:onepost/features/composer/screens/composer_screen.dart';
import 'package:onepost/features/dashboard/screens/dashboard_screen.dart';
import 'package:onepost/features/dashboard/screens/history_screen.dart';
import 'package:onepost/features/dashboard/screens/settings_screen.dart';
import 'package:onepost/features/publishing/data/post_repository.dart';
import 'package:onepost/features/social_accounts/domain/social_account.dart';
import 'package:onepost/features/social_accounts/repositories/social_account_repository.dart';
import 'package:onepost/features/social_accounts/screens/social_accounts_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // A local, inert Supabase client so screens that touch Supabase.instance can
  // build. The preview never performs an authenticated request.
  await Supabase.initialize(
    url: 'https://preview.supabase.co',
    publishableKey: 'sb_publishable_preview_only',
  );

  final initialScreen = Uri.base.queryParameters['screen'] ?? 'welcome';

  final router = GoRouter(
    initialLocation: '/$initialScreen',
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => OnboardingScreen(onComplete: () async {}),
      ),
      GoRoute(path: '/sign-in', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/accounts',
        builder: (context, state) => const SocialAccountsScreen(),
      ),
      GoRoute(
        path: '/composer',
        builder: (context, state) => const ComposerScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) =>
            SettingsScreen(onShowOnboarding: () async {}),
      ),
    ],
  );

  runApp(
    ProviderScope(
      overrides: [
        // No provider account is connected in this build; keep the real,
        // honest empty state.
        connectedAccountsProvider.overrideWith((ref) async => <SocialAccount>[]),
        recentPostsProvider.overrideWith(
          (ref) async => <PostRecord>[
            PostRecord(
              id: 'draft-preview-1',
              caption:
                  'Behind the scenes of today’s shoot. Swipe for the full set '
                  'and tell us which frame is your favourite.',
              status: 'draft',
              createdAt: DateTime(2026, 10, 28, 9, 15),
            ),
            PostRecord(
              id: 'draft-preview-2',
              caption: 'New drop lands Friday. Save this post so you don’t miss it.',
              status: 'draft',
              createdAt: DateTime(2026, 10, 24, 18, 40),
            ),
            PostRecord(
              id: 'draft-preview-3',
              caption:
                  'A short recap of the community meet-up: three cities, one '
                  'weekend, and a lot of great conversations.',
              status: 'draft',
              createdAt: DateTime(2026, 10, 19, 12, 5),
            ),
          ],
        ),
      ],
      child: MaterialApp.router(
        title: 'OnePost',
        theme: OnePostTheme.theme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    ),
  );
}
