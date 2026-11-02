import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_error_message.dart';
import '../../../core/widgets/onepost_mark.dart';

enum _AuthMode { signIn, signUp, resetPassword }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  _AuthMode _mode = _AuthMode.signIn;
  bool _isSubmitting = false;
  String? _message;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _message = null;
      _error = null;
    });

    try {
      final auth = Supabase.instance.client.auth;
      switch (_mode) {
        case _AuthMode.signIn:
          await auth.signInWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          break;
        case _AuthMode.signUp:
          final response = await auth.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
          if (response.session == null && mounted) {
            setState(() {
              _message = 'Check your email to confirm your new account.';
            });
          }
          break;
        case _AuthMode.resetPassword:
          await auth.resetPasswordForEmail(_emailController.text.trim());
          if (mounted) {
            setState(() {
              _message = 'If that email is registered, a reset link is on its way.';
            });
          }
          break;
      }
    } on AuthException catch (exception) {
      if (mounted) setState(() => _error = authErrorMessage(exception));
    } catch (exception) {
      if (mounted) setState(() => _error = 'Unable to reach the authentication service: $exception');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReset = _mode == _AuthMode.resetPassword;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OnePostMark(size: 64),
                    const SizedBox(height: 24),
                    Text(
                      switch (_mode) {
                        _AuthMode.signIn => 'Welcome back',
                        _AuthMode.signUp => 'Create your account',
                        _AuthMode.resetPassword => 'Reset your password',
                      },
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Sign in to manage your connected publishing accounts.'),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        return email.contains('@') ? null : 'Enter a valid email address.';
                      },
                    ),
                    if (!isReset) ...[
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        autofillHints: _mode == _AuthMode.signIn
                            ? const [AutofillHints.password]
                            : const [AutofillHints.newPassword],
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                        ),
                        validator: (value) {
                          final password = value ?? '';
                          if (_mode == _AuthMode.signIn && password.isEmpty) {
                            return 'Enter your password.';
                          }
                          if (_mode == _AuthMode.signUp && password.length < 8) {
                            return 'Use at least 8 characters.';
                          }
                          return null;
                        },
                      ),
                    ],
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    ],
                    if (_message != null) ...[
                      const SizedBox(height: 16),
                      Text(_message!, style: const TextStyle(color: Colors.green)),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(switch (_mode) {
                                _AuthMode.signIn => 'Sign in',
                                _AuthMode.signUp => 'Create account',
                                _AuthMode.resetPassword => 'Send reset link',
                              }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                setState(() {
                                  _error = null;
                                  _message = null;
                                  _mode = switch (_mode) {
                                    _AuthMode.signIn => _AuthMode.signUp,
                                    _AuthMode.signUp || _AuthMode.resetPassword =>
                                      _AuthMode.signIn,
                                  };
                                });
                              },
                        child: Text(
                          _mode == _AuthMode.signIn
                              ? 'Create an account'
                              : 'Back to sign in',
                        ),
                      ),
                    ),
                    if (_mode == _AuthMode.signIn)
                      Center(
                        child: TextButton(
                          onPressed: () => setState(() {
                            _mode = _AuthMode.resetPassword;
                            _error = null;
                            _message = null;
                          }),
                          child: const Text('Forgot password?'),
                        ),
                      ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your social network passwords are never requested. Connect accounts through the provider’s official authorization page when server integrations are configured.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, height: 1.45, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
