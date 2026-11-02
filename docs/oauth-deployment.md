# Live provider OAuth deployment

The repository includes OAuth start and callback functions, but the flow is not live until the database migration, Supabase function secrets, and each provider's registered OAuth application are configured. Do not put provider credentials or the token-encryption key in the Flutter app.

## Deployment status (2026-11-02)

| Item | State |
| --- | --- |
| Migration `002_oauth_connections.sql` | ✅ Applied to `impcfnniwlupxzeofmfq` |
| `oauth-start` | ✅ Deployed, JWT required |
| `oauth-callback` | ✅ Deployed, `verify_jwt = false` |
| Base secrets | ✅ `OAUTH_CALLBACK_URL`, `OAUTH_APP_REDIRECT_URL`, `OAUTH_ENCRYPTION_KEY`, `META_GRAPH_API_VERSION` |
| Provider client IDs/secrets | ❌ Not configured — no provider app credentials are registered |
| Provider callback registration | ❌ Pending for all six providers |
| Android/iOS deep link | ✅ `com.onepost.mobile://oauth-callback` registered |
| Live endpoint checks | ✅ `oauth-start` returns 401 without a session; `oauth-callback` returns 400 without a valid state |
| End-to-end provider connection | ❌ Blocked on provider credentials and accounts |

Complete sections 2 and 3 below for each provider you intend to enable, then repeat the verification in section 5.

## 1. Apply the database migration

In the Supabase SQL Editor for the OnePost project, run [`backend/supabase/migrations/002_oauth_connections.sql`](../backend/supabase/migrations/002_oauth_connections.sql) after `001_init.sql`.

The migration adds server-only RPCs for consuming an OAuth state exactly once and atomically saving verified account metadata and encrypted tokens. The existing RLS rules prevent mobile clients from reading the OAuth state or credential tables.

## 2. Register each provider application

Register this exact HTTPS callback URI in each provider app:

```text
https://impcfnniwlupxzeofmfq.supabase.co/functions/v1/oauth-callback
```

Configure the provider products, redirect URI, test users, and scopes as required by that provider. Approval/access levels are provider-controlled; the app cannot bypass them.

| Provider | Required Supabase secret names | Requested authorization |
| --- | --- | --- |
| Instagram professional | `INSTAGRAM_CLIENT_ID`, `INSTAGRAM_CLIENT_SECRET` | `instagram_business_basic`, `instagram_business_content_publish` |
| Facebook Pages | `FACEBOOK_CLIENT_ID`, `FACEBOOK_CLIENT_SECRET` | `pages_show_list`, `pages_read_engagement`, `pages_manage_posts` |
| TikTok | `TIKTOK_CLIENT_KEY`, `TIKTOK_CLIENT_SECRET` | `user.info.basic`, `video.publish` |
| YouTube | `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` | Google identity, `youtube.readonly`, `youtube.upload` |
| LinkedIn | `LINKEDIN_CLIENT_ID`, `LINKEDIN_CLIENT_SECRET` | `openid`, `profile`, `w_member_social` |
| X | `X_CLIENT_ID`, `X_CLIENT_SECRET` | `users.read`, `tweet.read`, `tweet.write`, `media.write`, `offline.access` |

The requested scopes may require review, development-mode test users, or specific provider products. Only test with accounts you own or are authorized to connect. The function uses Meta Graph API `v26.0` by default; set `META_GRAPH_API_VERSION` to a currently supported version when required.

## 3. Add server secrets

Re-authenticate the Supabase CLI as the project owner if `supabase projects list` reports an invalid access token. Do not share the CLI access token or provider secrets.

Create a **local, ignored** `.env.oauth` file containing the provider client credentials from their developer dashboards and these settings:

```dotenv
OAUTH_CALLBACK_URL=https://impcfnniwlupxzeofmfq.supabase.co/functions/v1/oauth-callback
OAUTH_APP_REDIRECT_URL=com.onepost.mobile://oauth-callback/oauth-callback
OAUTH_ENCRYPTION_KEY=REPLACE_WITH_A_RANDOM_BASE64URL_32_BYTE_KEY
META_GRAPH_API_VERSION=v26.0
INSTAGRAM_CLIENT_ID=
INSTAGRAM_CLIENT_SECRET=
FACEBOOK_CLIENT_ID=
FACEBOOK_CLIENT_SECRET=
TIKTOK_CLIENT_KEY=
TIKTOK_CLIENT_SECRET=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
LINKEDIN_CLIENT_ID=
LINKEDIN_CLIENT_SECRET=
X_CLIENT_ID=
X_CLIENT_SECRET=
```

Generate a new encryption key locally; keep it in a password manager and Supabase secrets, never in source control:

```powershell
$bytes = New-Object byte[] 32
[Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
[Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
```

Only add the provider client ID and secret pairs for provider apps you have registered. Blank entries are placeholders: passing `.env.oauth` directly to `secrets set` would store empty secret values. Set only the non-empty lines:

```powershell
$base = "C:\Users\$env:USERNAME\AppData\Local\Temp\onepost-oauth-secrets.env"
Get-Content .env.oauth | Where-Object {
  $_ -match '=' -and ($_ -split '=', 2)[1].Trim() -ne ''
} | Set-Content $base
supabase secrets set --env-file $base --project-ref impcfnniwlupxzeofmfq
Remove-Item $base -Force
```

Supabase supplies `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` to Edge Functions. Do not copy the service-role key into `.env.oauth` or set it in a client build.

The encryption key currently uses version `1`. Back it up securely. Rotating it requires re-encrypting every stored provider token before changing the deployed key; this repository does not yet include a token-key rotation job.

## 4. Deploy the functions

Run from the `backend` directory, after installing and logging in to the Supabase CLI. The CLI resolves functions from `./supabase/functions`, and running here also avoids loading the Flutter app's JSON `.env` at the repository root:

```powershell
cd backend
supabase functions deploy oauth-start --project-ref impcfnniwlupxzeofmfq
supabase functions deploy oauth-callback --no-verify-jwt --project-ref impcfnniwlupxzeofmfq
```

The `oauth-start` endpoint requires a valid OnePost Supabase user session. The external provider callback intentionally does not require that user JWT; its authorization is instead bound to a short-lived, high-entropy, one-use state row, consumed atomically before exchanging the authorization code.

## 5. Verify the mobile callback

The Android and iOS projects register `com.onepost.mobile://oauth-callback`. Build and install the app after the functions and provider settings are deployed. Sign into OnePost, connect a provider test account, approve the consent screen, and verify that the callback returns to OnePost and the verified account appears in the list. Confirm a denied/expired callback does **not** add an account.

Also verify that:

- expired and replayed OAuth state is rejected;
- credentials are stored only as encrypted ciphertext in the server-only table;
- the account is visible only to its owner;
- app review/testing status allows every requested scope.

## Scope and known limitations

This deployment enables verified account connection and token storage. It does **not** make posting live: durable publishing workers, per-provider post/media adapters, refresh-token rotation, revocation, retries, and end-to-end publish verification are separate work. YouTube channel selection currently associates channels returned for the authorized Google account; validate this behavior with the account types your app will support before production use.

Official provider references:

- [Instagram Business Login](https://developers.facebook.com/docs/instagram-platform/instagram-api-with-instagram-login/business-login)
- [Facebook Pages API](https://developers.facebook.com/docs/graph-api/reference/user/accounts/)
- [TikTok Login Kit for Web](https://developers.tiktok.com/docs/en/login-kit-web)
- [Google OAuth 2.0 for web server applications](https://developers.google.com/identity/protocols/oauth2/web-server)
- [LinkedIn Sign in with OpenID Connect](https://learn.microsoft.com/en-us/linkedin/consumer/integrations/self-serve/sign-in-with-linkedin-v2)
- [X OAuth 2.0 Authorization Code with PKCE](https://docs.x.com/fundamentals/authentication/oauth-2-0/authorization-code)
