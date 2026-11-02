import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/router.dart';
import 'core/config/app_config.dart';
import 'core/security/secure_auth_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? initializationError;
  var onboardingComplete = false;

  try {
    onboardingComplete = await AppRouter.readOnboardingCompletion();
  } catch (error) {
    initializationError = 'Could not load local app settings: $error';
  }

  if (AppConfig.isBackendConfigured && initializationError == null) {
    try {
      final secureStorage = SecureAuthStorage();
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        publishableKey: AppConfig.supabasePublishableKey,
        authOptions: FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
          localStorage: secureStorage,
          pkceAsyncStorage: secureStorage,
        ),
      );
    } catch (error) {
      initializationError = error.toString();
    }
  }

  runApp(
    ProviderScope(
      child: OnePostApp(
        onboardingComplete: onboardingComplete,
        initializationError: initializationError,
      ),
    ),
  );
}
