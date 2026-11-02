import {
  appRedirectUrl,
  decryptSecret,
  encryptSecret,
  isProvider,
  providerConfig,
  sha256Hex,
} from "./oauth.ts";

Deno.test("provider allowlist rejects unsupported provider identifiers", () => {
  if (
    !isProvider("instagram") || !isProvider("facebook_pages") ||
    !isProvider("x")
  ) {
    throw new Error("A supported provider was rejected");
  }
  if (isProvider("unknown") || isProvider("../oauth-callback")) {
    throw new Error("An unsupported provider was accepted");
  }
});

Deno.test("OAuth token encryption round-trips and uses a unique IV", async () => {
  Deno.env.set(
    "OAUTH_ENCRYPTION_KEY",
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  );
  const first = await encryptSecret("access-token-test");
  const second = await encryptSecret("access-token-test");
  if (first === second) throw new Error("AES-GCM encryption reused an IV");
  if (await decryptSecret(first) !== "access-token-test") {
    throw new Error("Encrypted OAuth data did not round-trip");
  }
});

Deno.test("OAuth encryption rejects modified ciphertext", async () => {
  Deno.env.set(
    "OAUTH_ENCRYPTION_KEY",
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
  );
  const ciphertext = await encryptSecret("access-token-test");
  const parts = ciphertext.split(".");
  const encoded = parts[2];
  const last = encoded.at(-1) === "A" ? "B" : "A";
  parts[2] = `${encoded.slice(0, -1)}${last}`;
  let rejected = false;
  try {
    await decryptSecret(parts.join("."));
  } catch {
    rejected = true;
  }
  if (!rejected) throw new Error("Modified ciphertext was accepted");
});

Deno.test("provider configuration contains secure, provider-specific endpoints", () => {
  Deno.env.set("META_GRAPH_API_VERSION", "v26.0");
  for (
    const [name, value] of Object.entries({
      INSTAGRAM_CLIENT_ID: "instagram-id",
      INSTAGRAM_CLIENT_SECRET: "instagram-secret",
      FACEBOOK_CLIENT_ID: "facebook-id",
      FACEBOOK_CLIENT_SECRET: "facebook-secret",
      TIKTOK_CLIENT_KEY: "tiktok-key",
      TIKTOK_CLIENT_SECRET: "tiktok-secret",
      GOOGLE_CLIENT_ID: "google-id",
      GOOGLE_CLIENT_SECRET: "google-secret",
      LINKEDIN_CLIENT_ID: "linkedin-id",
      LINKEDIN_CLIENT_SECRET: "linkedin-secret",
      X_CLIENT_ID: "x-id",
      X_CLIENT_SECRET: "x-secret",
    })
  ) {
    Deno.env.set(name, value);
  }

  for (
    const provider of [
      "instagram",
      "facebook_pages",
      "tiktok",
      "youtube",
      "linkedin",
      "x",
    ] as const
  ) {
    const config = providerConfig(provider);
    if (new URL(config.authorizeUrl).protocol !== "https:") {
      throw new Error(`${provider} authorization does not use HTTPS`);
    }
    if (new URL(config.tokenUrl).protocol !== "https:") {
      throw new Error(`${provider} token exchange does not use HTTPS`);
    }
    if (config.scopes.length === 0) {
      throw new Error(`${provider} has no requested scopes`);
    }
  }
  if (!providerConfig("youtube").usesPkce || !providerConfig("x").usesPkce) {
    throw new Error("Google and X authorization must use PKCE");
  }
});

Deno.test("OAuth app redirect cannot be changed to an external site", () => {
  Deno.env.set("OAUTH_APP_REDIRECT_URL", "https://attacker.invalid");
  let rejected = false;
  try {
    appRedirectUrl("connected", "x");
  } catch {
    rejected = true;
  }
  if (!rejected) throw new Error("An external callback URL was accepted");
});

Deno.test("OAuth app redirects to the registered callback route", () => {
  Deno.env.delete("OAUTH_APP_REDIRECT_URL");
  const url = new URL(appRedirectUrl("connected", "x"));
  if (
    url.protocol !== "com.onepost.mobile:" ||
    url.hostname !== "oauth-callback" ||
    url.pathname !== "/oauth-callback" ||
    url.searchParams.get("provider") !== "x"
  ) {
    throw new Error("The callback deep link does not target the OnePost route");
  }
});

Deno.test("state hashes are stable and one-way sized", async () => {
  const hash = await sha256Hex("oauth-state-example");
  if (hash.length !== 64 || hash !== await sha256Hex("oauth-state-example")) {
    throw new Error("State hashing is not stable SHA-256");
  }
});
