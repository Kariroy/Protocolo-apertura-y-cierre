-- 011 · Stock y Pedidos: "Se cuenta en" separado de "Se compra en"
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de pedidos/index.html.
--
-- Modelo de la tabla de ⚙ (cada columna responde una sola pregunta):
--   unidad          = Se cuenta en   (qué cuenta el que hace stock: 'caja', 'botella'… o 'g' = se pesa)
--   paquete         = Se compra en   (qué se le pide al proveedor: 'pack x12', 'Paquete (1kg)')
--   por_paquete     = Trae           (cuántos de lo que se cuenta vienen en lo que se compra: 12, 1000, 1)
--   cantidad_minima = Pedir con      (con cuánto o menos se pide, en lo que se cuenta)
--   ideal           = Llenar hasta   (hasta cuánto se repone, en lo que se cuenta)
-- Pedido = redondeo para arriba de (ideal − actual) / por_paquete, en "paquete".
-- La columna tipo se sigue llenando ('gramos' si unidad = 'g', si no 'unidades').

alter table public.stock_items          add column unidad text not null default '';
alter table public.stock_registro_items add column unidad text not null default '';

-- Cargar "Se cuenta en" con lo que ya hay:
--   en gramos → 'g'; en unidades → lo mismo que se compra (o 'unidad' si U/paq era más de 1)
update public.stock_items set unidad = case
    when tipo = 'gramos' then 'g'
    when coalesce(por_paquete,0) > 1 then 'unidad'
    else coalesce(nullif(trim(paquete),''),'unidad') end
  where unidad = '';
update public.stock_registro_items set unidad = case
    when tipo = 'gramos' then 'g'
    when coalesce(por_paquete,0) > 1 then 'unidad'
    else coalesce(nullif(trim(paquete),''),'unidad') end
  where unidad = '';

-- "Trae" para lo que va en gramos y no lo tenía: se saca del texto del paquete ("(1kg)" → 1000, "(500g)" → 500)
update public.stock_items s
   set por_paquete = case when lower(x.m[2]) = 'kg' then replace(x.m[1],',','.')::numeric * 1000
                          else replace(x.m[1],',','.')::numeric end
  from (select id, regexp_match(paquete, '(\d+(?:[.,]\d+)?)\s*(kg|g)\M', 'i') as m from public.stock_items) x
 where s.id = x.id and s.tipo = 'gramos' and coalesce(s.por_paquete,0) = 0 and x.m is not null;

-- El resto sin "Trae" queda en 1 (se cuenta lo mismo que se compra)
update public.stock_items set por_paquete = 1 where coalesce(por_paquete,0) = 0 and unidad <> 'g';
