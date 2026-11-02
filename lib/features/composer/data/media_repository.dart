import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart' show AccumulatorSink;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_error.dart';

class MediaRepository {
  MediaRepository(this._client);

  static const maxUploadBytes = MediaFilePolicy.maxUploadBytes;
  static const _bucket = 'onepost-media';

  final SupabaseClient _client;
  final Uuid _uuid = const Uuid();

  Future<void> uploadDraftAsset({
    required String postId,
    required XFile asset,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AppError('Sign in before uploading media.');
    }

    final file = File(asset.path);
    final size = await file.length();
    MediaFilePolicy.validateSize(size);

    final inspected = await _inspectFile(file);
    final objectPath = '$userId/${_uuid.v4()}.${inspected.extension}';
    final checksum = await _checksum(file);
    var uploaded = false;

    try {
      await _client.storage.from(_bucket).upload(
            objectPath,
            file,
            fileOptions: FileOptions(
              contentType: inspected.mimeType,
              upsert: false,
            ),
          );
      uploaded = true;
      await _client.from('media_assets').insert({
        'user_id': userId,
        'post_id': postId,
        'storage_path': objectPath,
        'mime_type': inspected.mimeType,
        'size_bytes': size,
        'checksum': checksum,
        'processing_status': 'uploaded',
      });
    } catch (error) {
      if (uploaded) {
        try {
          await _client.storage.from(_bucket).remove([objectPath]);
        } catch (cleanupError) {
          throw AppError(
            'Media upload metadata could not be saved and temporary cleanup failed. '
            'Storage path: $objectPath. Upload error: $error. Cleanup error: $cleanupError',
          );
        }
      }
      rethrow;
    }
  }

  Future<MediaFileType> _inspectFile(File file) async {
    final header = <int>[];
    await for (final chunk in file.openRead(0, 16)) {
      header.addAll(chunk);
    }

    return MediaFilePolicy.inspect(header);
  }

  Future<String> _checksum(File file) async {
    final digestSink = AccumulatorSink<Digest>();
    final byteSink = sha256.startChunkedConversion(digestSink);
    await for (final chunk in file.openRead()) {
      byteSink.add(chunk);
    }
    byteSink.close();
    return digestSink.events.single.toString();
  }
}

class MediaFileType {
  const MediaFileType(this.extension, this.mimeType);

  final String extension;
  final String mimeType;
}

class MediaFilePolicy {
  MediaFilePolicy._();

  static const maxUploadBytes = 100 * 1024 * 1024;
  static const _mp4Brands = {
    'isom',
    'iso2',
    'mp41',
    'mp42',
    'avc1',
    'M4V ',
    'M4VH',
    'M4VP',
    'dash',
    'MSNV',
  };

  static void validateSize(int size) {
    if (size <= 0 || size > maxUploadBytes) {
      throw const AppError('Media must be larger than 0 and no larger than 100 MB.');
    }
  }

  static MediaFileType inspect(List<int> header) {
    bool matches(List<int> signature) {
      if (header.length < signature.length) return false;
      for (var index = 0; index < signature.length; index++) {
        if (header[index] != signature[index]) return false;
      }
      return true;
    }

    if (matches(const [0xFF, 0xD8, 0xFF])) {
      return const MediaFileType('jpg', 'image/jpeg');
    }
    if (matches(const [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A])) {
      return const MediaFileType('png', 'image/png');
    }
    if (header.length >= 12 &&
        String.fromCharCodes(header.sublist(0, 4)) == 'RIFF' &&
        String.fromCharCodes(header.sublist(8, 12)) == 'WEBP') {
      return const MediaFileType('webp', 'image/webp');
    }
    if (header.length >= 12 &&
        String.fromCharCodes(header.sublist(4, 8)) == 'ftyp' &&
        _mp4Brands.contains(String.fromCharCodes(header.sublist(8, 12)))) {
      return const MediaFileType('mp4', 'video/mp4');
    }
    if (matches(const [0x1A, 0x45, 0xDF, 0xA3])) {
      return const MediaFileType('webm', 'video/webm');
    }

    throw const AppError(
      'Unsupported or invalid media. Use a JPEG, PNG, WebP, MP4 or WebM file.',
    );
  }
}

final mediaRepositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepository(Supabase.instance.client),
);
