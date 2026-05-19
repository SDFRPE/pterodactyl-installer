# Registro de cambios

Este proyecto sigue la convencion de [versionado semantico](https://semver.org). Los puntos del registro de cambios se dividen en corregido, cambiado o agregado.

## v1.2.0 (publicado el 2025-09-24)

### Corregido

- [a1016ac](https://github.com/pterodactyl-installer/pterodactyl-installer/commit/a1016ac8dfe0a833200b99f84e139063c05ba00b) instalacion: volver a agregar export a las variables
- [#523](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/523) all: actualizar el anio de copyright a 2025
- [#529](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/529) panel: Europe/Kiev renombrado a Europe/Kyiv

### Agregado

- [#543](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/543) all: agregar soporte para Debian 13

## v1.1.1 (publicado el 2024-11-15)

### Corregido

- [#514](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/514) panel: actualizar PHP de 8.1 a 8.3 (gracias [@SuperEvilLuke](https://github.com/SuperEvilLuke) por contribuir)
- [#502](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/502) panel/wings: agregar mas validaciones y mas logs en el script de desinstalacion (gracias [QXIoa](https://github.com/QXIoa) por contribuir)

## v1.1.0 (publicado el 2024-07-10)

### Corregido

- [#451](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/451) all: actualizar el anio de copyright a 2024 (gracias [@BeastGamer81](https://github.com/BeastGamer81) por contribuir)
- [#452](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/452) panel/wings: reemplazar comandos mysql por mariadb
- [#480](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/480) panel: actualizar archivo pteroq.service por defecto

### Agregado

- [#467](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/467) panel/wings: agregar soporte para Ubuntu 24.04

## v1.0.0 (publicado el 2023-07-31)

### Agregado

- [#416](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/416) panel/wings: agregar soporte para Debian 12 (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.12.3 (publicado el 2023-02-18)

### Corregido

- [#385](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/385) lib: corregir un bug que causaba fallo en algunos sistemas por rutas faltantes en $PATH (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)
- [#392](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/392) lib: volver a agregar la funcion faltante `print_list` usada en el script de desinstalacion (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.12.2 (publicado el 2022-12-18)

### Corregido

- [#366](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/366) panel/lib/wings: corregir ask_database_external, problemas de shellcheck y soporte roto para Alma Linux y Rocky Linux (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)
- [#377](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/377) wings: corregir llamada a funcion de firewall incorrecta (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.12.1 (publicado el 2022-12-01)

### Corregido

- [#359](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/359) lib: corregir un bug donde `curl` no podia sobrescribir `/tmp/lib.sh`

## v0.12.0 (publicado el 2022-12-01)

- [#353](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/353) panel: actualizar version de PHP a 8.1 (gracias [@drylian](https://github.com/drylian) por contribuir)
- [#315](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/315) panel/wings: separar scripts en componentes, funciones UI y funciones de instalacion. Cambio mayor, pueden aparecer bugs (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)
- [#283](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/283) panel/wings: agregar soporte para Rocky Linux y AlmaLinux, y remover soporte para CentOS y Debian 9 (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.11.0 (publicado el 2022-05-17)

### Agregado

- [#322](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/322) panel/wings: agregar soporte para Ubuntu 22.04

### Corregido

- [#262](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/262) wings: corregir bug donde fallaba por falta de /usr/sbin en $PATH al ejecutar virt-what (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.10.0 (publicado el 2022-03-14)

### Agregado

- [#300](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/300) panel: verificar si el FQDN es IP y omitir Let's Encrypt si es IP (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

### Corregido

- [#285](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/285) panel: corregir configuraciones de Nginx para escuchar IPv6 por defecto

### Cambiado

- [#267](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/267) wings: reescribir parte de la funcionalidad de host de base de datos para clientes MySQL remotos (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)
- [#288](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/288) wings: evitar uso de apt-key deprecado durante instalacion de Docker
- [#289](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/289) reemplazar referencias a "daemon" por Wings

## v0.9.0 (publicado el 2021-12-05)

### Agregado

- [#249](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/249) instalacion: registrar automaticamente el proceso de instalacion en `/var/log/pterodactyl-installer.log` (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

### Corregido

- [#229](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/229) wings: corregir fallo al obtener certificado Let's Encrypt en CentOS 7 y 8 por falta de `epel-release` (gracias [@Linux123123](https://github.com/Linux123123) por reportar)
- [#264](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/264) instalacion: corregir etiqueta incorrecta en opcion de setup (gracias [@NoahvdAa](https://github.com/NoahvdAa) por contribuir)
- [#266](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/266) panel/wings: no se soporta el uso de guiones en nombres de base/usuarios; ahora se valida (gracias [@GoudronViande24](https://github.com/GoudronViande24) por reportar)

## v0.8.1 (publicado el 2021-08-28)

### Corregido

- [#238](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/238) panel: corregir fallo en CentOS 8 por referencia invalida a `mariadb-secure-installation`

## v0.8.0 (publicado el 2021-08-28)

### Agregado

- [#220](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/220) wings: agregar funcion para crear automaticamente un usuario de "database host" (gracias [@sinjs](https://github.com/sinjs) por contribuir)
- [#230](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/230) panel/wings: agregar soporte para Debian 11 (bullseye) (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.7.1 (publicado el 2021-07-31)

### Corregido

- [#217](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/217) panel: corregir fallo en CentOS por falta del symlink `mysql_secure_installation` (gracias [@aa-abert](https://github.com/aa-abert) por contribuir)

## v0.7.0 (publicado el 2021-07-16)

### Corregido

- [#193](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/193) lib/verify-fqdn: corregir typo menor, "Encrypt" estaba mal escrito (gracias [@Hey](https://github.com/Hey) por contribuir)
- [#201](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/201) lib/verify-fqdn: corregir para que CNAME funcione como FQDN y sea detectado correctamente (gracias [@jobhh](https://github.com/jobhh) por contribuir)
- [#200](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/200) wings: corregir bug donde no se detectaba virtualizacion no soportada (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

### Agregado

- [#81](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/81) wings: agregar funcion para omitir automaticamente la pregunta de MariaDB si ya existe MySQL/MariaDB
- [#204](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/204) wings: agregar soporte para arm64 (gracias [@puiemonta1234](https://github.com/puiemonta1234) por contribuir)

## v0.6.0 (publicado el 2021-05-21)

### Corregido

- [#186](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/186) panel: corregir bug donde el script terminaba al intentar crear un symlink dos veces (gracias [@Linux123123](https://github.com/Linux123123) por reportar y contribuir)

### Agregado

- [#157](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/157) panel/wings: agregar validacion de email. Ahora se valida con regex antes de aceptar valores (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.5.0 (publicado el 2021-05-15)

### Corregido

- [#158](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/158) panel: corregir bug que permitia ejecutar en arquitecturas distintas de `x86_64`; ahora se muestra advertencia (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)
- [#176](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/176) wings: corregir link roto de documentacion oficial (gracias [@sinmineryt](https://github.com/sinmineryt) por contribuir)

### Cambiado

- [#160](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/160) wings: virtualizaciones no soportadas ya no cierran el script; se agrega opcion para continuar

## v0.4.0 (publicado el 2021-03-16)

### Cambiado

- [#168](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/168) panel: usar PHP 8.0 en lugar de 7.4 en instalaciones soportadas (gracias [@Linux123123](https://github.com/Linux123123) por contribuir)

## v0.3.0 (publicado el 2021-02-24)

### Corregido

- [#151](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/151) panel: `APP_ENVIRONMENT_ONLY` estaba en `true` cuando debia ser `false`, lo que impedia modificar ajustes desde la web
- [#165](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/165) panel: corregir para que `pteroq` use el usuario correcto en CentOS (gracias [@PipeItToDevNull](https://github.com/PipeItToDevNull) por reportar)

### Cambiado

- [#129](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/129) wings: aclarar como conectar Wings con el panel (auto deploy)
- [#153](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/153) panel/wings: cambiar para no pedir abrir puertos si el firewall automatico esta habilitado
- [#153](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/153) panel: remover sugerencias de terceros deprecadas

### Agregado

- [#148](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/148) wings: agregar verificacion FQDN con `lib/verify-fqdn` si se configura Let's Encrypt automaticamente

## v0.2.0 (publicado el 2021-01-18)

### Corregido

- [#113](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/113) panel: corregir fallo por "bus connection" al iniciar el script (relacionado con [#115](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/115))
- [#135](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/135) panel/wings: corregir para que la configuracion automatica de ufw no requiera confirmacion en el enable

### Cambiado

- [#88](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/88) panel: cambiar a `certbot --nginx` en lugar de `certbot certonly` para facilitar renovaciones (gracias [@Linux123123](https://github.com/Linux123123))
- [#100](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/100) panel: refactor de funciones, remover variables redundantes y limpieza general (gracias [@Linux123123](https://github.com/Linux123123))
- [#115](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/115) panel: refactor de validacion de zona horaria
- [#137](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/137) panel: remover capacidad de ejecutar `p:environment:mail` por redundancia
- [#139](https://github.com/pterodactyl-installer/pterodactyl-installer/pull/139) wings: refactor - reemplazar `"$var"` con `[ "$var" == true ]` (gracias [@Linux123123](https://github.com/Linux123123))

### Agregado

- [098d01a](https://github.com/pterodactyl-installer/pterodactyl-installer/commit/098d01a9729dffaf40e80077da2d7d51b42a197b) panel: agregar un prompt en `verify-fqdn` para pedir consentimiento antes de la solicitud HTTPS a [https://checkip.pterodactyl-installer.se](https://checkip.pterodactyl-installer.se)
- [#78](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/78) panel: agregar opcion para generar contrasenas MySQL automaticamente y recordarlas durante la instalacion

## v0.1.1 (publicado el 2021-01-01)

### Corregido

- [#133](https://github.com/pterodactyl-installer/pterodactyl-installer/issues/133) panel: corregir `verify-fqdn.sh` para instalar paquetes en modo silencioso; ahora solo se ejecuta si `ASSUME_SSL` o `CONFIGURE_LETSENCRYPT` es true

## v0.1.0 (publicado el 2021-01-01)

- Release inicial, introduce versionado al proyecto
