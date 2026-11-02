import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/social_account.dart';

class ProviderConnectionException implements Exception {
  const ProviderConnectionException(this.message);

  final String message;

  @override
  String toString() => message;
}

bool isTrustedProviderAuthorizationUrl(SocialProvider provider, Uri uri) {
  if (uri.scheme != 'https') return false;
  final allowedHosts = switch (provider) {
    SocialProvider.instagram => {'www.instagram.com', 'instagram.com'},
    SocialProvider.facebookPages => {'www.facebook.com', 'facebook.com'},
    SocialProvider.tiktok => {'www.tiktok.com', 'tiktok.com'},
    SocialProvider.youtube => {'accounts.google.com'},
    SocialProvider.linkedin => {'www.linkedin.com', 'linkedin.com'},
    SocialProvider.x => {'x.com', 'twitter.com'},
  };
  return allowedHosts.contains(uri.host.toLowerCase());
}

class ProviderConnectionService {
  ProviderConnectionService(this._client);

  final SupabaseClient _client;

  Future<void> connect(SocialProvider provider) async {
    if (_client.auth.currentSession == null) {
      throw const ProviderConnectionException(
        'Sign in to OnePost before connecting a social account.',
      );
    }

    try {
      final response = await _client.functions.invoke(
        'oauth-start',
        body: {'provider': _providerKey(provider)},
      );

      final payload = response.data;
      if (payload is! Map) {
        throw const ProviderConnectionException(
          'The account connection service returned an invalid response.',
        );
      }

      final authorizationUrl = payload['authorization_url'];
      if (authorizationUrl is! String) {
        final message = payload['message'];
        throw ProviderConnectionException(
          message is String
              ? message
              : 'The account connection service did not return an authorization URL.',
        );
      }

      final uri = Uri.tryParse(authorizationUrl);
      if (uri == null || !isTrustedProviderAuthorizationUrl(provider, uri)) {
        throw const ProviderConnectionException(
          'The account connection service returned an untrusted authorization URL.',
        );
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        throw const ProviderConnectionException(
          'Could not open the provider authorization page.',
        );
      }
    } on FunctionException catch (error) {
      throw ProviderConnectionException(_messageForFunctionError(error));
    } on ProviderConnectionException {
      rethrow;
    } catch (error) {
      throw ProviderConnectionException(
        'Could not start account authorization. Check your connection and try again. Details: $error',
      );
    }
  }

  String _providerKey(SocialProvider provider) {
    return switch (provider) {
      SocialProvider.instagram => 'instagram',
      SocialProvider.facebookPages => 'facebook_pages',
      SocialProvider.tiktok => 'tiktok',
      SocialProvider.youtube => 'youtube',
      SocialProvider.linkedin => 'linkedin',
      SocialProvider.x => 'x',
    };
  }

  String _messageForFunctionError(FunctionException error) {
    if (error.status <= 0) {
      return 'OnePost could not reach the account connection service. Check your internet connection and try again. '
          'No account was connected.';
    }
    if (error.status == 404) {
      return 'Account connection is not enabled yet: the Supabase oauth-start function is not deployed. '
          'No account was connected. Deploy the server OAuth functions and configure provider credentials first.';
    }
    if (error.status == 401 || error.status == 403) {
      return 'Your OnePost session is missing or expired. Sign in again before connecting an account.';
    }
    if (error.status == 429) {
      return 'Account authorization is temporarily rate-limited. Wait before trying again.';
    }

    final details = error.details;
    if (details is Map && details['message'] is String) {
      return details['message'] as String;
    }
    return 'The account connection service could not start authorization (HTTP ${error.status}). No account was connected.';
  }
}

final providerConnectionServiceProvider = Provider<ProviderConnectionService>(
  (ref) => ProviderConnectionService(Supabase.instance.client),
);
