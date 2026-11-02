import {
  callbackUrl,
  decryptSecret,
  encryptSecret,
  isProvider,
  jsonResponse,
  pkceChallenge,
  postServiceTable,
  providerConfig,
  randomToken,
  removeExpiredStates,
  requiredEnv,
  sha256Hex,
  verifyUser,
} from "../_shared/oauth.ts";

Deno.serve(async (request: Request): Promise<Response> => {
  if (request.method === "OPTIONS") {
    return new Response("ok", {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Headers":
          "authorization, apikey, content-type, x-client-info",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
      },
    });
  }
  if (request.method !== "POST") {
    return jsonResponse({ message: "Method not allowed." }, 405);
  }

  try {
    const authorization = request.headers.get("Authorization");
    if (!authorization?.startsWith("Bearer ")) {
      return jsonResponse({
        message: "Sign in to OnePost before connecting an account.",
      }, 401);
    }
    const userId = await verifyUser(authorization.slice("Bearer ".length));
    const body = await request.json();
    const providerValue = body && typeof body === "object"
      ? body.provider
      : null;
    if (!isProvider(providerValue)) {
      return jsonResponse(
        { message: "Choose a supported social platform." },
        400,
      );
    }

    const provider = providerValue;
    requiredEnv("OAUTH_ENCRYPTION_KEY");
    const config = providerConfig(provider);
    const callback = callbackUrl();
    const state = randomToken(32);
    const verifier = config.usesPkce ? randomToken(48) : null;
    await removeExpiredStates();
    await postServiceTable("oauth_authorization_states", {
      state_hash: await sha256Hex(state),
      user_id: userId,
      provider,
      encrypted_pkce_verifier: verifier ? await encryptSecret(verifier) : null,
      expires_at: new Date(Date.now() + 10 * 60 * 1000).toISOString(),
    });

    const authorizationUrl = new URL(config.authorizeUrl);
    authorizationUrl.searchParams.set("client_id", config.clientId);
    authorizationUrl.searchParams.set("redirect_uri", callback);
    authorizationUrl.searchParams.set("response_type", "code");
    const scopeSeparator = provider === "instagram" ||
        provider === "facebook_pages" ||
        provider === "tiktok"
      ? ","
      : " ";
    authorizationUrl.searchParams.set(
      "scope",
      config.scopes.join(scopeSeparator),
    );
    authorizationUrl.searchParams.set("state", state);

    if (provider === "tiktok") {
      authorizationUrl.searchParams.set("client_key", config.clientId);
      authorizationUrl.searchParams.delete("client_id");
    } else if (provider === "instagram") {
      authorizationUrl.searchParams.set("force_reauth", "false");
    } else if (provider === "youtube") {
      authorizationUrl.searchParams.set("access_type", "offline");
      authorizationUrl.searchParams.set("prompt", "consent");
      authorizationUrl.searchParams.set("include_granted_scopes", "true");
    }
    if (verifier) {
      authorizationUrl.searchParams.set(
        "code_challenge",
        await pkceChallenge(verifier),
      );
      authorizationUrl.searchParams.set("code_challenge_method", "S256");
    }

    if (authorizationUrl.protocol !== "https:") {
      throw new Error("Provider authorization URL must use HTTPS");
    }
    return jsonResponse({ authorization_url: authorizationUrl.toString() });
  } catch (error) {
    console.error(
      "oauth-start failed",
      error instanceof Error ? error.name : "unknown",
    );
    const message = error instanceof Error &&
        error.message === "Invalid or expired OnePost session"
      ? "Your OnePost session is missing or expired. Sign in again before connecting an account."
      : "Could not start account authorization. Check the server configuration and try again.";
    return jsonResponse({ message }, message.startsWith("Your ") ? 401 : 503);
  }
});
