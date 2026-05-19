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

# Instalar mariadb
export INSTALL_MARIADB=false

# Firewall
export CONFIGURE_FIREWALL=false

# SSL (Let's Encrypt)
export CONFIGURE_LETSENCRYPT=false
export FQDN=""
export EMAIL=""

# Database host
export CONFIGURE_DBHOST=false
export CONFIGURE_DB_FIREWALL=false
export MYSQL_DBHOST_HOST="127.0.0.1"
export MYSQL_DBHOST_USER="pterodactyluser"
export MYSQL_DBHOST_PASSWORD=""

# ------------ User input functions ------------ #

ask_letsencrypt() {
  if [ "$CONFIGURE_FIREWALL" == false ]; then
    warning "Let's Encrypt requiere que los puertos 80/443 esten abiertos. Has rechazado la configuracion automatica del firewall; usa esto bajo tu propio riesgo (si los puertos 80/443 estan cerrados, el script fallara)."
  fi

  warning "No puedes usar Let's Encrypt con una IP. Debe ser un FQDN (ejemplo: node.example.org)."

  echo -e -n "* Quieres configurar HTTPS automaticamente con Let's Encrypt? (y/N): "
  read -r CONFIRM_SSL

  if [[ "$CONFIRM_SSL" =~ [Yy] ]]; then
    CONFIGURE_LETSENCRYPT=true
  fi
}

ask_database_user() {
  echo -n "* Quieres configurar automaticamente un usuario para hosts de base de datos? (y/N): "
  read -r CONFIRM_DBHOST

  if [[ "$CONFIRM_DBHOST" =~ [Yy] ]]; then
    ask_database_external
    CONFIGURE_DBHOST=true
  fi
}

ask_database_external() {
  echo -n "* Quieres configurar MySQL para acceso externo? (y/N): "
  read -r CONFIRM_DBEXTERNAL

  if [[ "$CONFIRM_DBEXTERNAL" =~ [Yy] ]]; then
    echo -n "* Ingresa la direccion del panel (vacio para cualquier direccion): "
    read -r CONFIRM_DBEXTERNAL_HOST
    if [ "$CONFIRM_DBEXTERNAL_HOST" == "" ]; then
      MYSQL_DBHOST_HOST="%"
    else
      MYSQL_DBHOST_HOST="$CONFIRM_DBEXTERNAL_HOST"
    fi
    [ "$CONFIGURE_FIREWALL" == true ] && ask_database_firewall
    return 0
  fi
}

ask_database_firewall() {
  warning "Permitir trafico entrante al puerto 3306 (MySQL) puede ser un riesgo de seguridad, a menos que sepas lo que haces."
  echo -n "* Quieres permitir trafico entrante al puerto 3306? (y/N): "
  read -r CONFIRM_DB_FIREWALL
  if [[ "$CONFIRM_DB_FIREWALL" =~ [Yy] ]]; then
    CONFIGURE_DB_FIREWALL=true
  fi
}

####################
## MAIN FUNCTIONS ##
####################

main() {
  # check if we can detect an already existing installation
  if [ -d "/etc/pterodactyl" ]; then
    warning "El script detecto que ya tienes Pterodactyl Wings en el sistema. No puedes ejecutar el script varias veces, fallara."
    echo -e -n "* Estas seguro de continuar? (y/N): "
    read -r CONFIRM_PROCEED
    if [[ ! "$CONFIRM_PROCEED" =~ [Yy] ]]; then
      error "Instalacion cancelada."
      exit 1
    fi
  fi

  welcome "wings"

  check_virt

  echo "* "
  echo "* El instalador instalara Docker, dependencias requeridas para Wings"
  echo "* y tambien Wings. Aun asi, debes crear el nodo en el panel y"
  echo "* luego colocar el archivo de configuracion en el nodo manualmente"
  echo "* despues de finalizar la instalacion. Mas informacion en la"
  echo "* documentacion oficial: $(hyperlink 'https://pterodactyl.io/wings/1.0/installing.html#configure')"
  echo "* "
  echo -e "* ${COLOR_RED}Nota${COLOR_NC}: este script no iniciara Wings automaticamente (solo instala el servicio systemd)."
  echo -e "* ${COLOR_RED}Nota${COLOR_NC}: este script no habilita swap (para Docker)."
  print_brake 42

  ask_firewall CONFIGURE_FIREWALL

  ask_database_user

  if [ "$CONFIGURE_DBHOST" == true ]; then
    type mysql >/dev/null 2>&1 && HAS_MYSQL=true || HAS_MYSQL=false

    if [ "$HAS_MYSQL" == false ]; then
      INSTALL_MARIADB=true
    fi

    MYSQL_DBHOST_USER="-"
    while [[ "$MYSQL_DBHOST_USER" == *"-"* ]]; do
      required_input MYSQL_DBHOST_USER "Usuario del host de base de datos (pterodactyluser): " "" "pterodactyluser"
      [[ "$MYSQL_DBHOST_USER" == *"-"* ]] && error "El usuario de base de datos no puede contener guiones"
    done

    password_input MYSQL_DBHOST_PASSWORD "Contrasena del host de base de datos: " "La contrasena no puede estar vacia"
  fi

  ask_letsencrypt

  if [ "$CONFIGURE_LETSENCRYPT" == true ]; then
    while [ -z "$FQDN" ]; do
      echo -n "* Define el FQDN para Let's Encrypt (node.example.com): "
      read -r FQDN

      ASK=false

      [ -z "$FQDN" ] && error "El FQDN no puede estar vacio"                                                     # check if FQDN is empty
      bash <(curl -s "$GITHUB_URL"/lib/verify-fqdn.sh) "$FQDN" || ASK=true                                      # check if FQDN is valid
      [ -d "/etc/letsencrypt/live/$FQDN/" ] && error "Ya existe un certificado con este FQDN." && ASK=true        # check if cert exists

      [ "$ASK" == true ] && FQDN=""
      [ "$ASK" == true ] && echo -e -n "* Aun quieres configurar HTTPS automaticamente con Let's Encrypt? (y/N): "
      [ "$ASK" == true ] && read -r CONFIRM_SSL

      if [[ ! "$CONFIRM_SSL" =~ [Yy] ]] && [ "$ASK" == true ]; then
        CONFIGURE_LETSENCRYPT=false
        FQDN=""
      fi
    done
  fi

  if [ "$CONFIGURE_LETSENCRYPT" == true ]; then
    # set EMAIL
    while ! valid_email "$EMAIL"; do
      echo -n "* Ingresa el correo para Let's Encrypt: "
      read -r EMAIL

      valid_email "$EMAIL" || error "El correo no puede estar vacio o invalido"
    done
  fi

  echo -n "* Continuar con la instalacion? (y/N): "

  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "wings"
  else
    error "Instalacion cancelada."
    exit 1
  fi
}

function goodbye {
  echo ""
  print_brake 70
  echo "* Instalacion de Wings completada"
  echo "*"
  echo "* Para continuar, debes configurar Wings para que funcione con tu panel"
  echo "* Consulta la guia oficial: $(hyperlink 'https://pterodactyl.io/wings/1.0/installing.html#configure')"
  echo "* "
  echo "* Puedes copiar manualmente el archivo de configuracion del panel a /etc/pterodactyl/config.yml"
  echo "* o usar el boton \"auto deploy\" del panel y pegar el comando en esta terminal"
  echo "* "
  echo "* Luego puedes iniciar Wings manualmente para verificar que funciona"
  echo "*"
  echo "* sudo wings"
  echo "*"
  echo "* Cuando verifiques que funciona, usa CTRL+C y luego inicia Wings como servicio (en segundo plano)"
  echo "*"
  echo "* systemctl start wings"
  echo "*"
  echo -e "* ${COLOR_RED}Nota${COLOR_NC}: Se recomienda habilitar swap (para Docker, ver documentacion oficial)."
  [ "$CONFIGURE_FIREWALL" == false ] && echo -e "* ${COLOR_RED}Nota${COLOR_NC}: Si no configuraste tu firewall, los puertos 8080 y 2022 deben estar abiertos."
  print_brake 70
  echo ""
}

# run script
main
goodbye
