import 'package:supabase_flutter/supabase_flutter.dart';

String authErrorMessage(AuthException error) {
  final normalized = error.message.toLowerCase();
  final statusCode = error.statusCode;
  final isRateLimited = statusCode == '429' ||
      normalized.contains('rate limit') ||
      normalized.contains('rate_limit') ||
      normalized.contains('too many requests');

  if (isRateLimited) {
    return 'Email sending is temporarily rate-limited. Wait before requesting another email. '
        'For a lasting fix, configure a custom SMTP provider in Supabase Auth settings.';
  }
  if (normalized.contains('invalid login credentials')) {
    return 'Email or password is incorrect.';
  }
  if (normalized.contains('email not confirmed')) {
    return 'Confirm your email using the link we sent, then sign in.';
  }

  return error.message;
}
