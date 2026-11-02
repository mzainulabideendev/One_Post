import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SecureAuthStorage extends LocalStorage implements GotrueAsyncStorage {
  SecureAuthStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _sessionKey = 'onepost.supabase.session';
  static const _pkcePrefix = 'onepost.supabase.pkce.';

  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> hasAccessToken() async => (await accessToken()) != null;

  @override
  Future<String?> accessToken() async {
    final session = await _storage.read(key: _sessionKey);
    if (session == null) return null;

    final decoded = jsonDecode(session);
    if (decoded is! Map<String, dynamic>) return null;
    final token = decoded['access_token'];
    return token is String ? token : null;
  }

  @override
  Future<void> removePersistedSession() =>
      _storage.delete(key: _sessionKey);

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _sessionKey, value: persistSessionString);

  @override
  Future<String?> getItem({required String key}) =>
      _storage.read(key: '$_pkcePrefix$key');

  @override
  Future<void> setItem({required String key, required String value}) =>
      _storage.write(key: '$_pkcePrefix$key', value: value);

  @override
  Future<void> removeItem({required String key}) =>
      _storage.delete(key: '$_pkcePrefix$key');
}
