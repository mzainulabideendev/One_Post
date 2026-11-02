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
- This repository does not yet include OAuth callbacks, provider publishing adapters, a persistent worker, or live provider verification.
