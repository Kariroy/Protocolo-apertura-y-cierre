-- 004 · Protocolos: hora límite por protocolo + hora en que se terminó
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de protocolos/index.html.
-- (Si la app nueva llega antes, anda igual pero sin hora límite y sin hora de terminado.)

-- 1) Hora límite de cada protocolo (se edita en Configuración → Horarios).
--    Una fila por protocolo ('apertura' | 'cierre'). hasta = null → sin límite.
create table public.protocolos_config (
  proto text not null,
  hasta time without time zone,
  updated_at timestamp with time zone not null default now(),
  constraint protocolos_config_pkey primary key (proto)
);
insert into public.protocolos_config (proto) values ('apertura'), ('cierre');

alter table public.protocolos_config enable row level security;
create policy "acceso publico protocolos_config" on public.protocolos_config
  as permissive for all to anon using (true) with check (true);

-- 2) Hora en que se marcó "terminado" (para el Registro).
alter table public.protocolos_dia
  add column terminado_at timestamp with time zone;
update public.protocolos_dia set terminado_at = updated_at where terminado;
