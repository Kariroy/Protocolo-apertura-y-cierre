# Novedades entre chats

Bitácora compartida: cada chat anota acá lo que los demás necesitan saber.
Lo más nuevo va ARRIBA. Una entrada = 1–3 líneas: fecha · chat/app · qué cambió y a quién le importa.
No es un changelog de todo: solo lo que afecta a otra app, al hub, a la base o a las reglas.

---

- **28-sep-2026 · Protocolos** · Base: `004_protocolos_hora_limite.sql` (correr en Supabase): tabla nueva `protocolos_config` (hora límite por protocolo) y columna `protocolos_dia.terminado_at`. El Historial de Protocolos pasó a "Registro" (📋 con PIN).
- **28-sep-2026 · Stock y Pedidos** · Ojo base: en Supabase los `id` son `GENERATED ALWAYS` (el `001` dice "by default"). No mandar `id` al insertar ni hacer upsert por `id` (da error 428C9); para actualizar, PATCH con `id=eq.X`.
- **28-sep-2026 · Stock y Pedidos** · Base: `003_stock_un_registro_por_dia.sql` (ya corrida): `stock_registros.fecha` es única (un registro por día) y `stock_registro_items` tiene la columna `contado`. "Hacer stock" es una planilla del día compartida en vivo (se sincroniza cada ~4 s).
- **28-sep-2026 · Inicio y seguridad** · Nueva regla: antes de cada cambio, `git pull` y releer `CLAUDE.md` + las novedades de arriba de este archivo. Después de subir algo que afecte a otros, anotarlo acá.
- **28-sep-2026 · Inicio y seguridad** · La estructura de la base está en `supabase/`. Se creó `mise_tareas` (002), ya corrida en Supabase. Protocolos usa `protocolos_items` y `protocolos_dia`.
- **28-sep-2026 · Inicio y seguridad** · Reglas nuevas en `CLAUDE.md`: leer solo lo necesario (ahorro de tokens), traer el HTML al chat y esperar "subilo" antes de subir a `main`.
- **28-sep-2026 · Inicio y seguridad** · Repo único: hub en la raíz y cada app en su carpeta, todas con el estilo azul de Guías y "← Inicio". Guías = recetas y guías de cocina.
