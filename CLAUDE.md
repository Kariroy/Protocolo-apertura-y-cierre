# Demeter – mini-apps operativas

Suite de mini-apps web para operar la cafetería Demeter (Pocitos, Montevideo). Uso interno: las usa el personal desde el celular y la compu del local. Idioma de trabajo: español rioplatense. Dueño: Aurelio (GitHub: Kariroy).

## Estructura del repo

Un solo repo → un solo proyecto de Cloudflare Pages (sin build, output directory `/`). Cada app vive en su carpeta y se publica en `<sitio>.pages.dev/<carpeta>/`.

```
index.html              hub: botones a cada app (lista APPS al final del archivo)
protocolos/index.html   Protocolo Apertura y Cierre
mise/                   Mise and Please        (pendiente migrar desde Netlify)
pedidos/                Stock y Pedidos        (pendiente migrar desde Netlify)
guias/                  Guías del Local        (nueva)
```

## Reglas de trabajo (no romper)

- **Una app por chat.** Al empezar, el usuario dice en qué app se trabaja. Tocar SOLO la carpeta de esa app. El `index.html` de la raíz (hub) y este `CLAUDE.md` se tocan solo cuando se pide explícitamente (excepción: al migrar/crear una app, pasar su entrada en `APPS` del hub a `ok:true`).
- **Nada llega a producción sin autorización.** Hacer los cambios, mostrar una captura de cómo quedan, y hacer push a `main` recién cuando Aurelio lo autoriza. Cloudflare publica `main` automáticamente.
- Antes de hacer push: `git pull --rebase origin main` (puede haber otro chat trabajando en otra carpeta).
- Cada app = un solo `index.html` autocontenido (HTML + CSS + JS embebido, sin build). Excepción aceptada: la librería de Supabase desde CDN jsdelivr.
- Al actualizar, cambiar SOLO lo pedido; conservar lógica, diseño y estructura.
- Normalizar datos antes de inyectarlos (el agrupado por proveedor depende de strings exactos).
- Panel de configuración estándar entre apps: tabla editable estilo Excel con filtro por columna, protegido con ⚙ + PIN.
- Todas las apps comparten el mismo origen, por lo tanto el mismo `localStorage`: cualquier clave guardada en el navegador debe llevar el prefijo de la app (ej. `mise:…`, `pedidos:…`).
- Los links internos de cada app deben ser relativos a su carpeta (sin `/` inicial). Para volver al hub: `../`.

## Apps

- **Protocolos** (`protocolos/`): checklists de apertura (naranja) y cierre (azul) compartidas en vivo (Supabase Realtime). "Marcar como terminado" guarda en historial y reinicia la lista. Notas del turno en cierre. Config ⚙ + PIN (Protocolo · Ítem). Tablas: `protocolos_items`, `protocolos_estado`, `protocolos_notas`, `protocolos_historial`.
- **Mise and Please** (`mise/`): swipe (derecha = listo, izquierda = producir), lista de producción compartida en vivo. Config ⚙ + PIN (Categoría · Ítem). Estilo claro crema/verde/ámbar, serif (se descartaron rediseños oscuros).
- **Stock y Pedidos** (`pedidos/`): toma de stock por tarjetas, registro con fecha. Pestañas Stock (pedir = mín − actual; TSV/CSV) y Pedidos por proveedor (formato `- 4 caja (1L) de Muzzarella`). Config ⚙ + PIN (categoría · proveedor · ítem · paquete · cantidad mínima). Tablas: `stock_items`, `stock_registros`, `stock_registro_items`.
- **Guías del Local** (`guias/`): buscador + tabla; la guía se abre en la misma pantalla con botón volver. Se cargan de a una, sin placeholders.

## Backend

- Supabase (plan gratuito), un solo proyecto compartido por todas las apps.
- Cada app tiene un bloque CONFIGURACIÓN con `SUPABASE_URL`, `SUPABASE_ANON`, `ADMIN_PIN`. Mantenerlo idéntico entre apps.
- La anon key puede ser pública; lo que protege es RLS. Hoy RLS está abierta (`using (true)`) y el PIN es solo del lado del cliente. Plan: Supabase Auth con roles Empleado/Admin (y "local" para una futura app de horas), después de terminar la funcionalidad. Mientras tanto, separar en el código acciones de empleado y de admin.

## Pendientes

- Migrar Mise y Pedidos desde Netlify a sus carpetas.
- Protocolos: el historial dice "Necesita conexión (versión de Netlify)"; ya no es Netlify.
- Ideas futuras: frecuencia de revisión por ítem de stock → "tarea del día"; lista unificada de tareas del día entre apps; tabla de limpieza semanal; app de control de horas.
