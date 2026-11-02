# Provider setup checklist

The mobile app provides Connect entry points for each provider and resumes the selected flow after OnePost sign-in. Provider authorization is separate from OnePost authentication. The server-side OAuth start/callback and publishing integrations are not implemented or deployed, so no provider is currently ready to connect or publish. Each checklist below is a release prerequisite, not a claim that the integration is implemented.

## Instagram
- Use a Meta Business account and professional account authentication.
- Validate that the account is eligible for Instagram Content Publishing.
- Record the granted scopes and page permissions in the backend.

## Facebook Pages
- Require the user to authorize the Page management scope with the correct page IDs.
- Store the selected page token as an encrypted server-side secret.

## TikTok
- Confirm the app is approved for the required content-posting scope.
- Document any approval, verification or domain restrictions before enabling direct posting.

## YouTube
- Use the YouTube Data API with explicit user visibility choice.
- Implement resumable uploads and processing state checks.

## LinkedIn
- Use the current Posts API and `w_member_social` scope for member posts.
- Require organization roles and product permissions before organization publishing.

## X
- Use the approved developer application and OAuth 2.0 user context.
- Respect access tiers, media-processing rules and quota constraints.
