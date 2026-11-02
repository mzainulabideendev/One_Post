// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SocialAccount _$SocialAccountFromJson(Map<String, dynamic> json) =>
    _SocialAccount(
      id: json['id'] as String,
      provider: $enumDecode(_$SocialProviderEnumMap, json['provider']),
      displayName: json['displayName'] as String,
      accountId: json['accountId'] as String,
      status:
          $enumDecodeNullable(_$SocialAccountStatusEnumMap, json['status']) ??
          SocialAccountStatus.connected,
      username: json['username'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      scopes:
          (json['scopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SocialAccountToJson(_SocialAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'provider': _$SocialProviderEnumMap[instance.provider]!,
      'displayName': instance.displayName,
      'accountId': instance.accountId,
      'status': _$SocialAccountStatusEnumMap[instance.status]!,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'scopes': instance.scopes,
    };

const _$SocialProviderEnumMap = {
  SocialProvider.instagram: 'instagram',
  SocialProvider.facebookPages: 'facebookPages',
  SocialProvider.tiktok: 'tiktok',
  SocialProvider.youtube: 'youtube',
  SocialProvider.linkedin: 'linkedin',
  SocialProvider.x: 'x',
};

const _$SocialAccountStatusEnumMap = {
  SocialAccountStatus.connected: 'connected',
  SocialAccountStatus.pending: 'pending',
  SocialAccountStatus.error: 'error',
  SocialAccountStatus.disconnected: 'disconnected',
};
