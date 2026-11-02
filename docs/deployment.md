# Deployment guidance

1. Configure Supabase Auth email settings and redirect URLs.
2. Apply the SQL migrations in `backend/supabase/migrations`.
3. Build the client with an HTTPS Supabase project URL and the publishable/anon key via `--dart-define-from-file`.
4. Configure provider secrets only in a server-side secrets manager after the relevant OAuth and API code is implemented.
5. Before publishing, implement and deploy provider OAuth callbacks, token encryption, a durable worker and monitoring.
6. Replace the sample application identifier and debug signing setup with identifiers and a release keystore owned by the publisher.
7. Test RLS and storage isolation, and then verify every provider in a staging environment with authorized test accounts.

This repository does not include deployable provider OAuth or publishing functions yet. See [release readiness](release-readiness.md).
