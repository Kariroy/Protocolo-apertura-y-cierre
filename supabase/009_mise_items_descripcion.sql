-- 009 · Mise and Please: descripción opcional por ítem del swipe
-- (cuándo hace falta o cuánto: ej. "Salero canela" → "cargar si hay menos de la mitad").
-- Se ve en la tarjeta del swipe y en la lista A producir; se edita en ⚙ Configuración.
-- Correr en Supabase → SQL Editor ANTES de subir la versión nueva de mise/index.html.

alter table public.mise_items
  add column descripcion text;
