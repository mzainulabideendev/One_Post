export const providers = [
  "instagram",
  "facebook_pages",
  "tiktok",
  "youtube",
  "linkedin",
  "x",
] as const;

export type Provider = (typeof providers)[number];

export interface ProviderConfig {
  clientId: string;
  clientSecret: string;
  authorizeUrl: string;
  tokenUrl: string;
  scopes: string[];
  usesPkce: boolean;
}

export interface OAuthState {
  user_id: string;
  provider: Provider;
  encrypted_pkce_verifier: string | null;
}

export interface ProviderAccount {
  provider_account_id: string;
  account_name: string;
  username: string | null;
  avatar_url: string | null;
  account_type: string | null;
  access_token: string;
  refresh_token: string | null;
  expires_in: number | null;
  scopes: string[];
}

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
  "Cache-Control": "no-store",
};

export function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), { status, headers: corsHeaders });
}

export function isProvider(value: unknown): value is Provider {
  return typeof value === "string" && providers.includes(value as Provider);
}

export function requiredEnv(name: string): string {
  const value = Deno.env.get(name)?.trim();
  if (!value) throw new Error(`Missing server configuration: ${name}`);
  return value;
}

export function supabaseUrl(): string {
  return requiredEnv("SUPABASE_URL").replace(/\/+$/, "");
}

export function serviceHeaders(): HeadersInit {
  const key = requiredEnv("SUPABASE_SERVICE_ROLE_KEY");
  return {
    apikey: key,
    Authorization: `Bearer ${key}`,
    "Content-Type": "application/json",
  };
}

export function callbackUrl(): string {
  const configured = Deno.env.get("OAUTH_CALLBACK_URL")?.trim();
  const url = configured ||
    `${supabaseUrl()}/functions/v1/oauth-callback`;
  const parsed = new URL(url);
  if (parsed.protocol !== "https:" || parsed.search || parsed.hash) {
    throw new Error("OAuth callback URL must be a fixed HTTPS URL");
  }
  return parsed.toString();
}

export function appRedirectUrl(
  status: "connected" | "error",
  provider: Provider,
): string {
  const configured = Deno.env.get("OAUTH_APP_REDIRECT_URL")?.trim() ||
    "com.onepost.mobile://oauth-callback/oauth-callback";
  const url = new URL(configured);
  if (
    url.protocol !== "com.onepost.mobile:" ||
    url.hostname !== "oauth-callback" ||
    url.pathname !== "/oauth-callback"
  ) {
    throw new Error(
      "OAuth app redirect URL is not an allowed OnePost deep link",
    );
  }
  url.searchParams.set("status", status);
  url.searchParams.set("provider", provider);
  return url.toString();
}

export function graphApiVersion(): string {
  const value = Deno.env.get("META_GRAPH_API_VERSION")?.trim() || "v26.0";
  if (!/^v\d+\.\d+$/.test(value)) {
    throw new Error("META_GRAPH_API_VERSION must look like v26.0");
  }
  return value;
}

export function providerConfig(provider: Provider): ProviderConfig {
  const metaVersion = provider === "instagram" || provider === "facebook_pages"
    ? graphApiVersion()
    : "v26.0";
  const definitions: Record<
    Provider,
    Omit<ProviderConfig, "clientId" | "clientSecret"> & {
      clientIdName: string;
      clientSecretName: string;
    }
  > = {
    instagram: {
      clientIdName: "INSTAGRAM_CLIENT_ID",
      clientSecretName: "INSTAGRAM_CLIENT_SECRET",
      authorizeUrl: "https://www.instagram.com/oauth/authorize",
      tokenUrl: "https://api.instagram.com/oauth/access_token",
      scopes: [
        "instagram_business_basic",
        "instagram_business_content_publish",
      ],
      usesPkce: false,
    },
    facebook_pages: {
      clientIdName: "FACEBOOK_CLIENT_ID",
      clientSecretName: "FACEBOOK_CLIENT_SECRET",
      authorizeUrl: `https://www.facebook.com/${metaVersion}/dialog/oauth`,
      tokenUrl: `https://graph.facebook.com/${metaVersion}/oauth/access_token`,
      scopes: [
        "pages_show_list",
        "pages_read_engagement",
        "pages_manage_posts",
      ],
      usesPkce: false,
    },
    tiktok: {
      clientIdName: "TIKTOK_CLIENT_KEY",
      clientSecretName: "TIKTOK_CLIENT_SECRET",
      authorizeUrl: "https://www.tiktok.com/v2/auth/authorize/",
      tokenUrl: "https://open.tiktokapis.com/v2/oauth/token/",
      scopes: ["user.info.basic", "video.publish"],
      usesPkce: false,
    },
    youtube: {
      clientIdName: "GOOGLE_CLIENT_ID",
      clientSecretName: "GOOGLE_CLIENT_SECRET",
      authorizeUrl: "https://accounts.google.com/o/oauth2/v2/auth",
      tokenUrl: "https://oauth2.googleapis.com/token",
      scopes: [
        "openid",
        "profile",
        "https://www.googleapis.com/auth/youtube.readonly",
        "https://www.googleapis.com/auth/youtube.upload",
      ],
      usesPkce: true,
    },
    linkedin: {
      clientIdName: "LINKEDIN_CLIENT_ID",
      clientSecretName: "LINKEDIN_CLIENT_SECRET",
      authorizeUrl: "https://www.linkedin.com/oauth/v2/authorization",
      tokenUrl: "https://www.linkedin.com/oauth/v2/accessToken",
      scopes: ["openid", "profile", "w_member_social"],
      usesPkce: false,
    },
    x: {
      clientIdName: "X_CLIENT_ID",
      clientSecretName: "X_CLIENT_SECRET",
      authorizeUrl: "https://x.com/i/oauth2/authorize",
      tokenUrl: "https://api.x.com/2/oauth2/token",
      scopes: [
        "users.read",
        "tweet.read",
        "tweet.write",
        "media.write",
        "offline.access",
      ],
      usesPkce: true,
    },
  };
  const definition = definitions[provider];
  return {
    clientId: requiredEnv(definition.clientIdName),
    clientSecret: requiredEnv(definition.clientSecretName),
    authorizeUrl: definition.authorizeUrl,
    tokenUrl: definition.tokenUrl,
    scopes: definition.scopes,
    usesPkce: definition.usesPkce,
  };
}

function base64Url(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replaceAll("+", "-").replaceAll("/", "_").replace(
    /=+$/,
    "",
  );
}

function fromBase64Url(value: string): Uint8Array {
  const normalized = value.replaceAll("-", "+").replaceAll("_", "/");
  const binary = atob(normalized + "=".repeat((4 - normalized.length % 4) % 4));
  return Uint8Array.from(binary, (character) => character.charCodeAt(0));
}

function arrayBuffer(bytes: Uint8Array): ArrayBuffer {
  const buffer = new ArrayBuffer(bytes.length);
  new Uint8Array(buffer).set(bytes);
  return buffer;
}

export function randomToken(byteLength = 32): string {
  return base64Url(crypto.getRandomValues(new Uint8Array(byteLength)));
}

export async function sha256Hex(value: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return [...new Uint8Array(digest)].map((byte) =>
    byte.toString(16).padStart(2, "0")
  ).join("");
}

export async function pkceChallenge(verifier: string): Promise<string> {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(verifier),
  );
  return base64Url(new Uint8Array(digest));
}

async function encryptionKey(): Promise<CryptoKey> {
  const key = fromBase64Url(requiredEnv("OAUTH_ENCRYPTION_KEY"));
  if (key.length !== 32) {
    throw new Error(
      "OAUTH_ENCRYPTION_KEY must be a base64url-encoded 32-byte key",
    );
  }
  return await crypto.subtle.importKey(
    "raw",
    arrayBuffer(key),
    "AES-GCM",
    false,
    ["encrypt", "decrypt"],
  );
}

export async function encryptSecret(value: string): Promise<string> {
  const iv = crypto.getRandomValues(new Uint8Array(12));
  const ciphertext = await crypto.subtle.encrypt(
    { name: "AES-GCM", iv: arrayBuffer(iv) },
    await encryptionKey(),
    new TextEncoder().encode(value),
  );
  return `v1.${base64Url(iv)}.${base64Url(new Uint8Array(ciphertext))}`;
}

export async function decryptSecret(value: string): Promise<string> {
  const [version, encodedIv, encodedCiphertext, extra] = value.split(".");
  if (version !== "v1" || !encodedIv || !encodedCiphertext || extra) {
    throw new Error("Encrypted OAuth state has an unsupported format");
  }
  const plaintext = await crypto.subtle.decrypt(
    { name: "AES-GCM", iv: arrayBuffer(fromBase64Url(encodedIv)) },
    await encryptionKey(),
    arrayBuffer(fromBase64Url(encodedCiphertext)),
  );
  return new TextDecoder().decode(plaintext);
}

export async function verifyUser(accessToken: string): Promise<string> {
  const response = await fetch(`${supabaseUrl()}/auth/v1/user`, {
    headers: {
      apikey: requiredEnv("SUPABASE_ANON_KEY"),
      Authorization: `Bearer ${accessToken}`,
    },
    signal: AbortSignal.timeout(10_000),
  });
  if (!response.ok) throw new Error("Invalid or expired OnePost session");
  const user = await response.json();
  if (typeof user.id !== "string") {
    throw new Error("Authenticated user has no ID");
  }
  return user.id;
}

export async function postServiceTable(
  table: string,
  value: unknown,
  prefer = "return=minimal",
): Promise<void> {
  const response = await fetch(`${supabaseUrl()}/rest/v1/${table}`, {
    method: "POST",
    headers: { ...serviceHeaders(), Prefer: prefer },
    body: JSON.stringify(value),
    signal: AbortSignal.timeout(10_000),
  });
  if (!response.ok) throw new Error("Could not save OAuth authorization state");
}

export async function callServiceRpc<T>(
  name: string,
  args: Record<string, unknown>,
): Promise<T> {
  const response = await fetch(`${supabaseUrl()}/rest/v1/rpc/${name}`, {
    method: "POST",
    headers: serviceHeaders(),
    body: JSON.stringify(args),
    signal: AbortSignal.timeout(15_000),
  });
  if (!response.ok) throw new Error(`OAuth database operation failed: ${name}`);
  return await response.json() as T;
}

export async function removeExpiredStates(): Promise<void> {
  const response = await fetch(
    `${supabaseUrl()}/rest/v1/oauth_authorization_states?expires_at=lt.${
      encodeURIComponent(new Date().toISOString())
    }`,
    {
      method: "DELETE",
      headers: serviceHeaders(),
      signal: AbortSignal.timeout(10_000),
    },
  );
  if (!response.ok) throw new Error("Could not clean up expired OAuth states");
}

export async function providerJson(
  url: string,
  init: RequestInit,
): Promise<Record<string, unknown>> {
  const response = await fetch(url, {
    ...init,
    signal: AbortSignal.timeout(20_000),
  });
  let value: unknown;
  try {
    value = await response.json();
  } catch {
    throw new Error("Provider returned an invalid response");
  }
  if (
    !response.ok || !value || typeof value !== "object" || Array.isArray(value)
  ) {
    throw new Error("Provider authorization request failed");
  }
  const result = value as Record<string, unknown>;
  if (typeof result.error === "string" && result.error !== "ok") {
    throw new Error("Provider authorization request failed");
  }
  if (result.error && typeof result.error === "object") {
    const providerError = result.error as Record<string, unknown>;
    if (typeof providerError.code !== "string" || providerError.code !== "ok") {
      throw new Error("Provider authorization request failed");
    }
  }
  return result;
}

export function stringField(value: unknown, name: string): string {
  if (!value || typeof value !== "object") {
    throw new Error("Provider response is incomplete");
  }
  const field = (value as Record<string, unknown>)[name];
  if (typeof field !== "string" || field.length === 0) {
    throw new Error("Provider response is incomplete");
  }
  return field;
}

export function optionalString(value: unknown, name: string): string | null {
  if (!value || typeof value !== "object") return null;
  const field = (value as Record<string, unknown>)[name];
  return typeof field === "string" && field.length > 0 ? field : null;
}

export function numberField(value: unknown, name: string): number | null {
  if (!value || typeof value !== "object") return null;
  const field = (value as Record<string, unknown>)[name];
  return typeof field === "number" && Number.isFinite(field) && field > 0
    ? field
    : null;
}

export function asRecord(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== "object" || Array.isArray(value)) {
    throw new Error("Provider response is incomplete");
  }
  return value as Record<string, unknown>;
}

export function asArray(value: unknown): unknown[] {
  return Array.isArray(value) ? value : [];
}

export function scopesFrom(value: unknown, fallback: string[]): string[] {
  if (typeof value !== "string" || !value.trim()) return fallback;
  return value.split(/[,\s]+/).filter(Boolean);
}
