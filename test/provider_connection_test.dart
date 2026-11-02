import 'package:flutter_test/flutter_test.dart';
import 'package:onepost/features/social_accounts/data/provider_connection_service.dart';
import 'package:onepost/features/social_accounts/domain/social_account.dart';

void main() {
  group('provider authorization URLs', () {
    test('accepts each provider own HTTPS authorization host', () {
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.instagram,
          Uri.parse('https://www.instagram.com/oauth/authorize'),
        ),
        isTrue,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.facebookPages,
          Uri.parse('https://www.facebook.com/dialog/oauth'),
        ),
        isTrue,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.tiktok,
          Uri.parse('https://www.tiktok.com/v2/auth/authorize/'),
        ),
        isTrue,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.youtube,
          Uri.parse('https://accounts.google.com/o/oauth2/v2/auth'),
        ),
        isTrue,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.linkedin,
          Uri.parse('https://www.linkedin.com/oauth/v2/authorization'),
        ),
        isTrue,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.x,
          Uri.parse('https://x.com/i/oauth2/authorize'),
        ),
        isTrue,
      );
    });

    test('rejects insecure or unrelated hosts', () {
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.instagram,
          Uri.parse('http://www.instagram.com/oauth/authorize'),
        ),
        isFalse,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.instagram,
          Uri.parse('https://instagram.com.attacker.invalid/oauth/authorize'),
        ),
        isFalse,
      );
      expect(
        isTrustedProviderAuthorizationUrl(
          SocialProvider.youtube,
          Uri.parse('https://youtube.com/oauth'),
        ),
        isFalse,
      );
    });
  });
}
