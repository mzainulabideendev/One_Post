# Edge Functions status

No deployable OAuth or publishing Edge Function is currently present. The mobile app now calls `oauth-start` and will open only a verified official provider host when the function returns a valid URL. Until that function is deployed, the app clearly reports that no account was connected.

The following authenticated server routes still need implementation and tests before provider connection or publishing can be enabled:

- OAuth start/callback for each provider, with state validation and PKCE where supported.
- Server-side credential exchange, encryption and key rotation.
- Account discovery, reauthorization and revocation.
- Media policy validation and short-lived provider-accessible uploads as required by each provider.
- Atomic publishing batch creation, worker dispatch, progress/status queries, safe retry and cancellation.
- Signed webhook validation and deduplication.

Do not add provider client secrets, access tokens, refresh tokens or service-role credentials to the Flutter app or source control. Provider OAuth/publish endpoints must be verified against current official provider documentation before implementation.
