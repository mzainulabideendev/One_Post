# Release readiness

## Verified in this workspace

- Flutter 3.47.2 and Dart 3.13.2 are installed.
- Dart analyzer and local Flutter tests pass.
- Android SDK and Java 17 are available for an APK build.
- OnePost branding assets are wired for Android and iOS.
- The client has no static connected accounts or simulated publish success.

## Available after backend setup

- Supabase email/password auth, password reset, account/draft reads, draft creation and private media upload are implemented in the client. They require the migration to be applied and the app built with that project’s HTTPS URL and publishable/anon key.
- The app explains Supabase email rate limits and directs the project owner to configure a custom SMTP provider. Repeated email requests are not used to test or bypass provider limits.

## Release blockers

- Supabase Auth is reachable, and the dashboard confirms the schema is installed. A live authenticated app session and cross-user RLS/storage tests have not been performed.
- The project currently has the default email delivery ceiling of 2 emails/hour, and the dashboard disables editing this setting until Custom SMTP is configured. Configure a verified SMTP provider under Supabase Authentication settings before relying on sign-up confirmations or password-reset email at production traffic.
- Provider OAuth start/callback, account discovery, and AES-GCM token encryption are implemented, deployed, and protected by one-use state validation. Base function secrets are configured; provider app credentials, callback registration, and any required reviews are still outstanding.
- Automated token refresh/revocation, encryption-key rotation, provider-specific publishing adapters, durable worker, retries, status polling and webhook validation are not implemented.
- No Instagram, Facebook Pages, TikTok, YouTube, LinkedIn or X API call was tested end to end. Provider app registrations, permissions, quotas and approvals are unknown.
- Android release builds now require a publisher-owned keystore through environment variables. The Android package identifier `com.onepost.mobile` is a placeholder and must be confirmed/owned before distribution.
- iOS builds/signing require macOS and the publisher's Apple provisioning credentials.

**Status: not production-release ready.** Use the generated APK for UI/dev testing only until these blockers are addressed.
