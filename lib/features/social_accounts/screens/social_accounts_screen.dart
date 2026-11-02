import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/provider_connection_service.dart';
import '../domain/social_account.dart';
import '../repositories/social_account_repository.dart';

class SocialAccountsScreen extends ConsumerStatefulWidget {
  const SocialAccountsScreen({super.key});

  @override
  ConsumerState<SocialAccountsScreen> createState() =>
      _SocialAccountsScreenState();
}

class _SocialAccountsScreenState extends ConsumerState<SocialAccountsScreen>
    with WidgetsBindingObserver {
  static const _providers = [
    SocialProvider.instagram,
    SocialProvider.facebookPages,
    SocialProvider.tiktok,
    SocialProvider.youtube,
    SocialProvider.linkedin,
    SocialProvider.x,
  ];

  SocialProvider? _connectingProvider;
  bool _pendingConnectionHandled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(connectedAccountsProvider);
    }
  }

  Future<void> _connect(SocialProvider provider) async {
    if (Supabase.instance.client.auth.currentSession == null) {
      final destination = Uri(
        path: '/accounts',
        queryParameters: {'connect': provider.name},
      ).toString();
      if (mounted) {
        context.go(
          Uri(
            path: '/sign-in',
            queryParameters: {'next': destination},
          ).toString(),
        );
      }
      return;
    }

    setState(() => _connectingProvider = provider);
    try {
      await ref.read(providerConnectionServiceProvider).connect(provider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Continue in ${provider.label} to authorize OnePost. '
            'The account appears here only after the backend verifies the callback.',
          ),
        ),
      );
    } on ProviderConnectionException catch (error) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.link_off_rounded),
          title: Text('${provider.label} is not connected'),
          content: Text(error.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) setState(() => _connectingProvider = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(connectedAccountsProvider);
    _startPendingConnection(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Social accounts'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.security_rounded, color: Color(0xFF6D28D9)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Sign in securely with each platform to connect your account. OnePost never asks for your social password.',
                      style: TextStyle(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Connected accounts',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          accountsAsync.when(
            data: (accounts) => accounts.isEmpty
                ? const Card(
                    child: ListTile(
                      leading: Icon(Icons.link_off_rounded),
                      title: Text('No verified accounts connected'),
                      subtitle: Text(
                        'An account appears here only after server-side OAuth verification.',
                      ),
                    ),
                  )
                : Column(
                    children: accounts
                        .map((account) => Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person_outline_rounded),
                                ),
                                title: Text(account.displayName),
                                subtitle: Text(
                                  '${account.provider.label} · ${account.status.name}',
                                ),
                              ),
                            ))
                        .toList(growable: false),
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Card(
              child: ListTile(
                leading: const Icon(Icons.error_outline_rounded),
                title: const Text('Could not load connected accounts'),
                subtitle: Text('$error'),
                trailing: IconButton(
                  tooltip: 'Retry',
                  onPressed: () => ref.invalidate(connectedAccountsProvider),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Connect an account',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ..._providers.map((provider) {
            final connected = accountsAsync.asData?.value.any(
                  (account) =>
                      account.provider == provider &&
                      account.status == SocialAccountStatus.connected,
                ) ??
                false;
            final isConnecting = _connectingProvider == provider;

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFEDE9FE),
                  child: Text(
                    provider.label.characters.first,
                    style: const TextStyle(
                      color: Color(0xFF5B21B6),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(provider.label),
                subtitle: Text(
                  connected
                      ? 'Connected account verified by backend'
                      : 'Continue to ${provider.label} to authorize OnePost.',
                ),
                trailing: connected
                    ? const Chip(
                        label: Text('Connected'),
                        visualDensity: VisualDensity.compact,
                      )
                    : FilledButton.tonal(
                        onPressed: _connectingProvider == null
                            ? () => _connect(provider)
                            : null,
                        child: isConnecting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Connect'),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _startPendingConnection(BuildContext context) {
    if (_pendingConnectionHandled) return;
    final providerName =
        GoRouterState.of(context).uri.queryParameters['connect'];
    if (providerName == null) return;

    SocialProvider? provider;
    for (final candidate in _providers) {
      if (candidate.name == providerName) {
        provider = candidate;
        break;
      }
    }
    if (provider == null) return;

    _pendingConnectionHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.replace('/accounts');
      _connect(provider!);
    });
  }
}
