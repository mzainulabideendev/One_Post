import 'package:flutter/material.dart';

import '../core/config/app_config.dart';
import '../core/widgets/app_configuration_screen.dart';
import 'router.dart';
import 'theme.dart';

class OnePostApp extends StatefulWidget {
  const OnePostApp({
    super.key,
    required this.onboardingComplete,
    this.initializationError,
  });

  final bool onboardingComplete;
  final String? initializationError;

  @override
  State<OnePostApp> createState() => _OnePostAppState();
}

class _OnePostAppState extends State<OnePostApp> {
  late final AppRouter _appRouter = AppRouter(
    initialOnboardingComplete: widget.onboardingComplete,
  );

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isBackendConfigured || widget.initializationError != null) {
      return MaterialApp(
        title: AppConfig.appName,
        theme: OnePostTheme.theme,
        debugShowCheckedModeBanner: false,
        home: AppConfigurationScreen(error: widget.initializationError),
      );
    }

    return MaterialApp.router(
      title: AppConfig.appName,
      routerConfig: _appRouter.router,
      theme: OnePostTheme.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
