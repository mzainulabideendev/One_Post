import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_account.freezed.dart';
part 'social_account.g.dart';

enum SocialProvider {
  instagram,
  facebookPages,
  tiktok,
  youtube,
  linkedin,
  x,
}

enum SocialAccountStatus {
  connected,
  pending,
  error,
  disconnected,
}

@freezed
abstract class SocialAccount with _$SocialAccount {
  const factory SocialAccount({
    required String id,
    required SocialProvider provider,
    required String displayName,
    required String accountId,
    @Default(SocialAccountStatus.connected) SocialAccountStatus status,
    @Default('') String username,
    @Default('') String avatarUrl,
    @Default(<String>[]) List<String> scopes,
  }) = _SocialAccount;

  factory SocialAccount.fromJson(Map<String, dynamic> json) =>
      _$SocialAccountFromJson(json);
}

extension SocialProviderDisplay on SocialProvider {
  String get label {
    switch (this) {
      case SocialProvider.instagram:
        return 'Instagram';
      case SocialProvider.facebookPages:
        return 'Facebook Pages';
      case SocialProvider.tiktok:
        return 'TikTok';
      case SocialProvider.youtube:
        return 'YouTube';
      case SocialProvider.linkedin:
        return 'LinkedIn';
      case SocialProvider.x:
        return 'X';
    }
  }
}
