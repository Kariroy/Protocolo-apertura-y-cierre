-- 007 · Stock y Pedidos: cada ítem se cuenta en "unidades" (cerradas) o en "gramos"
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de pedidos/index.html.
-- Todo arranca en "unidades" (como hasta ahora); se cambia por ítem en ⚙ Configuración.

alter table public.stock_items
  add column tipo text not null default 'unidades'
  check (tipo in ('unidades','gramos'));

-- el registro de cada día guarda cómo se contó cada ítem
alter table public.stock_registro_items
  add column tipo text not null default 'unidades'
  check (tipo in ('unidades','gramos'));
