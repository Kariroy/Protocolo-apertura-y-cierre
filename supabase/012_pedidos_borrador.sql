-- 012 · Stock y Pedidos: "Hacer pedido" guardado en la base (compartido entre celulares y compu)
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de pedidos/index.html.
--
-- Un solo pedido en curso: una fila por ítem con lo que se va a pedir (en "Se compra en").
-- item = nombre del ítem en minúsculas y sin espacios de más (la clave); cantidad 0 = se borra la fila.
-- "Borrar todo" en la app borra todas las filas.

create table public.pedidos_borrador (
  item text not null,
  cantidad numeric not null default 0,
  updated_at timestamp with time zone not null default now(),
  constraint pedidos_borrador_pkey primary key (item)
);

alter table public.pedidos_borrador enable row level security;
create policy "acceso publico pedidos_borrador" on public.pedidos_borrador
  as permissive for all to anon using (true) with check (true);
