# Deployment guidance

1. Configure Supabase Auth email settings and redirect URLs.
2. Apply the SQL migrations in `backend/supabase/migrations`.
3. Build the client with an HTTPS Supabase project URL and the publishable/anon key via `--dart-define-from-file`.
4. Apply the OAuth state/credential RPC migration, register provider callback URLs, configure provider credentials only in Supabase Edge Function secrets, and deploy OAuth functions following [the OAuth deployment guide](oauth-deployment.md).
5. Before publishing, implement and deploy the provider adapters, durable worker, token refresh/revocation, and monitoring.
6. Replace the sample application identifier and debug signing setup with identifiers and a release keystore owned by the publisher.
7. Test RLS and storage isolation, and then verify every provider in a staging environment with authorized test accounts.

OAuth start/callback functions are deployed with base secrets configured. Provider app credentials, callback registration, and provider reviews remain outstanding. The publishing worker and provider-specific publishing adapters are not included. See [release readiness](release-readiness.md).
