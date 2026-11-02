// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_capabilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProviderCapabilities _$ProviderCapabilitiesFromJson(
  Map<String, dynamic> json,
) => _ProviderCapabilities(
  provider: $enumDecode(_$SocialProviderEnumMap, json['provider']),
  supportedMediaTypes:
      (json['supportedMediaTypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  maxCaptionLength: (json['maxCaptionLength'] as num?)?.toInt() ?? 280,
  supportsOAuth: json['supportsOAuth'] as bool? ?? false,
  supportsVideo: json['supportsVideo'] as bool? ?? false,
  restrictions:
      (json['restrictions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$ProviderCapabilitiesToJson(
  _ProviderCapabilities instance,
) => <String, dynamic>{
  'provider': _$SocialProviderEnumMap[instance.provider]!,
  'supportedMediaTypes': instance.supportedMediaTypes,
  'maxCaptionLength': instance.maxCaptionLength,
  'supportsOAuth': instance.supportsOAuth,
  'supportsVideo': instance.supportsVideo,
  'restrictions': instance.restrictions,
};

const _$SocialProviderEnumMap = {
  SocialProvider.instagram: 'instagram',
  SocialProvider.facebookPages: 'facebookPages',
  SocialProvider.tiktok: 'tiktok',
  SocialProvider.youtube: 'youtube',
  SocialProvider.linkedin: 'linkedin',
  SocialProvider.x: 'x',
};
