import 'package:flutter/material.dart';

import '../../../core/widgets/onepost_mark.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.onComplete,
    this.initialPage = 0,
  });

  final Future<void> Function() onComplete;
  final int initialPage;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pages = [
    _OnboardingPageData(
      icon: Icons.edit_note_rounded,
      eyebrow: 'YOUR CONTENT, ONE PLACE',
      title: 'Create with clarity.',
      description:
          'Write your post, choose a photo or video, and keep your drafts together in one simple workspace.',
      accent: Color(0xFF7C3AED),
    ),
    _OnboardingPageData(
      icon: Icons.account_tree_outlined,
      eyebrow: 'YOUR ACCOUNTS, YOUR CONTROL',
      title: 'Choose where it goes.',
      description:
          'Connect only accounts you control through each platform’s official authorization flow.',
      accent: Color(0xFF0F766E),
    ),
    _OnboardingPageData(
      icon: Icons.verified_user_outlined,
      eyebrow: 'HONEST STATUS, SECURE BY DESIGN',
      title: 'Know what is ready.',
      description:
          'See clear account and publishing status. OnePost never calls a post published until the platform confirms it.',
      accent: Color(0xFF2563EB),
    ),
  ];

  late final PageController _controller;
  int _currentPage = 0;
  bool _isCompleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(0, _pages.length - 1);
    _controller = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    if (_isCompleting) return;
    setState(() {
      _isCompleting = true;
      _errorMessage = null;
    });

    try {
      await widget.onComplete();
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Could not save your onboarding preference: $error';
        });
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
          child: Column(
            children: [
              Row(
                children: [
                  const OnePostMark(size: 38),
                  const SizedBox(width: 10),
                  Text(
                    'OnePost',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _isCompleting ? null : _complete,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingPage(data: page);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final selected = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: selected ? 24 : 8,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF6D28D9)
                          : const Color(0xFFD8D3E5),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isCompleting ? null : _next,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isCompleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _currentPage == _pages.length - 1
                              ? 'Get started'
                              : 'Continue',
                        ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your social account passwords are never requested.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.accent,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String description;
  final Color accent;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.accent.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: Container(
                      width: 142,
                      height: 142,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(42),
                        boxShadow: [
                          BoxShadow(
                            color: data.accent.withValues(alpha: 0.16),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(data.icon, color: data.accent, size: 72),
                    ),
                  ),
                ),
                const SizedBox(height: 46),
                Text(
                  data.eyebrow,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: data.accent,
                    fontSize: 11,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.55,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
