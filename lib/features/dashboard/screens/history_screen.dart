import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../publishing/data/post_repository.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(recentPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Draft history'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: postsAsync.when(
        data: (posts) => posts.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No saved posts yet. Create a draft to see it here.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.refresh(recentPostsProvider.future),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.article_outlined),
                        ),
                        title: Text(
                          post.caption.isEmpty ? 'Media draft' : post.caption,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '${post.status} · ${_formatDate(post.createdAt)}',
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 36),
                const SizedBox(height: 12),
                Text('Could not load post history: $error'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(recentPostsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/composer'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create draft'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}
