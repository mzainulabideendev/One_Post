import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/onepost_mark.dart';
import '../../publishing/data/post_repository.dart';
import '../../social_accounts/domain/social_account.dart';
import '../../social_accounts/repositories/social_account_repository.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(connectedAccountsProvider);
    final postsAsync = ref.watch(recentPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            OnePostMark(size: 34),
            SizedBox(width: 10),
            Text('OnePost'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait<void>([
          ref.refresh(connectedAccountsProvider.future).then<void>((_) {}),
          ref.refresh(recentPostsProvider.future).then<void>((_) {}),
        ]),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Your workspace',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Account and draft totals below come from your Supabase workspace.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _CountCard(
                    label: 'Accounts',
                    value: accountsAsync.when(
                      data: (accounts) => '${accounts.length}',
                      loading: () => '—',
                      error: (error, stack) => '!',
                    ),
                    icon: Icons.link_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CountCard(
                    label: 'Recent drafts',
                    value: postsAsync.when(
                      data: (posts) =>
                          '${posts.where((post) => post.status == 'draft').length}',
                      loading: () => '—',
                      error: (error, stack) => '!',
                    ),
                    icon: Icons.edit_note_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Color(0xFF6D28D9)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Publishing setup required',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Live publishing is unavailable until provider OAuth integrations and the secure publishing worker are deployed. Drafts remain available; this app will not report a post as published without a verified provider response.',
                      style: TextStyle(color: Colors.grey.shade700, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Connected accounts',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => context.push('/accounts'),
                  child: const Text('Manage'),
                ),
              ],
            ),
            accountsAsync.when(
              data: (accounts) => accounts.isEmpty
                  ? const _EmptyPanel(
                      icon: Icons.link_off_rounded,
                      title: 'No accounts connected',
                      detail: 'Set up provider OAuth on your backend to connect an account.',
                    )
                  : Column(
                      children: accounts
                          .take(3)
                          .map((account) => _AccountTile(account: account))
                          .toList(growable: false),
                    ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => _ErrorPanel(
                message: 'Could not load accounts: $error',
                onRetry: () => ref.invalidate(connectedAccountsProvider),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent drafts',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  onPressed: () => context.push('/history'),
                  child: const Text('View all'),
                ),
              ],
            ),
            postsAsync.when(
              data: (posts) {
                final drafts =
                    posts.where((post) => post.status == 'draft').take(3).toList();
                return drafts.isEmpty
                    ? const _EmptyPanel(
                        icon: Icons.note_add_outlined,
                        title: 'No drafts yet',
                        detail: 'Start a post and save it to your workspace.',
                      )
                    : Column(
                        children: drafts.map((post) {
                          return Card(
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.edit_note_rounded),
                              ),
                              title: Text(
                                post.caption.isEmpty ? 'Media draft' : post.caption,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(_formatDate(post.createdAt)),
                              onTap: () => context.push('/history'),
                            ),
                          );
                        }).toList(growable: false),
                      );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => _ErrorPanel(
                message: 'Could not load drafts: $error',
                onRetry: () => ref.invalidate(recentPostsProvider),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/composer'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create draft'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) context.push('/accounts');
          if (index == 2) context.push('/history');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.link_outlined),
            selectedIcon: Icon(Icons.link_rounded),
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'History',
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}

class _CountCard extends StatelessWidget {
  const _CountCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6D28D9)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  const _AccountTile({required this.account});

  final SocialAccount account;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
        title: Text(account.displayName),
        subtitle: Text(account.provider.label),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6D28D9), size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(detail, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
        title: Text(message),
        trailing: IconButton(
          tooltip: 'Retry',
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ),
    );
  }
}
