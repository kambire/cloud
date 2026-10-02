# Geeks Cloud — Marca blanca del cliente de escritorio

Personalización (white-label) del **Nextcloud Desktop Client** para **Geeks Cloud**
(servicio de backup de datos para empresas). Este documento resume **qué se cambió**,
**qué falta por confirmar** y **cómo compilar** el instalador.

---

## 1. Qué se cambió

### Configuración de marca
- **`GEEKSCLOUD.cmake`** (nuevo) — reemplaza a `NEXTCLOUD.cmake` como definición de marca.
  Contiene nombre, ejecutable, dominios, colores y GUIDs propios.
- **`CMakeLists.txt`** (línea 30) — ahora hace `include(GEEKSCLOUD.cmake)` en vez de `NEXTCLOUD.cmake`.

Valores aplicados:

| Variable | Valor |
|----------|-------|
| `APPLICATION_NAME` | `Geeks Cloud` |
| `APPLICATION_SHORTNAME` | `GeeksCloud` |
| `APPLICATION_EXECUTABLE` | `geekscloud` |
| `APPLICATION_ICON_NAME` | `GeeksCloud` |
| `APPLICATION_VENDOR` | `Geeks Cloud` |
| `APPLICATION_DOMAIN` | `geekscloud.com` |
| `APPLICATION_REV_DOMAIN` | `com.geekscloud.desktopclient` |
| `APPLICATION_VIRTUALFILE_SUFFIX` | `geekscloud` |
| Color primario (`NEXTCLOUD_BACKGROUND_COLOR`) | `#6F4899` (morado) |
| Color de acento | `#1CBFD8` (cian) |

> El cliente se vuelve **"branded"** automáticamente al dejar de llamarse "Nextcloud"
> (ver `src/libsync/theme.cpp`, `Theme::isBranded()`), lo que oculta textos y
> enlaces propios de Nextcloud. El "Acerca de" pasa a ser *"Geeks Cloud Desktop Client Version X"*.

### Colores — por qué morado y no cian
El color primario se usa como **fondo con texto/iconos blancos encima** (cabecera del
asistente, pestañas, bandeja). Blanco sobre cian `#1CBFD8` da contraste ~2:1 (ilegible,
falla WCAG AA). Blanco sobre morado `#6F4899` da ~7.5:1 (correcto). Por eso el **morado es
primario** y el **cian es acento**.

### Logos e iconos (en `theme/colored/`)
Generados desde `logos/geeks-logo-normal.png` (wordmark 400×102, morado `#6F4899` + cian `#1CBFD8`):

- **Icono de la app** — monograma **"g"** morado sobre transparente:
  `GeeksCloud-icon.svg` + `16/24/32/48/64/128/256/512/1024-GeeksCloud-icon.png`.
  (Usado en ejecutable, bandeja del sistema, accesos directos.)
- **Logo del asistente** — wordmark **en blanco** (se dibuja sobre cabecera morada):
  `wizard_logo.png` (200×51), `wizard_logo@2x.png` (400×102), `wizard_logo.svg`.

---

## 2. Pendientes (TODO antes de producción)

Buscar `# TODO` en `GEEKSCLOUD.cmake`. Lo principal:

1. **Dominio y datos legales** — confirmar `APPLICATION_DOMAIN`, `APPLICATION_VENDOR`,
   `APPLICATION_HELP_URL` (URL de soporte).
2. **URL del servidor** — rellenar `APPLICATION_SERVER_URL` (p. ej. `https://cloud.geekscloud.com`)
   para que el cliente la traiga precargada. Poner `APPLICATION_SERVER_URL_ENFORCE ON`
   si quieres que **solo** puedan conectarse a tu servidor.
3. **Actualizaciones** — `BUILD_UPDATER` está **OFF**. Si montas un servidor de updates,
   rellena `APPLICATION_UPDATE_URL` y ponlo en `ON`.
4. **Calidad del icono** — el monograma "g" se generó desde un PNG de 400 px, así que a
   1024 px pierde algo de nitidez. Para un acabado perfecto, aportar un **SVG vectorial**
   o un **PNG cuadrado ≥1024 px** del logo y regenerar.
5. **(Opcional) Instalador Windows** — reemplazar las imágenes de marca del instalador NSIS
   en `admin/win/nsi/` (banner/sidebar) y el `.ico` del ejecutable por los de Geeks Cloud.
6. **(Opcional) Iconos de estado** — los iconos de sincronización/error/pausa
   (`theme/colored/state-*`, overlays del explorador) siguen siendo los genéricos de
   Nextcloud (son glifos neutros, sin marca). Recolorearlos al morado es puro pulido.

### Licencia (importante para una empresa)
El cliente es **GPL-2.0-or-later**. Puedes rebrandearlo y distribuirlo, pero al distribuir
binarios modificados debes **ofrecer el código fuente correspondiente** y conservar los avisos
de licencia. No puedes usar las marcas registradas "Nextcloud" en tu producto (por eso
cambiamos todos los nombres). Conviene revisarlo con asesoría legal antes de distribuir.

---

## 3. Cómo compilar (Windows) — esquema

El cliente usa **Qt 6.10+**, C++20, CMake y **KDE Craft**. La primera compilación descarga
varios GB y tarda horas. Resumen (ver `doc/` del repo y la wiki de Nextcloud para el detalle):

```powershell
# 1. Instalar KDE Craft (sigue la guía oficial de Craft para Windows + MSVC)
#    https://community.kde.org/Craft

# 2. Dentro del entorno Craft, instalar dependencias del cliente
craft --install-deps nextcloud-client

# 3. Configurar apuntando a este repo ya rebrandeado
cmake -S C:\Users\kambi\Desktop\GeeksBackup\desktop -B build-geekscloud `
      -DCMAKE_BUILD_TYPE=Release

# 4. Compilar
cmake --build build-geekscloud --config Release

# 5. (Opcional) Generar instalador .exe con NSIS
#    Requiere BUILD_UPDATER/empaquetado; ver admin/win/ y CPack.
```

> Nota: estas instrucciones son el esquema general. El toolchain exacto (versión de MSVC,
> variables de entorno de Craft) debe seguir la guía oficial vigente de Nextcloud/Craft.

---

## 4. Archivos tocados / añadidos

- `GEEKSCLOUD.cmake` *(nuevo)*
- `CMakeLists.txt` *(línea `include(...)`)*
- `theme/colored/GeeksCloud-icon.svg` + `*-GeeksCloud-icon.png` (9 tamaños) *(nuevos)*
- `theme/colored/wizard_logo.png`, `wizard_logo@2x.png`, `wizard_logo.svg` *(reemplazados)*

El archivo original `NEXTCLOUD.cmake` se conserva como referencia (ya no se incluye).
