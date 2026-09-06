# Claimer Control

<p align="center">
  <strong>Tus juegos gratuitos y recompensas diarias en un panel local y privado.</strong><br>
  Instálalo una vez, elige tus tiendas y deja que Claimer Control se ocupe de la rutina.
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/actions/workflows/release.yml"><img alt="Pruebas" src="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/actions/workflows/release.yml/badge.svg"></a>
  <a href="../LICENSE"><img alt="Licencia AGPL-3.0" src="https://img.shields.io/github/license/rafaelcairess/free-games-claimer-remaster-gui?style=flat-square"></a>
  <img alt="Windows 10 y 11" src="https://img.shields.io/badge/Windows-10%20%7C%2011-5aa7d9?style=flat-square">
  <img alt="Datos locales" src="https://img.shields.io/badge/datos-solo%20locales-6ee1b6?style=flat-square">
  <img alt="Idiomas" src="https://img.shields.io/badge/idiomas-EN%20%7C%20PT--BR%20%7C%20ES-bde6fb?style=flat-square">
</p>

<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.pt-BR.md">Português do Brasil</a> ·
  <a href="./README.es.md">Español</a>
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases"><strong>Descargar Claimer Control para Windows</strong></a>
</p>

> [!NOTE]
> El instalador para Windows estará disponible en Releases con la versión `v1.0.0`. Hasta que se publique, este repositorio contiene la versión de desarrollo.

![Panel de Claimer Control con resultados de juegos y AliExpress](images/05-dashboard.png)

## Qué hace

- Reclama juegos, recursos y recompensas elegibles en las tiendas seleccionadas.
- Recoge la recompensa diaria de AliExpress y muestra monedas, saldo y racha.
- Informa el resultado real de cada ejecución, no solo una cantidad genérica.
- Funciona con un horario y puede iniciarse automáticamente con Windows.
- Abre un navegador visual cuando una tienda requiere inicio de sesión o confirmación manual.
- Mantiene el panel, la configuración, la base de datos y las sesiones en tu computadora.

## Servicios compatibles

| Juegos y recursos | Recompensas y descubrimiento |
|---|---|
| Epic Games, Steam, GOG, Prime Gaming, Ubisoft, Fab y Unity Asset Store | Monedas diarias de AliExpress y descubrimiento de promociones con GamerPower |

GamerPower también puede enviar promociones compatibles de Fanatical, itch.io e IndieGala. La disponibilidad y los requisitos de acceso dependen de cada tienda.

## Instálalo en tres pasos

1. Descarga `Claimer-Control-Setup.exe` desde la [Release más reciente](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases).
2. Ejecuta el instalador. Si falta Docker Desktop, el launcher explica por qué es necesario y solo lo instala desde la fuente oficial después de tu confirmación.
3. Sigue el asistente local: elige idioma y tiendas, añade credenciales si lo deseas y configura el horario.

Eso es todo. No necesitas clonar el repositorio, editar archivos de configuración ni escribir comandos de Docker.

El instalador puede solicitar permisos de administrador o reiniciar Windows mientras instala Docker Desktop. Como el primer instalador no estará firmado, Windows SmartScreen puede mostrar un aviso de editor desconocido. Cada Release incluye `SHA256SUMS.txt` para comprobar la descarga.

## Tus datos permanecen en tu computadora

Claimer Control no tiene un servidor de cuentas ni incluye telemetría.

| Qué sucede | Dónde sucede |
|---|---|
| Panel y configuración | En `127.0.0.1`, disponible solamente desde esta computadora |
| Credenciales y sesiones | En el volumen Docker local |
| Inicio de sesión en tiendas | Directamente entre el navegador automatizado y el sitio oficial de la tienda |
| Respuesta de la API sobre secretos | Solo `configured: true/false`; la contraseña nunca vuelve al panel |
| Actualizaciones | Se consultan en las Releases oficiales de este proyecto en GitHub |

Las credenciales son opcionales y el acceso manual mediante el navegador siempre está disponible. Los secretos locales no están protegidos por un servidor externo de cifrado; protege tu cuenta de Windows y el disco. Claimer Control no intenta eludir CAPTCHA, sistemas antifraude ni desafíos de seguridad.

## Diseñado para ser claro

Solo las tiendas habilitadas aparecen en el panel. Cada fila explica qué ocurrió: qué juego fue reclamado, cuál ya estaba en la biblioteca, si no había promoción o cuántas monedas de AliExpress fueron recogidas.

| Configuración guiada de la cuenta | Detalles de monedas de AliExpress |
|---|---|
| ![Campo de credenciales con explicación de privacidad](images/04-credentials.png) | ![Monedas diarias, saldo y racha de AliExpress](images/06-aliexpress.png) |

Cada credencial tiene una explicación accesible en el botón `?`. La interfaz funciona con ratón, teclado y toque, y está completamente traducida al inglés, portugués de Brasil y español.

## Uso diario

- Abre **Claimer Control** desde el menú Inicio o el acceso directo del escritorio.
- Usa **Ejecutar ahora** para todas las tiendas o ejecuta una tienda individualmente.
- Usa **Navegador** cuando una tienda solicite acceso, CAPTCHA o confirmación manual.
- Usa **Configuración** para cambiar tiendas, cuentas, notificaciones y horarios.
- Las actualizaciones se ofrecen en el panel y conservan el volumen local.

El launcher comprueba Docker, inicia el servicio, espera al panel y lo abre automáticamente. Al desinstalar Claimer Control se conservan las cuentas y sesiones por defecto; borrar los datos locales es una opción separada y explícita. Docker Desktop nunca se elimina automáticamente.

## ¿Necesitas ayuda?

| Problema | Qué puedes intentar |
|---|---|
| El panel no se abrió | Abre [http://127.0.0.1:8080](http://127.0.0.1:8080) y confirma que Docker Desktop está en ejecución. |
| Una tienda necesita atención | Abre el navegador visual desde el panel y completa la solicitud oficial de la tienda. |
| Una sesión caducó | Inicia sesión otra vez mediante el navegador visual; la sesión actualizada se conservará localmente. |
| Un reclamo falló | Vuelve a ejecutar únicamente esa tienda y adjunta el fragmento relevante del registro sanitizado al abrir una issue. |

Para informar errores o sugerir funciones, usa las [Issues de GitHub](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/issues). Nunca publiques contraseñas, cookies, claves TOTP, capturas completas de red ni imágenes sin sanitizar.

## Para contribuidores

El instalador es el camino recomendado para usuarios. Las compilaciones desde el código fuente, la arquitectura y las variables internas son temas de desarrollo:

- [`.env.example`](../.env.example) — referencia completa para compilaciones desde el código fuente
- [`MODIFICATIONS.md`](../MODIFICATIONS.md) — historial de implementación y diferencias técnicas
- [`CHANGELOG.md`](../CHANGELOG.md) — cambios de cada versión

Las pruebas cubren los módulos de tiendas, la API local, la protección de secretos, las traducciones, la configuración inicial y el launcher de Windows.

## Créditos y licencia

**Interfaz y distribución para Windows de Claimer Control:** [Rafael Caires](https://github.com/rafaelcairess).

Construido sobre [P-Adamiec/Free-Games-Claimer-Remaster](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster), mantenido por Paweł Adamiec y sus contribuidores. Ese proyecto fue inspirado por [vogler/free-games-claimer](https://github.com/vogler/free-games-claimer). Los avisos de terceros se encuentran en [`THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md).

Distribuido bajo la [GNU Affero General Public License v3.0](../LICENSE).
