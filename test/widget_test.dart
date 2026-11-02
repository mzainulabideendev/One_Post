// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:onepost/core/widgets/app_configuration_screen.dart';
import 'package:onepost/features/authentication/screens/onboarding_screen.dart';

void main() {
  testWidgets('Unconfigured build explains how to set up backend', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: AppConfigurationScreen()),
    );

    expect(find.text('OnePost needs backend setup'), findsOneWidget);
    expect(find.textContaining('SUPABASE_URL'), findsOneWidget);
    expect(find.textContaining('service-role key'), findsOneWidget);
  });

  testWidgets('Onboarding advances and completes explicitly', (tester) async {
    var completed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: OnboardingScreen(
          onComplete: () async {
            completed = true;
          },
        ),
      ),
    );

    expect(find.text('Create with clarity.'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Choose where it goes.'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Know what is ready.'), findsOneWidget);

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(completed, isTrue);
  });
}
