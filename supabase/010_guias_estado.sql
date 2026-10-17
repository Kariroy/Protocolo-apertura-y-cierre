-- 010 · Guías: qué fichas ve el personal (⚙ Fichas activas en guias/)
-- Una fila por ficha de recipes-data, por su número (num).
-- Las fichas sin fila NO se muestran: una ficha nueva arranca oculta hasta activarla en ⚙.
-- Correr una sola vez en Supabase → SQL Editor.

create table public.guias_estado (
  num text not null,                 -- número de la ficha ("01", "02", …)
  nombre text,                       -- solo de referencia
  activa boolean not null default false,
  updated_at timestamp with time zone not null default now(),
  constraint guias_estado_pkey primary key (num)
);

alter table public.guias_estado enable row level security;

create policy "acceso publico guias_estado" on public.guias_estado
  as permissive for all to anon using (true) with check (true);

-- Arranque: las 40 fichas que hay hoy quedan activas (se ven igual que ahora).
-- Después se desactivan desde ⚙ las que todavía no estén listas.
insert into public.guias_estado (num, nombre, activa) values
  ('01', 'Waffles', true),
  ('02', 'Frosting', true),
  ('03', 'Cookies clásicas', true),
  ('04', 'Cookies NY Chispas', true),
  ('05', 'Cookies NY Red Velvet', true),
  ('06', 'Cookies NY Oreo', true),
  ('07', 'Budín marmolado', true),
  ('08', 'Almíbar', true),
  ('09', 'Chocolatada', true),
  ('10', 'Tomates confitados', true),
  ('11', 'Pesto', true),
  ('12', 'Masa pocket pizza', true),
  ('13', 'Scones', true),
  ('14', 'Pocket Pizza: Jamón', true),
  ('15', 'Iced Americano', true),
  ('16', 'Iced Latte', true),
  ('17', 'Frappé Clásico', true),
  ('18', 'Pocket Pizza: Caprese', true),
  ('19', 'Pocket Pizza: Aceitunas', true),
  ('20', 'Waffle: Jamón y Queso', true),
  ('21', 'Waffle: Napolitano', true),
  ('22', 'Waffle: Caprese', true),
  ('23', 'Waffle: Aceitunas', true),
  ('24', 'Waffle: Patagónico', true),
  ('25', 'Waffle: Mandale Fruta', true),
  ('26', 'Waffle: Dulce Crush', true),
  ('27', 'Waffle: Lluvia de Rocklets', true),
  ('28', 'Waffle: Chocofest', true),
  ('29', 'Waffle: Mini Oreo', true),
  ('30', 'Tostado: Jamón y Queso', true),
  ('31', 'Tostado: Aceitunas y Orégano', true),
  ('32', 'Tostado: Caprese', true),
  ('33', 'Medialuna Clásica', true),
  ('34', 'Medialuna Clásica Rellena', true),
  ('35', 'Medialuna XL Rellena', true),
  ('36', 'Roll de Canela', true),
  ('37', 'Cookie NYC: Chispas de Chocolate', true),
  ('38', 'Cookie NYC: Red Velvet', true),
  ('39', 'Cookie NYC: Oreo', true),
  ('40', 'Cookie Clásica', true);
