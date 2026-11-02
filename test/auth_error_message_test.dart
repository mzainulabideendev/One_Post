import 'package:flutter_test/flutter_test.dart';
import 'package:onepost/features/authentication/domain/auth_error_message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('authErrorMessage', () {
    test('explains provider email rate limits and recovery', () {
      expect(
        authErrorMessage(
          const AuthException(
            'email rate limit exceeded',
            statusCode: '429',
          ),
        ),
        contains('custom SMTP'),
      );
    });

    test('maps invalid credentials to a user-facing message', () {
      expect(
        authErrorMessage(
          const AuthException('Invalid login credentials', statusCode: '400'),
        ),
        'Email or password is incorrect.',
      );
    });
  });
}
