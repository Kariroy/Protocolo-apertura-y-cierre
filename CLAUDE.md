# Demeter – mini-apps operativas

Suite de mini-apps web para operar la cafetería Demeter (Pocitos, Montevideo). Uso interno: las usa el personal desde el celular y la compu del local. Idioma de trabajo: español rioplatense. Dueño: Aurelio (GitHub: Kariroy).

## Estructura del repo

Un solo repo → un solo proyecto de Cloudflare Pages (sin build, output directory `/`). Cada app vive en su carpeta y se publica en `<sitio>.pages.dev/<carpeta>/`.

```
index.html              hub: botones a cada app (lista APPS al final del archivo)
protocolos/index.html   Protocolo Apertura y Cierre
mise/index.html         Mise and Please
pedidos/index.html      Stock y Pedidos
guias/index.html        Guías (recetas y guías de cocina)
```

## Reglas de trabajo (no romper)

- **Una app por chat.** Al empezar, el usuario dice en qué app se trabaja. Tocar SOLO la carpeta de esa app. El `index.html` de la raíz (hub) y este `CLAUDE.md` se tocan solo cuando se pide explícitamente (excepción: al migrar/crear una app, pasar su entrada en `APPS` del hub a `ok:true`).
- **Chat "Inicio y seguridad":** es el único que trabaja el hub, este `CLAUDE.md` y la seguridad (login, roles, reglas de Supabase). Como la seguridad cruza todas las apps, ese chat sí puede tocar el bloque de CONFIGURACIÓN/login de cada app, sin cambiar nada más de ellas.
- **Ahorrar tokens: leer solo lo necesario.** No abrir ni leer archivos de otras apps ni el hub (este `CLAUDE.md` ya tiene el contexto). Dentro del archivo de la app, no leerlo entero: buscar con grep la parte que se va a cambiar y leer solo esas líneas. `guias/index.html` pesa ~1 MB porque la línea del JSON `recipes-data` tiene fotos en base64: nunca leer esa línea completa; para ver o editar fichas, procesarla con un script que muestre solo lo necesario.
- **Nada llega a producción sin autorización.** Hacer los cambios, mostrar una captura de cómo quedan, y hacer push a `main` recién cuando Aurelio lo autoriza. Cloudflare publica `main` automáticamente.
- Antes de hacer push: `git pull --rebase origin main` (puede haber otro chat trabajando en otra carpeta).
- Cada app = un solo `index.html` autocontenido (HTML + CSS + JS embebido, sin build). Excepción aceptada: la librería de Supabase desde CDN jsdelivr.
- Al actualizar, cambiar SOLO lo pedido; conservar lógica, diseño y estructura.
- Normalizar datos antes de inyectarlos (el agrupado por proveedor depende de strings exactos).
- Panel de configuración estándar entre apps: tabla editable estilo Excel con filtro por columna, protegido con ⚙ + PIN.
- **Estilo único para todas las apps y el hub = el de Guías del Local, con acento azul.** Fondo `#faf7f2`, tarjetas `#ffffff`, tinta `#1c1a17`, gris `#6b6459`, líneas `#e2dbcd`, chip `#f1ebe0`, acento `#1f4e96` (hover `#173c74`). Tipografías: Archivo (textos y títulos) e IBM Plex Mono (etiquetas, botones y números, en mayúsculas con algo de espaciado), desde Google Fonts. Títulos con raya azul de 1mm debajo; bordes finos y esquinas chicas (1–2mm). Verde `#2e7d4f` = listo/ok y ámbar `#a8541d` = producir/atención quedan como colores de estado, no de marca. Cada app arranca con "← Inicio" que vuelve al hub (`../`). En Protocolos, Mise y Stock el estilo nuevo está en un bloque "ESTILO DEMETER" al final del CSS.
- Todas las apps comparten el mismo origen, por lo tanto el mismo `localStorage`: cualquier clave guardada en el navegador debe llevar el prefijo de la app (ej. `mise:…`, `pedidos:…`).
- Los links internos de cada app deben ser relativos a su carpeta (sin `/` inicial). Para volver al hub: `../`.

## Apps

- **Protocolos** (`protocolos/`): checklists de apertura (azul) y cierre (azul oscuro) compartidas en vivo (Supabase Realtime). "Marcar como terminado" guarda en historial y reinicia la lista. Notas del turno en cierre. Config ⚙ + PIN (Protocolo · Ítem). Tablas: `protocolos_items`, `protocolos_estado`, `protocolos_notas`, `protocolos_historial`.
- **Mise and Please** (`mise/`): swipe (derecha = listo, izquierda = producir), lista de producción compartida en vivo. Config ⚙ + PIN (Categoría · Ítem).
- **Stock y Pedidos** (`pedidos/`): toma de stock por tarjetas, registro con fecha. Pestañas Stock (pedir = mín − actual; TSV/CSV) y Pedidos por proveedor (formato `- 4 caja (1L) de Muzzarella`). Config ⚙ + PIN (categoría · proveedor · ítem · paquete · cantidad mínima). Tablas: `stock_items`, `stock_registros`, `stock_registro_items`.
- **Guías** (`guias/`): recetas y guías de cocina (fichas con buscador, filtro por categoría y detalle en la misma pantalla con "Volver"). Los datos van embebidos en un JSON dentro del HTML (`recipes-data`), algunas fichas con foto en base64. Sin Supabase.

## Backend

- Supabase (plan gratuito), un solo proyecto compartido por todas las apps.
- Cada app tiene un bloque CONFIGURACIÓN con `SUPABASE_URL`, `SUPABASE_ANON`, `ADMIN_PIN`. Mantenerlo idéntico entre apps.
- La anon key puede ser pública; lo que protege es RLS. Hoy RLS está abierta (`using (true)`) y el PIN es solo del lado del cliente. Plan: Supabase Auth con roles Empleado/Admin (y "local" para una futura app de horas), después de terminar la funcionalidad. Mientras tanto, separar en el código acciones de empleado y de admin.

## Pendientes

- Dar de baja los sitios viejos de Netlify (miseandplease, pedidosdemeter4f3, ordencocinademeter390fj) cuando las versiones nuevas estén andando.
- Protocolos: el historial dice "Necesita conexión (versión de Netlify)"; ya no es Netlify.
- Ideas futuras: frecuencia de revisión por ítem de stock → "tarea del día"; lista unificada de tareas del día entre apps; tabla de limpieza semanal; app de control de horas.
