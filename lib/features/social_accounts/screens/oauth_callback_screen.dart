import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/social_account.dart';
import '../repositories/social_account_repository.dart';

class OAuthCallbackScreen extends ConsumerStatefulWidget {
  const OAuthCallbackScreen({
    super.key,
    required this.connected,
    required this.provider,
  });

  final bool connected;
  final String provider;

  @override
  ConsumerState<OAuthCallbackScreen> createState() =>
      _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends ConsumerState<OAuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.connected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.invalidate(connectedAccountsProvider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = SocialProvider.values.where(
      (value) => value.name == widget.provider,
    );
    final providerName = provider.isEmpty ? 'Social account' : provider.first.label;

    return Scaffold(
      appBar: AppBar(title: const Text('Account connection')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.connected ? Icons.check_circle_outline : Icons.link_off,
                size: 56,
                color: widget.connected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                widget.connected
                    ? '$providerName connected'
                    : '$providerName connection was not completed',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                widget.connected
                    ? 'The provider authorized OnePost and the account was verified.'
                    : 'You can return to OnePost and try again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  ref.invalidate(connectedAccountsProvider);
                  context.go('/accounts');
                },
                child: const Text('Return to OnePost'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
