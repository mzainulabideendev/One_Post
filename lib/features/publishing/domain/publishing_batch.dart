import 'package:freezed_annotation/freezed_annotation.dart';

import '../../social_accounts/domain/provider_capabilities.dart';

part 'publishing_batch.freezed.dart';
part 'publishing_batch.g.dart';

enum PublishingStatus {
  draft,
  queued,
  publishing,
  completed,
  failed,
}

@freezed
abstract class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    required String id,
    required String name,
    required String uri,
    required MediaType mediaType,
    @Default(false) bool isUploaded,
  }) = _MediaAsset;

  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);
}

@freezed
abstract class PublishingBatch with _$PublishingBatch {
  const factory PublishingBatch({
    required String id,
    required String caption,
    @Default(<String>[]) List<String> destinationIds,
    @Default(<MediaAsset>[]) List<MediaAsset> media,
    @Default(PublishingStatus.draft) PublishingStatus status,
    @Default(0) int progress,
  }) = _PublishingBatch;

  factory PublishingBatch.fromJson(Map<String, dynamic> json) =>
      _$PublishingBatchFromJson(json);
}
