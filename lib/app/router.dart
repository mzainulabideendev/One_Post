import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/authentication/screens/auth_screen.dart';
import '../features/authentication/screens/onboarding_screen.dart';
import '../features/composer/screens/composer_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/screens/history_screen.dart';
import '../features/dashboard/screens/settings_screen.dart';
import '../features/social_accounts/screens/oauth_callback_screen.dart';
import '../features/social_accounts/screens/social_accounts_screen.dart';

String? safePostLoginDestination(String? destination) {
  if (destination == null || destination.isEmpty) return null;
  final uri = Uri.tryParse(destination);
  if (uri == null ||
      uri.hasScheme ||
      uri.hasAuthority ||
      !uri.path.startsWith('/') ||
      uri.path.startsWith('//') ||
      uri.pathSegments.contains('..') ||
      uri.path == '/sign-in' ||
      uri.path == '/welcome') {
    return null;
  }
  return uri.toString();
}

class AppRouter {
  AppRouter({required bool initialOnboardingComplete})
      : _refresh = _AppRefreshListenable(
          initialOnboardingComplete: initialOnboardingComplete,
        ) {
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: _refresh,
      redirect: (context, state) {
        final signedIn =
            Supabase.instance.client.auth.currentSession != null;
        final location = state.matchedLocation;
        final isWelcome = location == '/welcome';
        final isSignIn = location == '/sign-in';

        if (!_refresh.onboardingComplete) {
          return isWelcome ? null : '/welcome';
        }
        if (signedIn && (isWelcome || isSignIn)) {
          return safePostLoginDestination(state.uri.queryParameters['next']) ??
              '/dashboard';
        }
        if (!signedIn && !isSignIn) {
          return Uri(
            path: '/sign-in',
            queryParameters: {'next': state.uri.toString()},
          ).toString();
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) =>
              _refresh.onboardingComplete ? '/dashboard' : '/welcome',
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => OnboardingScreen(
            onComplete: () async {
              final preferences = await SharedPreferences.getInstance();
              await preferences.setBool(_onboardingPreferenceKey, true);
              _refresh.completeOnboarding();
              if (context.mounted) context.go('/sign-in');
            },
          ),
        ),
        GoRoute(
          path: '/sign-in',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/accounts',
          builder: (context, state) => const SocialAccountsScreen(),
        ),
        GoRoute(
          path: '/oauth-callback',
          builder: (context, state) => OAuthCallbackScreen(
            connected: state.uri.queryParameters['status'] == 'connected',
            provider: state.uri.queryParameters['provider'] ?? '',
          ),
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
          builder: (context, state) => SettingsScreen(
            onShowOnboarding: () async {
              final preferences = await SharedPreferences.getInstance();
              await preferences.setBool(_onboardingPreferenceKey, false);
              _refresh.resetOnboarding();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ),
      ],
    );
  }

  static const _onboardingPreferenceKey = 'onepost.onboarding.completed';

  final _AppRefreshListenable _refresh;
  late final GoRouter router;

  static Future<bool> readOnboardingCompletion() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingPreferenceKey) ?? false;
  }

  void dispose() {
    router.dispose();
    _refresh.dispose();
  }
}

class _AppRefreshListenable extends ChangeNotifier {
  _AppRefreshListenable({required this.initialOnboardingComplete}) {
    _subscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  final bool initialOnboardingComplete;
  late final StreamSubscription<AuthState> _subscription;

  bool get onboardingComplete =>
      _onboardingOverride ?? initialOnboardingComplete;

  bool? _onboardingOverride;

  void completeOnboarding() {
    _onboardingOverride = true;
    notifyListeners();
  }

  void resetOnboarding() {
    _onboardingOverride = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
