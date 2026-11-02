import 'package:flutter_test/flutter_test.dart';
import 'package:onepost/core/errors/app_error.dart';
import 'package:onepost/features/composer/data/media_repository.dart';

void main() {
  group('MediaFilePolicy', () {
    test('recognizes supported file signatures', () {
      expect(
        MediaFilePolicy.inspect([0xFF, 0xD8, 0xFF]).mimeType,
        'image/jpeg',
      );
      expect(
        MediaFilePolicy.inspect(
          [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A],
        ).mimeType,
        'image/png',
      );
      expect(
        MediaFilePolicy.inspect([
          0x52, 0x49, 0x46, 0x46, 0, 0, 0, 0, 0x57, 0x45, 0x42, 0x50,
        ]).mimeType,
        'image/webp',
      );
      expect(
        MediaFilePolicy.inspect([
          0, 0, 0, 0, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D,
        ]).mimeType,
        'video/mp4',
      );
      expect(
        MediaFilePolicy.inspect([0x1A, 0x45, 0xDF, 0xA3]).mimeType,
        'video/webm',
      );
    });

    test('rejects unknown file signatures and non-video ISO BMFF brands', () {
      expect(
        () => MediaFilePolicy.inspect([0x42, 0x4D, 0, 0]),
        throwsA(isA<AppError>()),
      );
      expect(
        () => MediaFilePolicy.inspect([
          0, 0, 0, 0, 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63,
        ]),
        throwsA(isA<AppError>()),
      );
    });

    test('enforces the configured upload-size ceiling', () {
      expect(() => MediaFilePolicy.validateSize(1), returnsNormally);
      expect(
        () => MediaFilePolicy.validateSize(MediaFilePolicy.maxUploadBytes),
        returnsNormally,
      );
      expect(() => MediaFilePolicy.validateSize(0), throwsA(isA<AppError>()));
      expect(
        () => MediaFilePolicy.validateSize(MediaFilePolicy.maxUploadBytes + 1),
        throwsA(isA<AppError>()),
      );
    });
  });
}
