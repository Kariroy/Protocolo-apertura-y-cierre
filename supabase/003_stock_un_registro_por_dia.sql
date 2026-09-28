-- 003 · Stock y Pedidos: un solo registro por día, compartido en vivo
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de pedidos/index.html.

-- 0) (Opcional, para mirar antes) días que hoy tienen más de un registro:
-- select fecha, count(*) from public.stock_registros group by fecha having count(*) > 1;

-- 1) Si una fecha tiene más de un registro, queda el más reciente y se borran los otros
--    (sus ítems se borran solos por el "on delete cascade").
delete from public.stock_registros r
using public.stock_registros r2
where r2.fecha = r.fecha
  and (r2.created_at > r.created_at or (r2.created_at = r.created_at and r2.id > r.id));

-- 2) Un solo registro por fecha.
alter table public.stock_registros
  add constraint stock_registros_fecha_key unique (fecha);

-- 3) Distinguir "contado en 0" de "no contado todavía".
alter table public.stock_registro_items
  add column contado boolean not null default false;
update public.stock_registro_items set contado = true where cantidad_actual <> 0;
