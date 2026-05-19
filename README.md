# :bird: pterodactyl-installer

[![Shellcheck](https://github.com/pterodactyl-installer/pterodactyl-installer/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/pterodactyl-installer/pterodactyl-installer/actions/workflows/shellcheck.yml)
[![License: GPL v3](https://img.shields.io/github/license/pterodactyl-installer/pterodactyl-installer)](LICENSE)
[![Discord](https://img.shields.io/discord/682342331206074373?label=&logo=discord&logoColor=ffffff&color=7389D8&labelColor=6A7EC2)](https://pterodactyl-installer.se/discord)
no[![made-with-bash](https://img.shields.io/badge/-Hecho%20con%20Bash-1f425f.svg?logo=image%2Fpng%3Bbase64%2CiVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw%2FeHBhY2tldCBiZWdpbj0i77u%2FIiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8%2BIDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMTExIDc5LjE1ODMyNSwgMjAxNS8wOS8xMC0wMToxMDoyMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTUgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOkE3MDg2QTAyQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOkE3MDg2QTAzQUZCMzExRTVBMkQxRDMzMkJDMUQ4RDk3Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6QTcwODZBMDBBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6QTcwODZBMDFBRkIzMTFFNUEyRDFEMzMyQkMxRDhEOTciLz4gPC9yZGY6RGVzY3JpcHRpb24%2BIDwvcmRmOlJERj4gPC94OnhtcG1ldGE%2BIDw%2FeHBhY2tldCBlbmQ9InIiPz6lm45hAAADkklEQVR42qyVa0yTVxzGn7d9Wy03MS2ii8s%2BeokYNQSVhCzOjXZOFNF4jx%2BMRmPUMEUEqVG36jo2thizLSQSMd4N8ZoQ8RKjJtooaCpK6ZoCtRXKpRempbTv5ey83bhkAUphz8fznvP8znn%2B%2F3NeEEJgNBoRRSmz0ub%2FfuxEacBg%2FDmYtiCjgo5NG2mBXq%2BH5I1ogMRk9Zbd%2BQU2e1ML6VPLOyf5tvBQ8yT1lG10imxsABm7SLs898GTpyYynEzP60hO3trHDKvMigUwdeaceacqzp7nOI4n0SSIIjl36ao4Z356OV07fSQAk6xJ3XGg%2BLCr1d1OYlVHp4eUHPnerU79ZA%2F1kuv1JQMAg%2BE4O2P23EumF3VkvHprsZKMzKwbRUXFEyTvSIEmTVbrysp%2BWr8wfQHGK6WChVa3bKUmdWou%2BjpArdGkzZ41c1zG%2Fu5uGH4swzd561F%2BuhIT4%2BLnSuPsv9%2BJKIpjNr9dXYOyk7%2FBZrcjIT4eCnoKgedJP4BEqhG77E3NKP31FO7cfQA5K0dSYuLgz2TwCWJSOBzG6crzKK%2BohNfni%2Bx6OMUMMNe%2Fgf7ocbw0v0acKg6J8Ql0q%2BT%2FAXR5PNi5dz9c71upuQqCKFAD%2BYhrZLEAmpodaHO3Qy6TI3NhBpbrshGtOWKOSMYwYGQM8nJzoFJNxP2HjyIQho4PewK6hBktoDcUwtIln4PjOWzflQ%2Be5yl0yCCYgYikTclGlxadio%2BBQCSiW1UXoVGrKYwH4RgMrjU1HAB4vR6LzWYfFUCKxfS8Ftk5qxHoCUQAUkRJaSEokkV6Y%2F%2BJUOC4hn6A39NVXVBYeNP8piH6HeA4fPbpdBQV5KOx0QaL1YppX3Jgk0TwH2Vg6S3u%2BdB91%2B%2FpuNYPYFl5uP5V7ZqvsrX7jxqMXR6ff3gCQSTzFI0a1TX3wIs8ul%2Bq4HuWAAiM39vhOuR1O1fQ2gT%2F26Z8Z5vrl2OHi9OXZn995nLV9aFfS6UC9JeJPfuK0NBohWpCHMSAAsFe74WWP%2BvT25wtP9Bpob6uGqqyDnOtaeumjRu%2ByFu36VntK%2FPA5umTJeUtPWZSU9BCgud661odVp3DZtkc7AnYR33RRC708PrVi1larW7XwZIjLnd7R6SgSqWSNjU1B3F72pz5TZbXmX5vV81Yb7Lg7XT%2FUXriu8XLVqw6c6XqWnBKiiYU%2BMt3wWF7u7i91XlSEITwSAZ%2FCzAAHsJVbwXYFFEAAAAASUVORK5CYII%3D)](https://www.gnu.org/software/bash/)

Scripts no oficiales para instalar Pterodactyl Panel y Wings. Funciona con la version mas reciente de Pterodactyl.

Lee mas sobre [Pterodactyl](https://pterodactyl.io/) aqui. Este script no esta asociado con el proyecto oficial de Pterodactyl.

## Caracteristicas

- Instalacion automatica del Panel de Pterodactyl (dependencias, base de datos, cronjob, nginx).
- Instalacion automatica de Pterodactyl Wings (Docker, systemd).
- Panel: (opcional) configuracion automatica de Let's Encrypt.
- Panel: (opcional) configuracion automatica de firewall.
- Soporte de desinstalacion para panel y wings.

## Ayuda y soporte

Para ayuda y soporte sobre el script y **no sobre el proyecto oficial de Pterodactyl**, puedes unirte al [Discord](https://pterodactyl-installer.se/discord).

## Guia en espanol

Si prefieres espanol, revisa `README.es.md`.
Para la licencia en espanol, revisa `LICENSE.es.md` (la version oficial sigue en `LICENSE`).

**Aviso legal:** `LICENSE` es el texto legal oficial y vinculante. `LICENSE.es.md` es solo una traduccion informativa.

## Instalaciones soportadas

Lista de instalaciones soportadas para panel y Wings (soportadas por este script).

### Sistemas operativos soportados para panel y wings

| Sistema operativo | Version | Soportado          | Version PHP |
| ---------------- | ------- | ------------------ | ----------- |
| Ubuntu           | 14.04   | :red_circle:       |             |
|                  | 16.04   | :red_circle: \*    |             |
|                  | 18.04   | :red_circle: \*    |             |
|                  | 20.04   | :red_circle: \*    |             |
|                  | 22.04   | :white_check_mark: | 8.3         |
|                  | 24.04   | :white_check_mark: | 8.3         |
| Debian           | 8       | :red_circle: \*    |             |
|                  | 9       | :red_circle: \*    |             |
|                  | 10      | :white_check_mark: | 8.3         |
|                  | 11      | :white_check_mark: | 8.3         |
|                  | 12      | :white_check_mark: | 8.3         |
|                  | 13      | :white_check_mark: | 8.3         |
| CentOS           | 6       | :red_circle:       |             |
|                  | 7       | :red_circle: \*    |             |
|                  | 8       | :red_circle: \*    |             |
| Rocky Linux      | 8       | :white_check_mark: | 8.3         |
|                  | 9       | :white_check_mark: | 8.3         |
| AlmaLinux        | 8       | :white_check_mark: | 8.3         |
|                  | 9       | :white_check_mark: | 8.3         |

_\* Indica un sistema operativo y version que anteriormente era soportado por este script._

## Uso de los scripts de instalacion

Para usar los scripts de instalacion, ejecuta este comando como root. El script te preguntara si quieres instalar solo el panel, solo Wings o ambos.

```bash
bash <(curl -s https://pterodactyl-installer.se)
```

_Nota: En algunos sistemas es necesario estar logueado como root antes de ejecutar el comando (usar `sudo` no funciona)._

Aqui tienes un [video de YouTube](https://www.youtube.com/watch?v=E8UJhyUFoHM) que muestra el proceso de instalacion.

## Configuracion del firewall

Los scripts pueden instalar y configurar un firewall por ti. El script te preguntara si deseas hacerlo. Se recomienda activar la configuracion automatica del firewall.

## Desarrollo y Ops

### Probar el script localmente

Para probar el script usamos [Vagrant](https://www.vagrantup.com). Con Vagrant puedes levantar rapidamente una maquina limpia para probar el script.

Si quieres probar el script en todas las instalaciones soportadas, ejecuta lo siguiente.

```bash
vagrant up
```

Si solo quieres probar una distribucion especifica, ejecuta lo siguiente.

```bash
vagrant up <name>
```

Reemplaza name con una de las siguientes opciones (instalaciones soportadas).

- `ubuntu_jammy`
- `debian_bullseye`
- `debian_buster`
- `debian_bookworm`
- `debian_trixie`
- `almalinux_8`
- `almalinux_9`
- `rockylinux_8`
- `rockylinux_9`

Luego puedes usar `vagrant ssh <name of machine>` para entrar por SSH. El directorio del proyecto se montara en `/vagrant`, asi puedes modificar y probar rapido con `/vagrant/installers/panel.sh` y `/vagrant/installers/wings.sh`.

### Crear un release

En `install.sh`, las variables de github source y script release deben cambiar en cada lanzamiento. Primero, actualiza `CHANGELOG.md` para mostrar fecha y tag del lanzamiento. No cambies los puntos del changelog. Luego actualiza `GITHUB_SOURCE` y `SCRIPT_RELEASE` en `install.sh`. Finalmente, puedes hacer commit con `Release vX.Y.Z` y crear el lanzamiento en GitHub. Ver [este commit](https://github.com/pterodactyl-installer/pterodactyl-installer/commit/90aaae10785f1032fdf90b216a4a8d8ca64e6d44).

## Contribuidores ✨

Derechos de autor (C) 2018 - 2026, Vilhelm Prytz, <vilhelm@prytznet.se>, y contribuidores.

- Created by [Vilhelm Prytz](https://github.com/vilhelmprytz)
- Maintained by [Linux123123](https://github.com/Linux123123)

Gracias a los moderadores de Discord [sam1370](https://github.com/sam1370), [Linux123123](https://github.com/Linux123123) y [sinjs](https://github.com/sinjs) por su ayuda en el servidor de Discord.
