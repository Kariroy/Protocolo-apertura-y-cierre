-- 008 · Guías: sección privada "Negocio" 🔒
-- Correr en Supabase → SQL Editor. Hasta que se corra, la app guarda lo cifrado
-- en el navegador (localStorage "guias:negocio") y después ofrece pasarlo acá.
--
-- La base NUNCA ve nada legible: título, categoría, texto y la lista de
-- categorías van cifrados con AES-GCM dentro de `datos`. La clave sale, en el
-- navegador, de una contraseña que solo sabe Aurelio (PBKDF2-SHA256) y no se
-- guarda en ningún lado. Sin la contraseña, lo guardado es ilegible.
--
--   tipo = 'meta'  → una sola fila: salt + iteraciones de PBKDF2 y, cifrados,
--                    un control para verificar la contraseña y las categorías.
--   tipo = 'ficha' → una fila por ficha.
-- (No hay columna "categoria" en claro a propósito: va cifrada adentro de datos.)

create table public.guias_privadas (
  id bigint generated always as identity not null,
  tipo text not null default 'ficha',
  datos text not null,          -- base64 del contenido cifrado (AES-GCM)
  iv text not null,             -- base64 del IV (12 bytes), nuevo en cada guardado
  salt text,                    -- base64, solo en la fila 'meta'
  iteraciones integer,          -- PBKDF2, solo en la fila 'meta'
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint guias_privadas_pkey primary key (id),
  constraint guias_privadas_tipo_check check (tipo in ('meta','ficha'))
);

-- una sola fila 'meta'
create unique index guias_privadas_una_meta
  on public.guias_privadas (tipo) where tipo = 'meta';

alter table public.guias_privadas enable row level security;

create policy "acceso publico guias_privadas" on public.guias_privadas
  as permissive for all to anon using (true) with check (true);
