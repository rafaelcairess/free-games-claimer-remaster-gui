# Claimer Control

<p align="center">
  <strong>Un panel local que reclama juegos gratuitos y las monedas diarias de AliExpress.</strong><br>
  <sub>El panel, las cuentas y las sesiones del navegador permanecen en tu equipo.</sub>
</p>

<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.pt-BR.md">Português do Brasil</a> ·
  <strong>Español</strong>
</p>

<p align="center">
  <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest/download/Claimer-Control-Setup.exe"><strong>Descargar para Windows</strong></a>
  · <a href="https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest">Notas de la versión y SHA-256</a>
</p>

> [!IMPORTANT]
> Claimer Control no mantiene un servidor de credenciales ni incluye telemetría. Los datos introducidos en el panel permanecen en el volumen Docker local y solo el navegador automatizado los envía al inicio de sesión oficial de cada tienda.

Mantenido por [Rafael Caires](https://github.com/rafaelcairess), basado en [Free Games Claimer Remaster](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster) de Paweł Adamiec. Se conservan la autoría original y la licencia AGPL-3.0.

## Funciones

- Muestra tiendas seleccionadas, ejecución actual, próximo horario y resultados reales.
- Indica el nombre de cada juego y si fue reclamado, ya estaba en la biblioteca o falló.
- Muestra monedas recogidas, saldo, racha y próxima recompensa de AliExpress cuando la API proporciona esos datos.
- Ejecuta todas las tiendas o una sola.
- Abre el navegador visual para inicio manual, 2FA y desafíos de seguridad.
- Configura tiendas, cuentas, programación y notificaciones sin editar archivos.
- Detecta español, portugués o inglés y permite cambiarlo manualmente.
- Avisa de actualizaciones, pero solo las instala después de tu confirmación.

Tiendas principales: Steam, Epic Games, Fab, Prime Gaming, GOG, Ubisoft, Unity Asset Store, AliExpress y fuentes adicionales de GamerPower.

## Instalación en Windows

1. Descarga **[Claimer-Control-Setup.exe](https://github.com/rafaelcairess/free-games-claimer-remaster-gui/releases/latest/download/Claimer-Control-Setup.exe)** desde la Release más reciente.
2. Ejecuta el instalador. Si falta Docker Desktop, Claimer Control explica por qué se necesita y solicita autorización para instalarlo desde la fuente oficial.
3. El panel se abrirá automáticamente. Sigue el asistente para elegir idioma, tiendas, cuentas opcionales y programación.

Docker puede solicitar permisos de administrador y reiniciar Windows. Claimer Control reanuda la configuración después de iniciar sesión. Como el instalador todavía no tiene certificado de firma, SmartScreen puede mostrar “Editor desconocido”. Compara el archivo con `SHA256SUMS.txt` de la misma Release.

El acceso directo inicia Docker cuando es necesario, descarga la imagen correcta, inicia el contenedor y abre `http://localhost:8080`. No es necesario usar PowerShell manualmente.

## Primer uso

El asistente tiene seis pasos:

1. idioma detectado desde Windows y el navegador;
2. explicación de seguridad;
3. tiendas visibles y automatizadas;
4. credenciales opcionales;
5. intervalo, horarios e inicio con Windows;
6. revisión y primera ejecución.

Deja vacía cualquier cuenta si prefieres iniciar sesión manualmente. Pulsa **Navegador** y entra directamente en la tienda dentro de la sesión visual local. Las cookies y sesiones quedan en el volumen Docker.

## Seguridad y credenciales

| Pregunta | Respuesta |
|---|---|
| ¿Rafael o Claimer Control reciben mis contraseñas? | No. No existe un servidor nuestro que reciba los datos del panel. |
| ¿Dónde se guardan? | En `gui.env`, dentro del volumen Docker local y con permisos restringidos. |
| ¿La contraseña sale del equipo? | Solo para que el navegador automatizado la envíe directamente al inicio oficial de la tienda. |
| ¿El panel puede mostrar una contraseña guardada? | No. La API solo indica si el campo está configurado. |
| ¿El panel está en Internet? | No. Usa `127.0.0.1` por defecto. No expongas el puerto 8080. |
| ¿Hay telemetría? | No. Las conexiones externas son las tiendas, notificaciones configuradas y búsqueda de actualizaciones. |

El botón `?` junto a cada credencial explica para qué tienda se utiliza. Las contraseñas y sesiones locales siguen siendo datos sensibles: protege tu cuenta de Windows y el disco.

## Capturas

Todas las capturas usan cuentas sintéticas y resultados de demostración.

| Configuración inicial | Seguridad local |
|---|---|
| ![Elección de idioma](images/01-language.png) | ![Explicación de seguridad](images/02-security.png) |

| Tiendas | Credenciales |
|---|---|
| ![Selección de tiendas](images/03-stores.png) | ![Ayuda de credenciales](images/04-credentials.png) |

| Panel | Monedas de AliExpress |
|---|---|
| ![Resultados de juegos](images/05-dashboard.png) | ![Saldo y racha de AliExpress](images/06-aliexpress.png) |

| Programación | Inicio manual |
|---|---|
| ![Configuración de horarios](images/07-schedule.png) | ![Navegador visual local](images/08-browser.png) |

## Automatización y actualizaciones

- Intervalo predeterminado: 12 horas.
- Se pueden usar horarios fijos, combinar ambos modos o ejecutar solo manualmente.
- Iniciar con Windows viene marcado en el instalador, pero se puede desactivar.
- El panel consulta la Release oficial y muestra **Ver actualización**. El launcher local actualiza la imagen solo después de confirmar y conserva el volumen.
- La desinstalación conserva cuentas, historial y sesiones por defecto. Eliminarlos requiere una confirmación separada.
- El desinstalador nunca elimina Docker Desktop.

## Instalación manual

Para Linux, NAS o desarrollo:

```bash
git clone https://github.com/rafaelcairess/free-games-claimer-remaster-gui.git
cd free-games-claimer-remaster-gui
cp .env.example .env
docker compose up -d
```

- Panel: `http://localhost:8080`
- Navegador visual: `http://localhost:7080`
- Logs: `docker logs -f fgc-remaster`

Las opciones avanzadas y todas las variables están en la [referencia principal](../README.md#configuration) y en [`.env.example`](../.env.example).

## Solución de problemas

| Problema | Solución |
|---|---|
| Docker no inicia | Abre Docker Desktop, completa sus pantallas iniciales y ejecuta de nuevo el acceso directo. |
| La tienda solicita 2FA o CAPTCHA | Abre **Navegador** y complétalo manualmente. El proyecto no intenta eludir desafíos de seguridad. |
| El panel no abre | Comprueba que el contenedor `claimer-control` esté activo en Docker Desktop. |
| El inicio de sesión no persiste | Comprueba que exista el volumen `claimer-control-data`. |
| La actualización no se abre | Usa el acceso directo del menú Inicio y vuelve a intentarlo; el navegador puede pedir confirmar el protocolo local. |

## Licencia y créditos

Interfaz y distribución Claimer Control por [Rafael Caires](https://github.com/rafaelcairess). Motor basado en el proyecto de [Paweł Adamiec](https://github.com/P-Adamiec/Free-Games-Claimer-Remaster) y sus contribuidores, inspirado en el proyecto Node.js de [vogler](https://github.com/vogler/free-games-claimer). Licencia [AGPL-3.0](../LICENSE).
