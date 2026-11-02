// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publishing_batch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaAsset _$MediaAssetFromJson(Map<String, dynamic> json) => _MediaAsset(
  id: json['id'] as String,
  name: json['name'] as String,
  uri: json['uri'] as String,
  mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
  isUploaded: json['isUploaded'] as bool? ?? false,
);

Map<String, dynamic> _$MediaAssetToJson(_MediaAsset instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uri': instance.uri,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'isUploaded': instance.isUploaded,
    };

const _$MediaTypeEnumMap = {
  MediaType.text: 'text',
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.carousel: 'carousel',
  MediaType.reel: 'reel',
  MediaType.link: 'link',
};

_PublishingBatch _$PublishingBatchFromJson(Map<String, dynamic> json) =>
    _PublishingBatch(
      id: json['id'] as String,
      caption: json['caption'] as String,
      destinationIds:
          (json['destinationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      media:
          (json['media'] as List<dynamic>?)
              ?.map((e) => MediaAsset.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <MediaAsset>[],
      status:
          $enumDecodeNullable(_$PublishingStatusEnumMap, json['status']) ??
          PublishingStatus.draft,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PublishingBatchToJson(_PublishingBatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'caption': instance.caption,
      'destinationIds': instance.destinationIds,
      'media': instance.media,
      'status': _$PublishingStatusEnumMap[instance.status]!,
      'progress': instance.progress,
    };

const _$PublishingStatusEnumMap = {
  PublishingStatus.draft: 'draft',
  PublishingStatus.queued: 'queued',
  PublishingStatus.publishing: 'publishing',
  PublishingStatus.completed: 'completed',
  PublishingStatus.failed: 'failed',
};
