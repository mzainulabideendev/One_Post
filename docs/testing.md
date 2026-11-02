# Testing plan

`flutter analyze` and `flutter test` validate the client and model/configuration widget tests. They do not prove Supabase deployment, RLS isolation, media upload against a real project or provider publishing.

Still required before a production pilot:

- Supabase database/RLS tests for cross-user isolation and RPC ownership validation.
- Private Storage ownership tests and media-file signature/size tests.
- Auth integration tests against a staging Supabase project.
- Provider adapter contract and live tests with authorized developer/test accounts.
- Worker lease, retry, ambiguous-outcome and partial-success tests.
