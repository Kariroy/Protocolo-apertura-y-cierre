-- 005 · Protocolos: hora de inicio por protocolo
-- Correr en Supabase → SQL Editor (después de la 004) ANTES de subir la versión nueva de protocolos/index.html.
-- (Si la app nueva llega antes, anda igual pero sin hora de inicio.)

-- Desde qué hora se puede hacer cada protocolo (Configuración → Horarios). desde = null → sin hora de inicio.
alter table public.protocolos_config
  add column desde time without time zone;
