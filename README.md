# OnePost

OnePost is a Flutter app for preparing social posts, managing drafts, and organizing connected publishing accounts. The mobile client uses Supabase for authentication, user-owned data, and private media storage.

> **Current status:** this repository contains a working client foundation, not a production-ready social publishing service. Provider OAuth callbacks, token storage, publishing workers, and live provider integrations are not implemented. Do not promise or rely on live publishing until those backend features have been built, deployed, and verified.

## App preview

| Onboarding | Sign in |
| --- | --- |
| <img src="docs/screenshots/onboarding.png" width="260" alt="OnePost onboarding screen"> | <img src="docs/screenshots/sign-in.png" width="260" alt="OnePost sign-in screen"> |

| Workspace | Social accounts |
| --- | --- |
| <img src="docs/screenshots/dashboard.png" width="260" alt="OnePost workspace preview"> | <img src="docs/screenshots/social-accounts.png" width="260" alt="OnePost social account connection screen"> |

| Draft composer | Draft history |
| --- | --- |
| <img src="docs/screenshots/composer.png" width="260" alt="OnePost draft composer"> | <img src="docs/screenshots/draft-history.png" width="260" alt="OnePost draft history"> |

Workspace and history screenshots use static preview drafts from the development-only screenshot harness; they are not real user records.

## Features implemented

- Onboarding, email/password sign-up and sign-in, and password-reset requests.
- Secure Supabase session and PKCE verifier storage.
- Owner-scoped account and draft data backed by PostgreSQL Row Level Security.
- Draft creation with server-side ownership validation.
- Private image/video uploads with size and file-signature checks.
- Social account list and Connect entry points for Instagram, Facebook Pages, TikTok, YouTube, LinkedIn, and X.
- Connect intent is retained through OnePost sign-in; after sign-in, the app resumes the selected provider authorization flow.
- Provider authorization URLs are HTTPS-only and checked against provider host allowlists.
- OnePost Android/iOS launcher branding.

The client never treats an attempted authorization as a connected account. An account appears only after server-side OAuth verification.

## Requirements

- Flutter SDK compatible with Dart `^3.13.2`.
- Android Studio/Android SDK for Android builds.
- A Supabase project for authentication, database, and storage.

## Configure Supabase

1. Create a Supabase project and configure authentication email delivery and redirect URLs.
2. Apply [`backend/supabase/migrations/001_init.sql`](backend/supabase/migrations/001_init.sql) to the project.
3. Copy `.env.example` to `.env` and set the project URL and **publishable/anon client key**:

   ```json
   {
     "SUPABASE_URL": "https://YOUR_PROJECT_ID.supabase.co",
     "SUPABASE_PUBLISHABLE_KEY": "YOUR_SUPABASE_PUBLISHABLE_OR_ANON_KEY"
   }
   ```

4. Never put a Supabase service-role key, database password, provider client secret, access token, refresh token, or encryption key in the Flutter app, APK, or Git repository.

The SQL migration establishes the client data schema and policies. It does **not** deploy an OAuth or publishing backend.

## Run and validate

From the repository root:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run --dart-define-from-file=.env
```

Build a debug APK for development/testing:

```powershell
flutter build apk --debug --dart-define-from-file=.env
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`.

For a signed release APK, configure a publisher-owned keystore outside source control using `ONEPOST_KEYSTORE_PATH`, `ONEPOST_KEYSTORE_PASSWORD`, `ONEPOST_KEY_ALIAS`, and `ONEPOST_KEY_PASSWORD`, then run:

```powershell
flutter build apk --release --dart-define-from-file=.env
```

Release builds intentionally fail if release signing is not configured. A debug APK is not suitable for store distribution.

## Social account connections and publishing

The Connect buttons require a signed-in OnePost session. If the user is signed out, OnePost routes them to sign-in and returns to the selected provider flow afterward. The provider then asks the user to authorize OnePost; that provider authorization is separate from signing in to OnePost.

The client calls a server-side `oauth-start` function. **That function and its callback are not currently deployed in this repository/project.** Consequently, Connect cannot complete yet, and no provider account is connected. The screens avoid listing developer setup requirements, but provider authorization cannot be made functional by removing authentication or configuration: each service requires a registered OAuth client, approved permissions, and a secure server callback to exchange and store tokens.

Provider tokens and secrets must remain server-side. See [`backend/supabase/functions/README.md`](backend/supabase/functions/README.md), [`docs/provider-setup.md`](docs/provider-setup.md), and [`docs/release-readiness.md`](docs/release-readiness.md) for implementation boundaries and release blockers.

## Documentation

- [Architecture](docs/architecture.md)
- [Provider setup](docs/provider-setup.md)
- [Security](docs/security.md)
- [Testing](docs/testing.md)
- [Deployment](docs/deployment.md)
- [Release readiness](docs/release-readiness.md)

## License

No license has been added. All rights remain with the respective rights holders unless a license is provided.
