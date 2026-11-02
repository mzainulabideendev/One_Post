# Security and compliance

- The app accepts only an HTTPS Supabase URL and a publishable/anon client key. It rejects a service-role JWT.
- Supabase Auth session and PKCE verifier are stored using `flutter_secure_storage`.
- Provider secrets, access tokens and refresh tokens are not present in the client or this repository.
- Database RLS limits user records and private media to the authenticated owner. Credential, OAuth state and webhook tables have no client grants.
- Provider credential ciphertext columns are schema placeholders only. No token encryption/KMS service or OAuth token-writing function is implemented yet; do not use them to store tokens until that exists.
- Storage uploads use a private bucket, an owner-prefixed random object path, a size limit and media signature validation.
- The publish action is unavailable until a server integration exists. No HTTP acceptance is represented as a successful post.
- Apply and test migrations in a staging Supabase project before production use.
