# Publishing worker status

The worker is not implemented or deployed. Live publishing is blocked until a durable, monitored worker exists.

Before enabling it, implement and test:

- atomic job leasing and bounded concurrency;
- provider-specific token refresh and media-upload workflows;
- destination-level provider adapters and documented success conditions;
- retry/backoff with `Retry-After`, dead-letter handling and ambiguous-outcome reconciliation;
- sanitized errors, audit events, provider-status polling and safe per-destination retry;
- operational health checks and alerts that do not expose credentials or media URLs.
