import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/errors/app_error.dart';
import '../../publishing/data/post_repository.dart';
import '../../social_accounts/domain/social_account.dart';
import '../../social_accounts/repositories/social_account_repository.dart';

class ComposerScreen extends ConsumerStatefulWidget {
  const ComposerScreen({super.key});

  @override
  ConsumerState<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends ConsumerState<ComposerScreen> {
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final Set<String> _selectedDestinationIds = {};
  final List<XFile> _media = [];
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    try {
      final selected = await _picker.pickMultipleMedia(
        imageQuality: 92,
        maxWidth: 4096,
        maxHeight: 4096,
      );
      if (!mounted || selected.isEmpty) return;

      final combined = [..._media, ...selected];
      if (combined.length > 10) {
        setState(() => _errorMessage = 'A draft can include at most 10 media files.');
        return;
      }

      setState(() {
        _media
          ..clear()
          ..addAll(combined);
        _errorMessage = null;
      });
    } catch (error) {
      if (mounted) {
        setState(() => _errorMessage = 'Could not open the media picker: $error');
      }
    }
  }

  Future<void> _saveDraft() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final draft = await ref.read(postRepositoryProvider).saveDraft(
            caption: _captionController.text,
            destinationIds: _selectedDestinationIds.toList(growable: false),
            media: List<XFile>.unmodifiable(_media),
          );
      ref.invalidate(recentPostsProvider);
      ref.invalidate(connectedAccountsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Draft saved (${draft.id}).')),
      );
      context.go('/history');
    } on AppError catch (error) {
      if (mounted) setState(() => _errorMessage = error.message);
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'The save may have completed before the connection failed. Check draft history before retrying to avoid duplicates. Details: $error';
        });
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(connectedAccountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a draft'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Post content',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _captionController,
            minLines: 5,
            maxLines: 10,
            maxLength: 10000,
            decoration: const InputDecoration(
              hintText: 'Write your caption…',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _isSaving ? null : _pickMedia,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('Add photos or videos'),
          ),
          if (_media.isNotEmpty) ...[
            const SizedBox(height: 12),
            ..._media.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              final isVideo = _isVideo(file.name);
              return Card(
                child: ListTile(
                  leading: isVideo
                      ? const CircleAvatar(child: Icon(Icons.video_file_outlined))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(file.path),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stack) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                  title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(isVideo ? 'Video' : 'Image'),
                  trailing: IconButton(
                    tooltip: 'Remove media',
                    onPressed: _isSaving
                        ? null
                        : () => setState(() => _media.removeAt(index)),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ),
              );
            }),
          ],
          const SizedBox(height: 24),
          Text(
            'Destinations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose accounts to associate with this draft. Publishing is disabled until those providers are configured and tested.',
            style: TextStyle(height: 1.4, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          accountsAsync.when(
            data: (accounts) {
              final eligible = accounts
                  .where((account) => account.status == SocialAccountStatus.connected)
                  .toList(growable: false);
              if (eligible.isEmpty) {
                return const Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text('No connected destinations'),
                    subtitle: Text('You can still save this as a draft.'),
                  ),
                );
              }
              return Column(
                children: eligible.map((account) {
                  return CheckboxListTile(
                    value: _selectedDestinationIds.contains(account.id),
                    onChanged: _isSaving
                        ? null
                        : (value) {
                            setState(() {
                              if (value == true) {
                                _selectedDestinationIds.add(account.id);
                              } else {
                                _selectedDestinationIds.remove(account.id);
                              }
                            });
                          },
                    title: Text(account.displayName),
                    subtitle: Text(account.provider.label),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                }).toList(growable: false),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline_rounded),
                title: const Text('Account list unavailable'),
                subtitle: Text('$error'),
                trailing: IconButton(
                  onPressed: () => ref.invalidate(connectedAccountsProvider),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lock_outline_rounded, color: Color(0xFF6D28D9)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Media uploads use a private storage bucket and are associated with your user account. Provider-specific media limits are not inferred here.',
                      style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _saveDraft,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save_outlined),
            label: Text(_isSaving ? 'Saving draft…' : 'Save draft'),
          ),
        ),
      ),
    );
  }

  bool _isVideo(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return extension == 'mp4' || extension == 'webm' || extension == 'mov';
  }
}
