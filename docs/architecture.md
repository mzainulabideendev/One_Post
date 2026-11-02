# OnePost architecture

## Implemented client foundation

- Flutter mobile app using Material 3, Riverpod and GoRouter.
- Supabase Auth with PKCE and secure local session/PKCE storage.
- Supabase PostgreSQL with owner-scoped RLS for account metadata, drafts and private media.
- Private Storage uploads with a random owner-prefixed path, MIME signature checks, size cap and streaming SHA-256 checksum.
- A security-definer database function creates draft records and destination associations in one transaction.

## Important design rules

- Provider secrets must never reach the mobile app.
- Provider OAuth authorization-code exchanges belong on server-side callbacks.
- Provider-specific logic must stay isolated in server-side adapters.
- Publishing must only be marked successful after documented provider confirmation.
- Server-side OAuth start/callback code, one-use state validation, provider account discovery, and AES-GCM credential encryption are implemented. They still require project secrets and deployment.
- Provider token refresh/revocation, publishing adapters, a persistent worker, and live provider verification are not implemented.
