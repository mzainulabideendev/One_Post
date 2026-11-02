create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = public, pg_temp
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
revoke all on function public.set_updated_at() from public, anon, authenticated;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public, auth, pg_temp
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, nullif(new.raw_user_meta_data ->> 'display_name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;
revoke all on function public.handle_new_user() from public, anon, authenticated;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

create table public.social_accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  provider text not null check (
    provider in ('instagram', 'facebook_pages', 'tiktok', 'youtube', 'linkedin', 'x')
  ),
  provider_account_id text not null,
  account_name text not null,
  account_type text,
  username text,
  avatar_url text,
  status text not null default 'connected'
    check (status in ('connected', 'pending', 'reauth_required', 'error', 'disconnected')),
  granted_scopes text[] not null default '{}',
  token_expires_at timestamptz,
  last_verified_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, provider, provider_account_id)
);

create table public.oauth_credentials (
  social_account_id uuid primary key
    references public.social_accounts(id) on delete cascade,
  access_token_ciphertext text not null,
  refresh_token_ciphertext text,
  key_version integer not null check (key_version > 0),
  updated_at timestamptz not null default now()
);

create table public.posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text,
  base_caption text not null default '',
  status text not null default 'draft'
    check (status in (
      'draft', 'queued', 'publishing', 'completed',
      'partially_completed', 'failed', 'cancelled'
    )),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (char_length(base_caption) <= 10000),
  unique (id, user_id)
);

create table public.post_destinations (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.posts(id) on delete cascade,
  social_account_id uuid not null
    references public.social_accounts(id) on delete restrict,
  caption_override text,
  media_config jsonb not null default '{}'::jsonb,
  destination_status text not null default 'draft'
    check (destination_status in (
      'draft', 'queued', 'processing', 'uploading',
      'awaiting_provider_processing', 'published', 'failed',
      'retry_wait', 'authentication_required', 'cancelled', 'outcome_unknown'
    )),
  provider_post_id text,
  provider_post_url text,
  provider_request_id text,
  error_code text,
  sanitized_error_message text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (post_id, social_account_id)
);

create table public.publishing_batches (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  post_id uuid not null references public.posts(id) on delete cascade,
  idempotency_key text not null,
  status text not null default 'queued'
    check (status in (
      'queued', 'publishing', 'completed', 'partially_completed',
      'failed', 'cancelled', 'outcome_unknown'
    )),
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  unique (user_id, idempotency_key)
);

create table public.publishing_jobs (
  id uuid primary key default gen_random_uuid(),
  batch_id uuid not null references public.publishing_batches(id) on delete cascade,
  destination_id uuid not null
    references public.post_destinations(id) on delete cascade,
  status text not null default 'queued'
    check (status in (
      'queued', 'processing', 'uploading', 'awaiting_provider_processing',
      'published', 'failed', 'retry_wait', 'authentication_required',
      'cancelled', 'outcome_unknown'
    )),
  attempt_count integer not null default 0 check (attempt_count >= 0),
  next_attempt_at timestamptz,
  lease_expires_at timestamptz,
  last_error_code text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (batch_id, destination_id)
);

create table public.media_assets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  post_id uuid not null references public.posts(id) on delete cascade,
  storage_path text not null unique,
  mime_type text not null check (
    mime_type in ('image/jpeg', 'image/png', 'image/webp', 'video/mp4', 'video/webm')
  ),
  size_bytes bigint not null check (size_bytes > 0 and size_bytes <= 104857600),
  checksum text not null check (checksum ~ '^[0-9a-f]{64}$'),
  width integer check (width is null or width > 0),
  height integer check (height is null or height > 0),
  duration_ms bigint check (duration_ms is null or duration_ms > 0),
  processing_status text not null default 'uploaded'
    check (processing_status in ('pending', 'uploaded', 'processing', 'ready', 'failed')),
  created_at timestamptz not null default now(),
  foreign key (post_id, user_id)
    references public.posts(id, user_id) on delete cascade
);

create table public.provider_webhook_events (
  id uuid primary key default gen_random_uuid(),
  provider text not null,
  external_event_id text not null,
  received_at timestamptz not null default now(),
  processed_at timestamptz,
  processing_status text not null default 'received'
    check (processing_status in ('received', 'processing', 'processed', 'failed')),
  unique (provider, external_event_id)
);

create table public.audit_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  action text not null,
  resource_type text not null,
  resource_id text,
  created_at timestamptz not null default now()
);

create table public.oauth_authorization_states (
  state_hash text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  provider text not null check (
    provider in ('instagram', 'facebook_pages', 'tiktok', 'youtube', 'linkedin', 'x')
  ),
  encrypted_pkce_verifier text,
  expires_at timestamptz not null,
  consumed_at timestamptz,
  created_at timestamptz not null default now()
);

create index social_accounts_user_idx on public.social_accounts(user_id);
create index posts_user_created_idx on public.posts(user_id, created_at desc);
create index post_destinations_post_idx on public.post_destinations(post_id);
create index post_destinations_account_idx on public.post_destinations(social_account_id);
create index publishing_batches_user_created_idx
  on public.publishing_batches(user_id, created_at desc);
create index publishing_jobs_dispatch_idx
  on public.publishing_jobs(status, next_attempt_at, lease_expires_at);
create index media_assets_user_created_idx on public.media_assets(user_id, created_at desc);
create index webhook_events_received_idx
  on public.provider_webhook_events(processing_status, received_at);
create index audit_events_user_created_idx on public.audit_events(user_id, created_at desc);
create index oauth_states_expiry_idx on public.oauth_authorization_states(expires_at);

create trigger profiles_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger social_accounts_updated_at
before update on public.social_accounts
for each row execute function public.set_updated_at();

create trigger posts_updated_at
before update on public.posts
for each row execute function public.set_updated_at();

create trigger post_destinations_updated_at
before update on public.post_destinations
for each row execute function public.set_updated_at();

create trigger publishing_jobs_updated_at
before update on public.publishing_jobs
for each row execute function public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.social_accounts enable row level security;
alter table public.oauth_credentials enable row level security;
alter table public.posts enable row level security;
alter table public.post_destinations enable row level security;
alter table public.publishing_batches enable row level security;
alter table public.publishing_jobs enable row level security;
alter table public.media_assets enable row level security;
alter table public.provider_webhook_events enable row level security;
alter table public.audit_events enable row level security;
alter table public.oauth_authorization_states enable row level security;

create policy "Users read own profile" on public.profiles
for select to authenticated using (id = auth.uid());
create policy "Users update own profile" on public.profiles
for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

create policy "Users read own social accounts" on public.social_accounts
for select to authenticated using (user_id = auth.uid());

create policy "Users read own posts" on public.posts
for select to authenticated using (user_id = auth.uid());

create policy "Users read own destinations" on public.post_destinations
for select to authenticated using (
  exists (
    select 1 from public.posts p
    where p.id = post_id and p.user_id = auth.uid()
  )
);

create policy "Users read own batches" on public.publishing_batches
for select to authenticated using (user_id = auth.uid());
create policy "Users read own jobs" on public.publishing_jobs
for select to authenticated using (
  exists (
    select 1 from public.publishing_batches b
    where b.id = batch_id and b.user_id = auth.uid()
  )
);

create policy "Users read own media metadata" on public.media_assets
for select to authenticated using (user_id = auth.uid());
create policy "Users add own media metadata" on public.media_assets
for insert to authenticated with check (
  user_id = auth.uid()
  and exists (
    select 1 from public.posts p
    where p.id = post_id and p.user_id = auth.uid() and p.status = 'draft'
  )
  and processing_status = 'uploaded'
  and storage_path like auth.uid()::text || '/%'
);

create policy "Users read own audit events" on public.audit_events
for select to authenticated using (user_id = auth.uid());

revoke all on all tables in schema public from anon, authenticated;
revoke all on all functions in schema public from public, anon, authenticated;

grant all on all tables in schema public to service_role;
grant usage on schema public to authenticated;
grant select on public.profiles to authenticated;
grant update (display_name) on public.profiles to authenticated;
grant select on public.social_accounts to authenticated;
grant select on public.posts to authenticated;
grant select on public.post_destinations to authenticated;
grant select on public.publishing_batches to authenticated;
grant select on public.publishing_jobs to authenticated;
grant select, insert on public.media_assets to authenticated;
grant select on public.audit_events to authenticated;

revoke all on public.oauth_credentials from anon, authenticated;
revoke all on public.oauth_authorization_states from anon, authenticated;
revoke all on public.provider_webhook_events from anon, authenticated;
revoke all on public.publishing_jobs from anon, authenticated;

create or replace function public.create_post_draft(
  p_base_caption text,
  p_social_account_ids uuid[] default '{}'::uuid[]
)
returns uuid
language plpgsql
security definer
set search_path = public, auth, pg_temp
as $$
declare
  v_user_id uuid := auth.uid();
  v_post_id uuid;
  v_account_count integer;
begin
  if v_user_id is null then
    raise exception using errcode = '28000', message = 'Authentication required.';
  end if;
  if p_base_caption is null or char_length(p_base_caption) > 10000 then
    raise exception using errcode = '22023', message = 'Caption is invalid or too long.';
  end if;
  if coalesce(cardinality(p_social_account_ids), 0) > 20 then
    raise exception using errcode = '22023', message = 'Too many destinations.';
  end if;
  if coalesce(cardinality(p_social_account_ids), 0) <>
     (select count(distinct selected.account_id)
      from unnest(coalesce(p_social_account_ids, '{}'::uuid[]))
        as selected(account_id)) then
    raise exception using errcode = '22023', message = 'Duplicate destination selected.';
  end if;

  select count(*) into v_account_count
  from public.social_accounts sa
  where sa.id = any(coalesce(p_social_account_ids, '{}'))
    and sa.user_id = v_user_id
    and sa.status = 'connected';

  if v_account_count <> coalesce(cardinality(p_social_account_ids), 0) then
    raise exception using errcode = '42501', message = 'A destination is unavailable or not owned by this user.';
  end if;

  insert into public.posts (user_id, base_caption, status)
  values (v_user_id, p_base_caption, 'draft')
  returning id into v_post_id;

  insert into public.post_destinations (post_id, social_account_id, destination_status)
  select v_post_id, sa.id, 'draft'
  from public.social_accounts sa
  where sa.id = any(coalesce(p_social_account_ids, '{}'))
    and sa.user_id = v_user_id;

  return v_post_id;
end;
$$;

revoke all on function public.create_post_draft(text, uuid[]) from public, anon;
grant execute on function public.create_post_draft(text, uuid[]) to authenticated;

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'onepost-media',
  'onepost-media',
  false,
  104857600,
  array['image/jpeg', 'image/png', 'image/webp', 'video/mp4', 'video/webm']
)
on conflict (id) do update set
  public = false,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

create policy "Users read own private media" on storage.objects
for select to authenticated using (
  bucket_id = 'onepost-media'
  and (storage.foldername(name))[1] = auth.uid()::text
);
create policy "Users upload own private media" on storage.objects
for insert to authenticated with check (
  bucket_id = 'onepost-media'
  and (storage.foldername(name))[1] = auth.uid()::text
);
create policy "Users delete own private media" on storage.objects
for delete to authenticated using (
  bucket_id = 'onepost-media'
  and (storage.foldername(name))[1] = auth.uid()::text
);
