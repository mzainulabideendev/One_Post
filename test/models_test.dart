import 'package:flutter_test/flutter_test.dart';
import 'package:onepost/features/social_accounts/domain/provider_capabilities.dart';
import 'package:onepost/features/social_accounts/domain/social_account.dart';
import 'package:onepost/features/publishing/domain/publishing_batch.dart';

void main() {
  group('OnePost models', () {
    test('SocialAccount JSON round-trip works', () {
      final json = {
        'id': 'account_1',
        'provider': 'instagram',
        'displayName': 'Studio Profile',
        'accountId': 'ig_123',
        'status': 'connected',
        'username': 'studio',
        'avatarUrl': '',
        'scopes': ['instagram_basic'],
      };

      final account = SocialAccount.fromJson(json);
      expect(account.displayName, 'Studio Profile');
      expect(account.provider, SocialProvider.instagram);
      expect(account.scopes, ['instagram_basic']);
    });

    test('Provider capabilities include restrictions', () {
      const caps = ProviderCapabilities(
        provider: SocialProvider.youtube,
        supportedMediaTypes: ['video'],
        maxCaptionLength: 5000,
        supportsOAuth: true,
        supportsVideo: true,
        restrictions: {'visibility': 'User must select visibility'},
      );

      expect(caps.supportsVideo, isTrue);
      expect(caps.restrictions['visibility'], 'User must select visibility');
    });

    test('PublishingBatch handles queued status', () {
      const batch = PublishingBatch(
        id: 'batch_1',
        caption: 'hello world',
        destinationIds: ['ig', 'x'],
        media: [],
        status: PublishingStatus.queued,
      );

      expect(batch.status, PublishingStatus.queued);
      expect(batch.destinationIds.length, 2);
    });
  });
}
