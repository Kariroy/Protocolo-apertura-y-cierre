-- ============================================================
-- 006 · Registro diario de Mise and Please (para el Panel de control)
-- Mise no guardaba historial: "Volver a empezar" borra mise_lista.
-- Esta migración guarda solo, sin cambiar el código de Mise, una fila
-- por día en mise_registros con:
--   · producción: total y hechas (lo que salió del swipe + "Agregados")
--   · tareas del día: total y hechas (limpieza / mantenimiento)
--   · el detalle de cada ítem (jsonb)
-- Un trigger la actualiza cada vez que se arma la lista o se marca algo.
-- Al borrar la lista (Volver a empezar) el registro del día queda.
--
-- Cómo sabe si una fila es tarea del día: columna nueva mise_lista.tipo
-- ('produccion' | 'tarea'). Mientras Mise no la complete, se deduce:
-- si el texto coincide con una tarea de mise_tareas, es 'tarea'.
--
-- Día = fecha (hora de Montevideo) en que se armó cada fila de la lista.
-- Si en un mismo día se reinicia la lista y se arma otra, el registro
-- del día pasa a reflejar la lista nueva.
-- Correr UNA vez en Supabase → SQL Editor.
-- ============================================================

alter table public.mise_lista add column if not exists tipo text;

create table public.mise_registros (
  fecha date not null,
  prod_total integer not null default 0,
  prod_hechas integer not null default 0,
  tareas_total integer not null default 0,
  tareas_hechas integer not null default 0,
  items jsonb not null default '[]'::jsonb,
  updated_at timestamp with time zone not null default now(),
  constraint mise_registros_pkey primary key (fecha)
);

alter table public.mise_registros enable row level security;

-- mismo nivel de acceso que el resto por ahora (se cierra con el login)
create policy "acceso publico mise_registros" on public.mise_registros
  as permissive for all to anon using (true) with check (true);

create or replace function public.mise_registrar_dia()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  f date := (coalesce(new.created_at, now()) at time zone 'America/Montevideo')::date;
begin
  with filas as (
    select l.*,
           coalesce(l.tipo,
             case when exists (select 1 from mise_tareas t where t.txt = l.txt)
                  then 'tarea' else 'produccion' end) as tipo_ok
    from mise_lista l
    where (l.created_at at time zone 'America/Montevideo')::date = f
  )
  insert into mise_registros (fecha, prod_total, prod_hechas, tareas_total, tareas_hechas, items, updated_at)
  select f,
         count(*) filter (where tipo_ok = 'produccion'),
         count(*) filter (where tipo_ok = 'produccion' and done),
         count(*) filter (where tipo_ok = 'tarea'),
         count(*) filter (where tipo_ok = 'tarea' and done),
         coalesce(jsonb_agg(jsonb_build_object(
           'cat', cat, 'txt', txt, 'done', done, 'tipo', tipo_ok, 'comment', comment)
           order by "position"), '[]'::jsonb),
         now()
  from filas
  having count(*) > 0
  on conflict (fecha) do update set
    prod_total    = excluded.prod_total,
    prod_hechas   = excluded.prod_hechas,
    tareas_total  = excluded.tareas_total,
    tareas_hechas = excluded.tareas_hechas,
    items         = excluded.items,
    updated_at    = excluded.updated_at;
  return null;
end;
$$;

create trigger mise_lista_registrar
  after insert or update on public.mise_lista
  for each row execute function public.mise_registrar_dia();

-- guardar ya la lista que esté abierta ahora (si hay)
update public.mise_lista set done = done;
