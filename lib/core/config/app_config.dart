import 'dart:convert';

class AppConfig {
  AppConfig._();

  static const String appName = 'OnePost';
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static bool get isBackendConfigured {
    final uri = Uri.tryParse(supabaseUrl);
    return uri?.scheme == 'https' &&
        uri?.host.isNotEmpty == true &&
        _isPublicClientKey(supabasePublishableKey);
  }

  static bool _isPublicClientKey(String value) {
    if (value.startsWith('sb_publishable_')) return true;
    final parts = value.split('.');
    if (parts.length != 3) return false;

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      return payload is Map<String, dynamic> && payload['role'] == 'anon';
    } on FormatException {
      return false;
    }
  }

  static const Map<String, String> providerDisplayNames = {
    'instagram': 'Instagram',
    'facebook_pages': 'Facebook Pages',
    'tiktok': 'TikTok',
    'youtube': 'YouTube',
    'linkedin': 'LinkedIn',
    'x': 'X',
  };
}
