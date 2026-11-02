import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/social_account.dart';

class SocialAccountRepository {
  SocialAccountRepository(this._client);

  final SupabaseClient _client;

  Future<List<SocialAccount>> getConnectedAccounts() async {
    final rows = await _client
        .from('social_accounts')
        .select(
          'id, provider, provider_account_id, account_name, username, '
          'avatar_url, granted_scopes, status',
        )
        .order('created_at', ascending: false);

    return rows.map((row) {
      final account = Map<String, dynamic>.from(row);
      return SocialAccount(
        id: _requiredString(account, 'id'),
        provider: _providerFromBackend(_requiredString(account, 'provider')),
        displayName: _requiredString(account, 'account_name'),
        accountId: _requiredString(account, 'provider_account_id'),
        status: _statusFromBackend(_requiredString(account, 'status')),
        username: account['username'] as String? ?? '',
        avatarUrl: account['avatar_url'] as String? ?? '',
        scopes: (account['granted_scopes'] as List<dynamic>? ?? const [])
            .map((scope) => scope.toString())
            .toList(growable: false),
      );
    }).toList(growable: false);
  }

  SocialProvider _providerFromBackend(String value) {
    return switch (value) {
      'instagram' => SocialProvider.instagram,
      'facebook_pages' => SocialProvider.facebookPages,
      'tiktok' => SocialProvider.tiktok,
      'youtube' => SocialProvider.youtube,
      'linkedin' => SocialProvider.linkedin,
      'x' => SocialProvider.x,
      _ => throw FormatException('Unknown provider value returned by backend: $value'),
    };
  }

  SocialAccountStatus _statusFromBackend(String value) {
    return switch (value) {
      'connected' => SocialAccountStatus.connected,
      'pending' => SocialAccountStatus.pending,
      'error' || 'reauth_required' => SocialAccountStatus.error,
      'disconnected' => SocialAccountStatus.disconnected,
      _ => throw FormatException('Unknown account status returned by backend: $value'),
    };
  }

  String _requiredString(Map<String, dynamic> row, String key) {
    final value = row[key];
    if (value is String && value.isNotEmpty) return value;
    throw FormatException('Backend record is missing required field "$key".');
  }
}

final socialAccountRepositoryProvider = Provider<SocialAccountRepository>(
  (ref) => SocialAccountRepository(Supabase.instance.client),
);

final connectedAccountsProvider = FutureProvider<List<SocialAccount>>((ref) {
  return ref.watch(socialAccountRepositoryProvider).getConnectedAccounts();
});
