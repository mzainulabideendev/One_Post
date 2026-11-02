import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/app_error.dart';
import '../../composer/data/media_repository.dart';

class PostRecord {
  const PostRecord({
    required this.id,
    required this.caption,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String caption;
  final String status;
  final DateTime createdAt;
}

class PostRepository {
  PostRepository(this._client, this._mediaRepository);

  final SupabaseClient _client;
  final MediaRepository _mediaRepository;

  Future<List<PostRecord>> getRecentPosts() async {
    final rows = await _client
        .from('posts')
        .select('id, base_caption, status, created_at')
        .order('created_at', ascending: false)
        .limit(50);

    return rows.map((row) {
      final post = Map<String, dynamic>.from(row);
      return PostRecord(
        id: post['id'] as String,
        caption: post['base_caption'] as String,
        status: post['status'] as String,
        createdAt: DateTime.parse(post['created_at'] as String),
      );
    }).toList(growable: false);
  }

  Future<PostRecord> saveDraft({
    required String caption,
    required List<String> destinationIds,
    required List<XFile> media,
  }) async {
    if (caption.trim().isEmpty && media.isEmpty) {
      throw const AppError('Add a caption or media before saving this draft.');
    }

    final postId = await _client.rpc<String>(
      'create_post_draft',
      params: {
        'p_base_caption': caption,
        'p_social_account_ids': destinationIds,
      },
    );
    final post = await _client
        .from('posts')
        .select('id, base_caption, status, created_at')
        .eq('id', postId)
        .single();
    final savedPost = PostRecord(
      id: post['id'] as String,
      caption: post['base_caption'] as String,
      status: post['status'] as String,
      createdAt: DateTime.parse(post['created_at'] as String),
    );

    for (final asset in media) {
      try {
        await _mediaRepository.uploadDraftAsset(postId: savedPost.id, asset: asset);
      } catch (error) {
        throw AppError(
          'Draft ${savedPost.id} was saved, but a media upload failed. '
          'Review the draft before trying again. Details: $error',
        );
      }
    }

    return savedPost;
  }
}

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(
    Supabase.instance.client,
    ref.watch(mediaRepositoryProvider),
  ),
);

final recentPostsProvider = FutureProvider<List<PostRecord>>((ref) {
  return ref.watch(postRepositoryProvider).getRecentPosts();
});
