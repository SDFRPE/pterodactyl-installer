#!/bin/bash

set -e

######################################################################################
#                                                                                    #
# Proyecto 'pterodactyl-installer'                                                   #
#                                                                                    #
# Derechos de autor (C) 2018 - 2026, Vilhelm Prytz, <vilhelm@prytznet.se>            #
#                                                                                    #
#   Este programa es software libre: puedes redistribuirlo y/o modificarlo           #
#   bajo los terminos de la Licencia Publica General GNU publicada por               #
#   la Free Software Foundation, ya sea la version 3 de la Licencia, o               #
#   (a tu eleccion) cualquier version posterior.                                     #
#                                                                                    #
#   Este programa se distribuye con la esperanza de que sea util,                    #
#   pero SIN NINGUNA GARANTIA; sin siquiera la garantia implicita de                 #
#   COMERCIALIZACION o IDONEIDAD PARA UN PROPOSITO PARTICULAR. Consulta la           #
#   Licencia Publica General GNU para mas detalles.                                  #
#                                                                                    #
#   Deberias haber recibido una copia de la Licencia Publica General GNU             #
#   junto con este programa. Si no, consulta <https://www.gnu.org/licenses/>.        #
#                                                                                    #
# https://github.com/pterodactyl-installer/pterodactyl-installer/blob/master/LICENSE #
#                                                                                    #
# Este script no esta asociado con el proyecto oficial de Pterodactyl.               #
# https://github.com/pterodactyl-installer/pterodactyl-installer                     #
#                                                                                    #
######################################################################################

# Verifica si el script esta cargado; si no, cargalo o falla.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: No se pudo cargar el script de libreria" && exit 1
fi

# ------------------ Variables ----------------- #

RM_PANEL="${RM_PANEL:-true}"
RM_WINGS="${RM_WINGS:-true}"

# ---------- Uninstallation functions ---------- #

rm_panel_files() {
  output "Eliminando archivos del panel..."
  rm -rf /var/www/pterodactyl /usr/local/bin/composer
  [ "$OS" != "centos" ] && [ -L /etc/nginx/sites-enabled/pterodactyl.conf ] && unlink /etc/nginx/sites-enabled/pterodactyl.conf
  [ "$OS" != "centos" ] && [ -f /etc/nginx/sites-available/pterodactyl.conf ] && rm -f /etc/nginx/sites-available/pterodactyl.conf
  [ "$OS" != "centos" ] && [ ! -L /etc/nginx/sites-enabled/default ] && [ -f /etc/nginx/sites-available/default ] && ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
  [ "$OS" == "centos" ] && [ -f /etc/nginx/conf.d/pterodactyl.conf ] && rm -f /etc/nginx/conf.d/pterodactyl.conf
  systemctl restart nginx
  success "Archivos del panel eliminados."
}

rm_docker_containers() {
  output "Eliminando contenedores e imagenes de Docker..."

  docker system prune -a -f

  success "Contenedores e imagenes de Docker eliminados."
}

rm_wings_files() {
  output "Eliminando archivos de Wings..."

  systemctl disable --now wings
  [ -f /etc/systemd/system/wings.service ] && rm -rf /etc/systemd/system/wings.service

  [ -d /etc/pterodactyl ] && rm -rf /etc/pterodactyl
  [ -f /usr/local/bin/wings ] && rm -rf /usr/local/bin/wings
  [ -d /var/lib/pterodactyl ] && rm -rf /var/lib/pterodactyl
  success "Archivos de Wings eliminados."
}

rm_services() {
  output "Eliminando servicios..."
  systemctl disable --now pteroq
  rm -rf /etc/systemd/system/pteroq.service
  case "$OS" in
  debian | ubuntu)
    systemctl disable --now redis-server
    ;;
  centos | rocky | almalinux)
    systemctl disable --now redis
    systemctl disable --now php-fpm
    rm -rf /etc/php-fpm.d/www-pterodactyl.conf
    ;;
  esac
  success "Servicios eliminados."
}

rm_cron() {
  output "Eliminando cron jobs..."
  local cron_line="* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1"
  crontab -l 2>/dev/null | grep -vF "$cron_line" | crontab -
  success "Cron jobs eliminados."
}

rm_database() {
  output "Eliminando base de datos..."
  valid_db=$(mariadb -u root -e "SELECT schema_name FROM information_schema.schemata;" 2>/dev/null | grep -v -E -- 'schema_name|information_schema|performance_schema|mysql')
  if [[ -z "$valid_db" ]]; then
    warning "No se encontraron bases de datos validas."
    return
  fi

  warning "Cuidado. Esta base de datos sera eliminada."
  if [[ "$valid_db" == *"panel"* ]]; then
    echo -n "* Se detecto una base de datos llamada panel. Es la base de Pterodactyl? (y/N): "
    read -r is_panel
    if [[ "$is_panel" =~ [Yy] ]]; then
      DATABASE=panel
    else
      print_list "$valid_db"
    fi
  else
    print_list "$valid_db"
  fi

  while [ -z "$DATABASE" ] || [[ "$valid_db" != *"$DATABASE"* ]]; do
    echo -n "* Elige la base del panel (para omitir, deja vacio): "
    read -r database_input
    if [[ -n "$database_input" ]]; then
      if [[ "$valid_db" == *"$database_input"* ]]; then
        DATABASE="$database_input"
      else
        warning "Nombre de base invalido. Intenta de nuevo."
      fi
    else
      break
    fi
  done

  if [[ -n "$DATABASE" ]]; then
    mariadb -u root -e "DROP DATABASE $DATABASE;" 2>/dev/null || warning "No se pudo eliminar la base $DATABASE."
  else
    output "No se selecciono base, se omite eliminacion."
  fi

  # Excluir usuarios User y root (esperamos que nadie use User)
  output "Eliminando usuario de base de datos..."
  valid_users=$(mariadb -u root -e "SELECT user FROM mysql.user;" 2>/dev/null | grep -v -E -- 'user|root')
  if [[ -z "$valid_users" ]]; then
    warning "No se encontraron usuarios validos."
    return
  fi

  warning "Cuidado. Este usuario sera eliminado."
  if [[ "$valid_users" == *"pterodactyl"* ]]; then
    echo -n "* Se detecto un usuario pterodactyl. Es el usuario de Pterodactyl? (y/N): "
    read -r is_user
    if [[ "$is_user" =~ [Yy] ]]; then
      DB_USER=pterodactyl
    else
      print_list "$valid_users"
    fi
  else
    print_list "$valid_users"
  fi

  while [ -z "$DB_USER" ] || [[ "$valid_users" != *"$DB_USER"* ]]; do
    echo -n "* Elige el usuario del panel (para omitir, deja vacio): "
    read -r user_input
    if [[ -n "$user_input" ]]; then
      if [[ "$valid_users" == *"$user_input"* ]]; then
        DB_USER=$user_input
      else
        warning "Usuario invalido. Intenta de nuevo."
      fi
    else
      break
    fi
  done

  if [[ -n "$DB_USER" ]]; then
    mariadb -u root -e "DROP USER '$DB_USER'@'127.0.0.1';" 2>/dev/null || warning "No se pudo eliminar el usuario $DB_USER."
  else
    output "No se selecciono usuario, se omite eliminacion."
  fi

  mariadb -u root -e "FLUSH PRIVILEGES;" 2>/dev/null
  success "Base de datos y usuario eliminados (si se selecciono)."
}


# --------------- Main functions --------------- #

perform_uninstall() {
  [ "$RM_PANEL" == true ] && rm_panel_files
  [ "$RM_PANEL" == true ] && rm_cron
  [ "$RM_PANEL" == true ] && rm_database
  [ "$RM_PANEL" == true ] && rm_services
  [ "$RM_WINGS" == true ] && rm_docker_containers
  [ "$RM_WINGS" == true ] && rm_wings_files

  return 0
}

# ------------------ Desinstalacion ------------ #

perform_uninstall
