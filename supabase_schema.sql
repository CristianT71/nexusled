create extension if not exists pgcrypto;

-- Create storage bucket for avatars
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

-- Storage policies for avatars bucket
drop policy if exists "avatars_public_select" on storage.objects;
create policy "avatars_public_select" on storage.objects
for select to public
using (bucket_id = 'avatars');

drop policy if exists "avatars_upload_own" on storage.objects;
create policy "avatars_upload_own" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists "avatars_update_own" on storage.objects;
create policy "avatars_update_own" on storage.objects
for update to authenticated
using (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
)
with check (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

drop policy if exists "avatars_delete_own" on storage.objects;
create policy "avatars_delete_own" on storage.objects
for delete to authenticated
using (
  bucket_id = 'avatars' and
  auth.uid()::text = (storage.foldername(name))[1]
);

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  full_name text,
  avatar_url text,
  phone text,
  auth_provider text not null default 'email',
  role text not null default 'user' check (role in ('user', 'admin', 'support')),
  biometric_enabled boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.mqtt_config (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  config_name text not null default 'Default EMQX Cloud',
  broker_host text not null,
  broker_port integer not null default 8883,
  websocket_port integer not null default 8084,
  use_ssl boolean not null default true,
  topic_control text not null default 'nexusled/led/control',
  topic_status text not null default 'nexusled/led/status',
  topic_color text not null default 'nexusled/led/color',
  topic_heartbeat text not null default 'nexusled/heartbeat',
  client_id text not null default '',
  username text not null default '',
  password text not null default '',
  qos integer not null default 1 check (qos in (0, 1, 2)),
  retain boolean not null default false,
  keep_alive integer not null default 60,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index if not exists idx_mqtt_config_user_id_unique on public.mqtt_config(user_id);

create table if not exists public.led_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  action text not null check (action in ('ON', 'OFF', 'TOGGLE')),
  previous_state text not null default 'UNKNOWN',
  new_state text not null check (new_state in ('ON', 'OFF', 'UNKNOWN')),
  source text not null default 'app',
  platform text not null default 'flutter',
  response_time_ms integer not null default 0,
  confirmed boolean not null default false,
  mqtt_message_id text,
  created_at timestamptz not null default now()
);

create table if not exists public.device_status (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  device_id text not null default 'arduino-nano-esp32',
  device_name text not null default 'Arduino Nano ESP32',
  led_state text not null default 'OFF' check (led_state in ('ON', 'OFF', 'UNKNOWN')),
  online boolean not null default false,
  simulator_active boolean not null default true,
  firmware_version text,
  ip_address text,
  mac_address text,
  rssi integer,
  uptime_seconds bigint not null default 0,
  last_seen_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, device_id)
);

create table if not exists public.support_tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  subject text not null,
  category text not null default 'general',
  priority text not null default 'medium' check (priority in ('low', 'medium', 'high', 'critical')),
  description text not null,
  status text not null default 'open' check (status in ('open', 'in_progress', 'resolved', 'closed')),
  admin_response text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  platform text not null default 'unknown',
  device_info text,
  ip_address text,
  user_agent text,
  signed_in_at timestamptz not null default now(),
  signed_out_at timestamptz
);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, username, full_name, avatar_url, phone, auth_provider)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'username', ''), split_part(new.email, '@', 1)),
    coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name', split_part(new.email, '@', 1)),
    new.raw_user_meta_data ->> 'avatar_url',
    new.raw_user_meta_data ->> 'phone',
    coalesce(new.raw_app_meta_data ->> 'provider', new.raw_user_meta_data ->> 'auth_provider', 'email')
  )
  on conflict (id) do update set
    username = excluded.username,
    full_name = excluded.full_name,
    avatar_url = coalesce(public.profiles.avatar_url, new.raw_user_meta_data ->> 'avatar_url'),
    phone = coalesce(public.profiles.phone, new.raw_user_meta_data ->> 'phone'),
    auth_provider = coalesce(new.raw_app_meta_data ->> 'provider', new.raw_user_meta_data ->> 'auth_provider', public.profiles.auth_provider),
    updated_at = now();

  insert into public.device_status (user_id)
  values (new.id)
  on conflict (user_id, device_id) do nothing;

  -- Create or update default MQTT config for new user (bypass RLS)
  begin
    insert into public.mqtt_config (user_id, config_name, broker_host, broker_port, websocket_port, use_ssl, topic_control, topic_status, topic_color, topic_heartbeat, client_id, username, password, qos, retain, keep_alive, is_active)
    values (
      new.id,
      'HiveMQ Public Broker',
      'broker.hivemq.com',
      1883,
      8000,
      false,
      'nexusled/led/control',
      'nexusled/led/status',
      'nexusled/led/color',
      'nexusled/heartbeat',
      '',
      '',
      '',
      1,
      false,
      60,
      true
    )
    on conflict (user_id) do update set
      config_name = excluded.config_name,
      broker_host = excluded.broker_host,
      broker_port = excluded.broker_port,
      websocket_port = excluded.websocket_port,
      use_ssl = excluded.use_ssl,
      topic_control = excluded.topic_control,
      topic_status = excluded.topic_status,
      topic_color = excluded.topic_color,
      topic_heartbeat = excluded.topic_heartbeat,
      client_id = excluded.client_id,
      username = excluded.username,
      password = excluded.password,
      qos = excluded.qos,
      retain = excluded.retain,
      keep_alive = excluded.keep_alive,
      is_active = excluded.is_active,
      updated_at = now();
  exception when others then
    -- Ignore errors if mqtt_config insert/update fails
    null;
  end;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

drop trigger if exists profiles_set_updated_at on public.profiles;
create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

drop trigger if exists mqtt_config_set_updated_at on public.mqtt_config;
create trigger mqtt_config_set_updated_at
before update on public.mqtt_config
for each row execute function public.set_updated_at();

drop trigger if exists device_status_set_updated_at on public.device_status;
create trigger device_status_set_updated_at
before update on public.device_status
for each row execute function public.set_updated_at();

drop trigger if exists support_tickets_set_updated_at on public.support_tickets;
create trigger support_tickets_set_updated_at
before update on public.support_tickets
for each row execute function public.set_updated_at();

create index if not exists idx_mqtt_config_user_id on public.mqtt_config(user_id);
create index if not exists idx_led_events_user_id_created_at on public.led_events(user_id, created_at desc);
create index if not exists idx_device_status_user_id on public.device_status(user_id);
create index if not exists idx_support_tickets_user_id_status on public.support_tickets(user_id, status);
create index if not exists idx_sessions_user_id_signed_in_at on public.sessions(user_id, signed_in_at desc);

alter table public.profiles enable row level security;
alter table public.mqtt_config enable row level security;
alter table public.led_events enable row level security;
alter table public.device_status enable row level security;
alter table public.support_tickets enable row level security;
alter table public.sessions enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
for select to authenticated
using (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
for update to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);

drop policy if exists "profiles_insert_own" on public.profiles;
create policy "profiles_insert_own" on public.profiles
for insert to authenticated
with check (auth.uid() = id);

drop policy if exists "mqtt_config_select_own" on public.mqtt_config;
create policy "mqtt_config_select_own" on public.mqtt_config
for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "mqtt_config_insert_own" on public.mqtt_config;
create policy "mqtt_config_insert_own" on public.mqtt_config
for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "mqtt_config_update_own" on public.mqtt_config;
create policy "mqtt_config_update_own" on public.mqtt_config
for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "mqtt_config_delete_own" on public.mqtt_config;
create policy "mqtt_config_delete_own" on public.mqtt_config
for delete to authenticated
using (auth.uid() = user_id);

drop policy if exists "led_events_select_own" on public.led_events;
create policy "led_events_select_own" on public.led_events
for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "led_events_insert_own" on public.led_events;
create policy "led_events_insert_own" on public.led_events
for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "device_status_select_own" on public.device_status;
create policy "device_status_select_own" on public.device_status
for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "device_status_insert_own" on public.device_status;
create policy "device_status_insert_own" on public.device_status
for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "device_status_update_own" on public.device_status;
create policy "device_status_update_own" on public.device_status
for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "support_tickets_select_own" on public.support_tickets;
create policy "support_tickets_select_own" on public.support_tickets
for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "support_tickets_insert_own" on public.support_tickets;
create policy "support_tickets_insert_own" on public.support_tickets
for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "support_tickets_update_own_open" on public.support_tickets;
create policy "support_tickets_update_own_open" on public.support_tickets
for update to authenticated
using (auth.uid() = user_id and status in ('open', 'in_progress'))
with check (auth.uid() = user_id);

drop policy if exists "sessions_select_own" on public.sessions;
create policy "sessions_select_own" on public.sessions
for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "sessions_insert_own" on public.sessions;
create policy "sessions_insert_own" on public.sessions
for insert to authenticated
with check (auth.uid() = user_id);

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.profiles to authenticated;
grant select, insert, update, delete on public.mqtt_config to authenticated;
grant select, insert on public.led_events to authenticated;
grant select, insert, update on public.device_status to authenticated;
grant select, insert, update on public.support_tickets to authenticated;
grant select, insert, update on public.sessions to authenticated;
