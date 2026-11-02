import {
  appRedirectUrl,
  asArray,
  asRecord,
  callbackUrl,
  callServiceRpc,
  decryptSecret,
  encryptSecret,
  graphApiVersion,
  numberField,
  type OAuthState,
  optionalString,
  type Provider,
  type ProviderAccount,
  providerConfig,
  providerJson,
  requiredEnv,
  scopesFrom,
  sha256Hex,
  stringField,
} from "../_shared/oauth.ts";

interface TokenSet {
  accessToken: string;
  refreshToken: string | null;
  expiresIn: number | null;
  scopes: string[];
}

const META_API = "https://graph.facebook.com";

function formBody(values: Record<string, string>): URLSearchParams {
  return new URLSearchParams(values);
}

async function postForm(
  url: string,
  values: Record<string, string>,
): Promise<Record<string, unknown>> {
  return await providerJson(url, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: formBody(values),
  });
}

function tokenSet(
  response: Record<string, unknown>,
): TokenSet {
  const rawScopes = response.scope ?? response.permissions;
  return {
    accessToken: stringField(response, "access_token"),
    refreshToken: optionalString(response, "refresh_token"),
    expiresIn: numberField(response, "expires_in"),
    scopes: scopesFrom(
      typeof rawScopes === "string" ? rawScopes : null,
      [],
    ),
  };
}

async function exchangeCode(
  provider: Provider,
  code: string,
  verifier: string | null,
): Promise<TokenSet> {
  const config = providerConfig(provider);
  const redirectUri = callbackUrl();

  if (provider === "instagram") {
    const form = new FormData();
    form.set("client_id", config.clientId);
    form.set("client_secret", config.clientSecret);
    form.set("grant_type", "authorization_code");
    form.set("redirect_uri", redirectUri);
    form.set("code", code);
    const shortTokenResponse = await providerJson(config.tokenUrl, {
      method: "POST",
      body: form,
    });
    const shortToken = tokenSet(
      asRecord(asArray(shortTokenResponse.data)[0]),
    );
    const longLivedUrl = new URL("https://graph.instagram.com/access_token");
    longLivedUrl.search = new URLSearchParams({
      grant_type: "ig_exchange_token",
      client_secret: config.clientSecret,
      access_token: shortToken.accessToken,
    }).toString();
    const longToken = await providerJson(longLivedUrl.toString(), {
      method: "GET",
    });
    const result = tokenSet(longToken);
    return { ...result, scopes: shortToken.scopes };
  }

  if (provider === "facebook_pages") {
    const shortToken = tokenSet(
      await postForm(config.tokenUrl, {
        client_id: config.clientId,
        client_secret: config.clientSecret,
        redirect_uri: redirectUri,
        code,
      }),
    );
    const longLivedUrl = new URL(config.tokenUrl);
    longLivedUrl.search = new URLSearchParams({
      grant_type: "fb_exchange_token",
      client_id: config.clientId,
      client_secret: config.clientSecret,
      fb_exchange_token: shortToken.accessToken,
    }).toString();
    const longToken = await providerJson(longLivedUrl.toString(), {
      method: "GET",
    });
    const grantedPermissions = await facebookGrantedPermissions(
      stringField(longToken, "access_token"),
    );
    return {
      ...tokenSet(longToken),
      scopes: grantedPermissions.length > 0
        ? grantedPermissions
        : shortToken.scopes,
    };
  }

  if (provider === "tiktok") {
    const response = await postForm(config.tokenUrl, {
      client_key: config.clientId,
      client_secret: config.clientSecret,
      code,
      grant_type: "authorization_code",
      redirect_uri: redirectUri,
    });
    const data = asRecord(response.data);
    return tokenSet(data);
  }

  const fields: Record<string, string> = {
    code,
    redirect_uri: redirectUri,
    grant_type: "authorization_code",
  };
  if (provider === "x") {
    if (!verifier) {
      throw new Error("X authorization is missing its PKCE verifier");
    }
    fields.code_verifier = verifier;
    const credentials = btoa(
      `${encodeURIComponent(config.clientId)}:${
        encodeURIComponent(config.clientSecret)
      }`,
    );
    const response = await providerJson(config.tokenUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${credentials}`,
      },
      body: formBody(fields),
    });
    return tokenSet(response);
  }
  fields.client_id = config.clientId;
  fields.client_secret = config.clientSecret;
  if (verifier) fields.code_verifier = verifier;
  return tokenSet(await postForm(config.tokenUrl, fields));
}

async function facebookGrantedPermissions(
  accessToken: string,
): Promise<string[]> {
  const version = graphApiVersion();
  const url = new URL(`${META_API}/${version}/me/permissions`);
  const response = await providerJson(url.toString(), {
    method: "GET",
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  return asArray(response.data).flatMap((item) => {
    if (!item || typeof item !== "object" || Array.isArray(item)) return [];
    const permission = item as Record<string, unknown>;
    return permission.status === "granted" &&
        typeof permission.permission === "string"
      ? [permission.permission]
      : [];
  });
}

async function getProviderAccounts(
  provider: Provider,
  tokens: TokenSet,
): Promise<ProviderAccount[]> {
  if (provider === "instagram") {
    const profileUrl = new URL("https://graph.instagram.com/me");
    profileUrl.search = new URLSearchParams({
      fields: "user_id,username",
    }).toString();
    const profile = await providerJson(profileUrl.toString(), {
      method: "GET",
      headers: { Authorization: `Bearer ${tokens.accessToken}` },
    });
    const id = String(profile.user_id ?? profile.id ?? "");
    const username = optionalString(profile, "username");
    if (!id || !username) {
      throw new Error("Instagram did not return an eligible account");
    }
    return [{
      provider_account_id: id,
      account_name: username,
      username,
      avatar_url: null,
      account_type: "professional",
      access_token: tokens.accessToken,
      refresh_token: null,
      expires_in: tokens.expiresIn,
      scopes: tokens.scopes,
    }];
  }

  if (provider === "facebook_pages") {
    const version = graphApiVersion();
    const accounts: ProviderAccount[] = [];
    let after: string | null = null;
    for (let page = 0; page < 20; page++) {
      const url = new URL(`${META_API}/${version}/me/accounts`);
      url.searchParams.set("fields", "id,name,access_token,category,tasks");
      url.searchParams.set("limit", "100");
      if (after) url.searchParams.set("after", after);
      const response = await providerJson(url.toString(), {
        method: "GET",
        headers: { Authorization: `Bearer ${tokens.accessToken}` },
      });
      for (const pageValue of asArray(response.data)) {
        const pageRecord = asRecord(pageValue);
        accounts.push({
          provider_account_id: stringField(pageRecord, "id"),
          account_name: stringField(pageRecord, "name"),
          username: null,
          avatar_url: null,
          account_type: optionalString(pageRecord, "category"),
          access_token: stringField(pageRecord, "access_token"),
          refresh_token: null,
          expires_in: tokens.expiresIn,
          scopes: tokens.scopes,
        });
      }
      const paging = response.paging && typeof response.paging === "object"
        ? asRecord(response.paging)
        : {};
      const cursors = paging.cursors && typeof paging.cursors === "object"
        ? asRecord(paging.cursors)
        : {};
      const next = optionalString(cursors, "after");
      if (!next || next === after) break;
      after = next;
    }
    if (accounts.length === 0) {
      throw new Error("No Facebook Pages are available to this user");
    }
    return accounts;
  }

  if (provider === "tiktok") {
    const response = await providerJson(
      "https://open.tiktokapis.com/v2/user/info/?fields=open_id,display_name,avatar_url",
      { headers: { Authorization: `Bearer ${tokens.accessToken}` } },
    );
    const user = asRecord(asRecord(response.data).user);
    const displayName = stringField(user, "display_name");
    return [{
      provider_account_id: stringField(user, "open_id"),
      account_name: displayName,
      username: optionalString(user, "username"),
      avatar_url: optionalString(user, "avatar_url"),
      account_type: "creator",
      access_token: tokens.accessToken,
      refresh_token: tokens.refreshToken,
      expires_in: tokens.expiresIn,
      scopes: tokens.scopes,
    }];
  }

  if (provider === "youtube") {
    const identity = await providerJson(
      "https://www.googleapis.com/oauth2/v2/userinfo",
      {
        headers: { Authorization: `Bearer ${tokens.accessToken}` },
      },
    );
    const accounts: ProviderAccount[] = [];
    let pageToken: string | null = null;
    for (let page = 0; page < 20; page++) {
      const url = new URL("https://www.googleapis.com/youtube/v3/channels");
      url.searchParams.set("part", "snippet");
      url.searchParams.set("mine", "true");
      url.searchParams.set("maxResults", "50");
      if (pageToken) url.searchParams.set("pageToken", pageToken);
      const response = await providerJson(url.toString(), {
        headers: { Authorization: `Bearer ${tokens.accessToken}` },
      });
      for (const channelValue of asArray(response.items)) {
        const channel = asRecord(channelValue);
        const snippet = asRecord(channel.snippet);
        accounts.push({
          provider_account_id: stringField(channel, "id"),
          account_name: stringField(snippet, "title"),
          username: optionalString(snippet, "customUrl") ??
            optionalString(identity, "email"),
          avatar_url: null,
          account_type: "channel",
          access_token: tokens.accessToken,
          refresh_token: tokens.refreshToken,
          expires_in: tokens.expiresIn,
          scopes: tokens.scopes,
        });
      }
      pageToken = optionalString(response, "nextPageToken");
      if (!pageToken) break;
    }
    if (accounts.length === 0) {
      throw new Error("No YouTube channels are available to this user");
    }
    return accounts;
  }

  if (provider === "linkedin") {
    const profile = await providerJson("https://api.linkedin.com/v2/userinfo", {
      headers: { Authorization: `Bearer ${tokens.accessToken}` },
    });
    const name = stringField(profile, "name");
    return [{
      provider_account_id: stringField(profile, "sub"),
      account_name: name,
      username: optionalString(profile, "email"),
      avatar_url: optionalString(profile, "picture"),
      account_type: "member",
      access_token: tokens.accessToken,
      refresh_token: tokens.refreshToken,
      expires_in: tokens.expiresIn,
      scopes: tokens.scopes,
    }];
  }

  const profile = await providerJson(
    "https://api.x.com/2/users/me?user.fields=name,username,profile_image_url",
    { headers: { Authorization: `Bearer ${tokens.accessToken}` } },
  );
  const user = asRecord(profile.data);
  return [{
    provider_account_id: stringField(user, "id"),
    account_name: stringField(user, "name"),
    username: optionalString(user, "username"),
    avatar_url: optionalString(user, "profile_image_url"),
    account_type: "user",
    access_token: tokens.accessToken,
    refresh_token: tokens.refreshToken,
    expires_in: tokens.expiresIn,
    scopes: tokens.scopes,
  }];
}

async function persistAccounts(
  state: OAuthState,
  accounts: ProviderAccount[],
): Promise<void> {
  const connections = await Promise.all(accounts.map(async (account) => ({
    provider_account_id: account.provider_account_id,
    account_name: account.account_name,
    username: account.username,
    avatar_url: account.avatar_url,
    account_type: account.account_type,
    access_token_ciphertext: await encryptSecret(account.access_token),
    refresh_token_ciphertext: account.refresh_token
      ? await encryptSecret(account.refresh_token)
      : null,
    key_version: 1,
    expires_at: account.expires_in
      ? new Date(Date.now() + account.expires_in * 1000).toISOString()
      : null,
    granted_scopes: account.scopes,
  })));
  await callServiceRpc("complete_oauth_connection", {
    p_user_id: state.user_id,
    p_provider: state.provider,
    p_connections: connections,
  });
}

function redirectToApp(
  status: "connected" | "error",
  provider: Provider,
): Response {
  return new Response(null, {
    status: 302,
    headers: {
      Location: appRedirectUrl(status, provider),
      "Cache-Control": "no-store",
      "Referrer-Policy": "no-referrer",
    },
  });
}

Deno.serve(async (request: Request): Promise<Response> => {
  if (request.method !== "GET") {
    return new Response("Method not allowed.", { status: 405 });
  }
  const requestUrl = new URL(request.url);
  const state = requestUrl.searchParams.get("state");
  const code = requestUrl.searchParams.get("code");
  if (!state || state.length > 512) {
    return new Response(
      "This authorization link is invalid or expired. Return to OnePost and try again.",
      {
        status: 400,
        headers: {
          "Cache-Control": "no-store",
          "Content-Type": "text/plain; charset=utf-8",
        },
      },
    );
  }

  let callbackProvider: Provider | null = null;
  try {
    requiredEnv("OAUTH_ENCRYPTION_KEY");
    const rows = await callServiceRpc<OAuthState[]>(
      "consume_oauth_authorization_state",
      { p_state_hash: await sha256Hex(state) },
    );
    const authorization = rows[0];
    if (!authorization) {
      return new Response(
        "This authorization link has expired or was already used. Return to OnePost and try again.",
        {
          status: 400,
          headers: {
            "Cache-Control": "no-store",
            "Content-Type": "text/plain; charset=utf-8",
          },
        },
      );
    }
    callbackProvider = authorization.provider;

    if (requestUrl.searchParams.has("error") || !code) {
      return redirectToApp("error", authorization.provider);
    }

    const encryptedVerifier = authorization.encrypted_pkce_verifier;
    const verifier = encryptedVerifier
      ? await decryptSecret(encryptedVerifier)
      : null;
    const tokens = await exchangeCode(authorization.provider, code, verifier);
    const accounts = await getProviderAccounts(authorization.provider, tokens);
    await persistAccounts(authorization, accounts);
    return redirectToApp("connected", authorization.provider);
  } catch (error) {
    console.error(
      "oauth-callback failed",
      error instanceof Error ? error.name : "unknown",
    );
    if (callbackProvider) return redirectToApp("error", callbackProvider);
    return new Response(
      "Account authorization could not be completed. Return to OnePost and try again.",
      {
        status: 502,
        headers: {
          "Cache-Control": "no-store",
          "Content-Type": "text/plain; charset=utf-8",
        },
      },
    );
  }
});
