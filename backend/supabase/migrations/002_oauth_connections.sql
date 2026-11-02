create or replace function public.consume_oauth_authorization_state(p_state_hash text)
returns table (
  user_id uuid,
  provider text,
  encrypted_pkce_verifier text
)
language plpgsql
security definer
set search_path = public, pg_temp
as $$
begin
  return query
  update public.oauth_authorization_states as oauth_state
  set consumed_at = now()
  where oauth_state.state_hash = p_state_hash
    and oauth_state.consumed_at is null
    and oauth_state.expires_at > now()
  returning
    oauth_state.user_id,
    oauth_state.provider,
    oauth_state.encrypted_pkce_verifier;
end;
$$;
revoke all on function public.consume_oauth_authorization_state(text)
  from public, anon, authenticated;
grant execute on function public.consume_oauth_authorization_state(text)
  to service_role;

create or replace function public.complete_oauth_connection(
  p_user_id uuid,
  p_provider text,
  p_connections jsonb
)
returns integer
language plpgsql
security definer
set search_path = public, pg_temp
as $$
declare
  v_connection jsonb;
  v_account_id uuid;
  v_count integer := 0;
  v_provider_account_id text;
  v_account_name text;
  v_scopes text[];
begin
  if p_user_id is null
    or p_provider is null
    or p_provider not in (
      'instagram',
      'facebook_pages',
      'tiktok',
      'youtube',
      'linkedin',
      'x'
    )
    or p_connections is null
    or jsonb_typeof(p_connections) <> 'array'
    or jsonb_array_length(p_connections) < 1
    or jsonb_array_length(p_connections) > 100 then
    raise exception using
      errcode = '22023',
      message = 'OAuth connection payload is invalid.';
  end if;

  if exists (
    select 1
    from jsonb_array_elements(p_connections) as item(value)
    group by item.value ->> 'provider_account_id'
    having count(*) > 1
  ) then
    raise exception using
      errcode = '22023',
      message = 'OAuth connection contains duplicate accounts.';
  end if;

  for v_connection in
    select item.value from jsonb_array_elements(p_connections) as item(value)
  loop
    v_provider_account_id := nullif(v_connection ->> 'provider_account_id', '');
    v_account_name := nullif(v_connection ->> 'account_name', '');
    if v_provider_account_id is null
      or v_account_name is null
      or nullif(v_connection ->> 'access_token_ciphertext', '') is null
      or coalesce((v_connection ->> 'key_version')::integer, 0) <> 1
      or jsonb_typeof(coalesce(v_connection -> 'granted_scopes', '[]'::jsonb)) <> 'array' then
      raise exception using
        errcode = '22023',
        message = 'OAuth account data is incomplete.';
    end if;

    select array_agg(scope.value)
    into v_scopes
    from jsonb_array_elements_text(
      coalesce(v_connection -> 'granted_scopes', '[]'::jsonb)
    ) as scope(value);

    insert into public.social_accounts (
      user_id,
      provider,
      provider_account_id,
      account_name,
      account_type,
      username,
      avatar_url,
      status,
      granted_scopes,
      token_expires_at,
      last_verified_at
    )
    values (
      p_user_id,
      p_provider,
      v_provider_account_id,
      v_account_name,
      v_connection ->> 'account_type',
      v_connection ->> 'username',
      v_connection ->> 'avatar_url',
      'connected',
      coalesce(v_scopes, '{}'::text[]),
      nullif(v_connection ->> 'expires_at', '')::timestamptz,
      now()
    )
    on conflict (user_id, provider, provider_account_id)
    do update set
      account_name = excluded.account_name,
      account_type = excluded.account_type,
      username = excluded.username,
      avatar_url = excluded.avatar_url,
      status = 'connected',
      granted_scopes = excluded.granted_scopes,
      token_expires_at = excluded.token_expires_at,
      last_verified_at = now(),
      updated_at = now()
    returning id into v_account_id;

    insert into public.oauth_credentials (
      social_account_id,
      access_token_ciphertext,
      refresh_token_ciphertext,
      key_version
    )
    values (
      v_account_id,
      v_connection ->> 'access_token_ciphertext',
      nullif(v_connection ->> 'refresh_token_ciphertext', ''),
      (v_connection ->> 'key_version')::integer
    )
    on conflict (social_account_id)
    do update set
      access_token_ciphertext = excluded.access_token_ciphertext,
      refresh_token_ciphertext = coalesce(
        excluded.refresh_token_ciphertext,
        public.oauth_credentials.refresh_token_ciphertext
      ),
      key_version = excluded.key_version,
      updated_at = now();

    insert into public.audit_events (user_id, action, resource_type, resource_id)
    values (p_user_id, 'social_account_connected', 'social_account', v_account_id::text);
    v_count := v_count + 1;
  end loop;

  return v_count;
end;
$$;
revoke all on function public.complete_oauth_connection(uuid, text, jsonb)
  from public, anon, authenticated;
grant execute on function public.complete_oauth_connection(uuid, text, jsonb)
  to service_role;
