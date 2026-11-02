import 'package:freezed_annotation/freezed_annotation.dart';

import 'social_account.dart';

part 'provider_capabilities.freezed.dart';
part 'provider_capabilities.g.dart';

enum MediaType {
  text,
  image,
  video,
  carousel,
  reel,
  link,
}

@freezed
abstract class ProviderCapabilities with _$ProviderCapabilities {
  const factory ProviderCapabilities({
    required SocialProvider provider,
    @Default(<String>[]) List<String> supportedMediaTypes,
    @Default(280) int maxCaptionLength,
    @Default(false) bool supportsOAuth,
    @Default(false) bool supportsVideo,
    @Default(<String, String>{}) Map<String, String> restrictions,
  }) = _ProviderCapabilities;

  factory ProviderCapabilities.fromJson(Map<String, dynamic> json) =>
      _$ProviderCapabilitiesFromJson(json);
}
