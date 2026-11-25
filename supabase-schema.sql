-- ============================================================
--  Examen Hacker Ético · Supabase schema
--  Ejecutar en: Supabase Dashboard → SQL Editor → New query
-- ============================================================

-- ---------- 1. Perfiles (uno por usuario) ----------
create table if not exists public.profiles (
  id            uuid primary key references auth.users (id) on delete cascade,
  email         text,
  full_name     text,
  created_at    timestamptz not null default now(),
  last_login_at timestamptz
);

-- ---------- 2. Registro de accesos: desde dónde entra cada persona ----------
create table if not exists public.login_events (
  id         bigserial primary key,
  user_id    uuid references auth.users (id) on delete set null,
  email      text,
  event      text not null default 'login',      -- 'login' | 'register'
  ip         text,                               -- dirección IP pública
  city       text,                               -- ciudad
  region     text,                               -- estado / región
  country    text,                               -- país
  org        text,                               -- proveedor de internet / red
  latitude   double precision,
  longitude  double precision,
  user_agent text,                               -- cadena completa del navegador
  device     text,                               -- Escritorio | Móvil | Tablet
  browser    text,                               -- Chrome | Edge | Firefox | Safari...
  os         text,                               -- Windows | macOS | Android | iOS...
  created_at timestamptz not null default now()
);

create index if not exists login_events_created_at_idx on public.login_events (created_at desc);
create index if not exists login_events_user_id_idx    on public.login_events (user_id);

-- ---------- 3. Lista de administradores (ven todos los accesos) ----------
create table if not exists public.admins (
  email text primary key
);
-- >>> correo del administrador (quien ve el panel de accesos) <<<
insert into public.admins (email) values ('caguamaserik123@gmail.com')
on conflict (email) do nothing;

-- ---------- 4. Función segura: ¿es admin el usuario actual? ----------
create or replace function public.is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select exists (
    select 1 from public.admins a
    where lower(a.email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

revoke execute on function public.is_admin() from anon;
grant execute on function public.is_admin() to authenticated;

-- ---------- 5. Row Level Security ----------
alter table public.profiles     enable row level security;
alter table public.login_events enable row level security;
alter table public.admins       enable row level security;

-- perfiles: cada quien ve/edita el suyo; el admin ve todos
drop policy if exists "profiles_own"      on public.profiles;
drop policy if exists "profiles_admin"    on public.profiles;
create policy "profiles_own"   on public.profiles for all    using (auth.uid() = id) with check (auth.uid() = id);
create policy "profiles_admin" on public.profiles for select using (public.is_admin());

-- accesos: cada quien inserta el suyo; cada quien ve los suyos; el admin ve todos
drop policy if exists "events_insert_own" on public.login_events;
drop policy if exists "events_select_own" on public.login_events;
drop policy if exists "events_select_admin" on public.login_events;
create policy "events_insert_own"   on public.login_events for insert with check (auth.uid() = user_id);
create policy "events_select_own"   on public.login_events for select using (auth.uid() = user_id);
create policy "events_select_admin" on public.login_events for select using (public.is_admin());

-- la tabla de admins NO se puede leer directamente (solo vía función)

-- ---------- 6. Triggers ----------
-- 6a. al registrarse, crear el perfil
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data ->> 'full_name')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 6b. cada inicio de sesión actualiza last_login_at
create or replace function public.touch_last_login()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.user_id is not null then
    insert into public.profiles (id, email, last_login_at)
    values (new.user_id, new.email, now())
    on conflict (id) do update
      set last_login_at = now(),
          email         = coalesce(excluded.email, public.profiles.email);
  end if;
  return new;
end;
$$;

drop trigger if exists on_login_event on public.login_events;
create trigger on_login_event
  after insert on public.login_events
  for each row execute function public.touch_last_login();

-- ---------- 7. Vista de consulta rápida (respeta RLS) ----------
create or replace view public.v_accessos
with (security_invoker = true) as
select
  e.created_at,
  e.email,
  e.event,
  e.ip,
  e.city,
  e.region,
  e.country,
  e.org,
  e.device,
  e.browser,
  e.os,
  p.full_name
from public.login_events e
left join public.profiles p on p.id = e.user_id
order by e.created_at desc;
