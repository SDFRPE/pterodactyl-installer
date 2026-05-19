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

# Domain name / IP
export FQDN=""

# Default MySQL credentials
export MYSQL_DB=""
export MYSQL_USER=""
export MYSQL_PASSWORD=""

# Environment
export timezone=""
export email=""

# Initial admin account
export user_email=""
export user_username=""
export user_firstname=""
export user_lastname=""
export user_password=""

# Assume SSL, will fetch different config if true
export ASSUME_SSL=false
export CONFIGURE_LETSENCRYPT=false

# Firewall
export CONFIGURE_FIREWALL=false

# ------------ User input functions ------------ #

ask_letsencrypt() {
  if [ "$CONFIGURE_FIREWALL" == false ]; then
    warning "Let's Encrypt requiere que los puertos 80/443 esten abiertos. Has rechazado la configuracion automatica del firewall; usa esto bajo tu propio riesgo (si los puertos 80/443 estan cerrados, el script fallara)."
  fi

  echo -e -n "* Quieres configurar HTTPS automaticamente con Let's Encrypt? (y/N): "
  read -r CONFIRM_SSL

  if [[ "$CONFIRM_SSL" =~ [Yy] ]]; then
    CONFIGURE_LETSENCRYPT=true
    ASSUME_SSL=false
  fi
}

ask_assume_ssl() {
  output "Let's Encrypt no sera configurado automaticamente por este script (el usuario lo rechazo)."
  output "Puedes 'asumir' Let's Encrypt, lo que significa que el script descargara una configuracion de nginx preparada para usar un certificado Let's Encrypt, pero no obtendra el certificado por ti."
  output "Si asumes SSL y no obtienes el certificado, la instalacion no funcionara."
  echo -n "* Asumir SSL o no? (y/N): "
  read -r ASSUME_SSL_INPUT

  [[ "$ASSUME_SSL_INPUT" =~ [Yy] ]] && ASSUME_SSL=true
  true
}

check_FQDN_SSL() {
  if [[ $(invalid_ip "$FQDN") == 1 && $FQDN != 'localhost' ]]; then
    SSL_AVAILABLE=true
  else
    warning "* Let's Encrypt no estara disponible para direcciones IP."
    output "Para usar Let's Encrypt, debes usar un dominio valido."
  fi
}

main() {
  # verificar si ya existe una instalacion
  if [ -d "/var/www/pterodactyl" ]; then
    warning "El script detecto que ya tienes el panel de Pterodactyl en el sistema. No puedes ejecutar el script varias veces, fallara."
    echo -e -n "* Estas seguro de continuar? (y/N): "
    read -r CONFIRM_PROCEED
    if [[ ! "$CONFIRM_PROCEED" =~ [Yy] ]]; then
      error "Instalacion cancelada."
      exit 1
    fi
  fi

  welcome "panel"

  check_os_x86_64

  # set database credentials
  output "Configuracion de base de datos."
  output ""
  output "Estas credenciales se usaran para la comunicacion entre la base de datos MySQL"
  output "y el panel. No necesitas crear la base de datos antes de ejecutar este script,"
  output "el script lo hara por ti."
  output ""

  MYSQL_DB="-"
  while [[ "$MYSQL_DB" == *"-"* ]]; do
    required_input MYSQL_DB "Nombre de la base de datos (panel): " "" "panel"
    [[ "$MYSQL_DB" == *"-"* ]] && error "El nombre de la base de datos no puede contener guiones"
  done

  MYSQL_USER="-"
  while [[ "$MYSQL_USER" == *"-"* ]]; do
    required_input MYSQL_USER "Usuario de base de datos (pterodactyl): " "" "pterodactyl"
    [[ "$MYSQL_USER" == *"-"* ]] && error "El usuario de base de datos no puede contener guiones"
  done

  # MySQL password input
  rand_pw=$(gen_passwd 64)
  password_input MYSQL_PASSWORD "Contrasena (enter para usar una contrasena aleatoria): " "La contrasena de MySQL no puede estar vacia" "$rand_pw"

  readarray -t valid_timezones <<<"$(curl -s "$GITHUB_URL"/configs/valid_timezones.txt)"
  if [ ${#valid_timezones[@]} -eq 0 ]; then
    warning "No se pudo obtener la lista de zonas horarias; se aceptara cualquier valor no vacio."
  fi
  output "Lista de zonas horarias validas: $(hyperlink "https://www.php.net/manual/en/timezones.php")"

  while [ -z "$timezone" ]; do
    echo -n "* Selecciona zona horaria [Europe/Stockholm]: "
    read -r timezone_input

    if [ ${#valid_timezones[@]} -eq 0 ]; then
      [ -n "$timezone_input" ] && timezone="$timezone_input"
    else
      array_contains_element "$timezone_input" "${valid_timezones[@]}" && timezone="$timezone_input"
    fi
    [ -z "$timezone_input" ] && timezone="Europe/Stockholm" # because köttbullar!
  done

  email_input email "Correo para configurar Let's Encrypt y Pterodactyl: " "El correo no puede estar vacio o invalido"

  # Initial admin account
  email_input user_email "Correo del usuario admin inicial: " "El correo no puede estar vacio o invalido"
  required_input user_username "Usuario del admin inicial: " "El usuario no puede estar vacio"
  required_input user_firstname "Nombre del admin inicial: " "El nombre no puede estar vacio"
  required_input user_lastname "Apellido del admin inicial: " "El apellido no puede estar vacio"
  password_input user_password "Contrasena del admin inicial: " "La contrasena no puede estar vacia"

  print_brake 72

  # set FQDN
  while [ -z "$FQDN" ]; do
    echo -n "* Define el FQDN de este panel (panel.example.com): "
    read -r FQDN
    [ -z "$FQDN" ] && error "El FQDN no puede estar vacio"
  done

  # Verificar si SSL esta disponible
  check_FQDN_SSL

  # Ask if firewall is needed
  ask_firewall CONFIGURE_FIREWALL

  # Solo preguntar por SSL si esta disponible
  if [ "$SSL_AVAILABLE" == true ]; then
    # Ask if letsencrypt is needed
    ask_letsencrypt
    # Si ya es true, esto deberia ser directo
    [ "$CONFIGURE_LETSENCRYPT" == false ] && ask_assume_ssl
  fi

  # verificar FQDN si el usuario eligio asumir SSL o configurar Let's Encrypt
  [ "$CONFIGURE_LETSENCRYPT" == true ] || [ "$ASSUME_SSL" == true ] && bash <(curl -s "$GITHUB_URL"/lib/verify-fqdn.sh) "$FQDN"

  # summary
  summary

  # confirmar instalacion
  echo -e -n "\n* Configuracion inicial completada. Continuar con la instalacion? (y/N): "
  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "panel"
  else
    error "Instalacion cancelada."
    exit 1
  fi
}

summary() {
  print_brake 62
  output "Panel Pterodactyl $PTERODACTYL_PANEL_VERSION con nginx en $OS"
  output "Nombre de base de datos: $MYSQL_DB"
  output "Usuario de base de datos: $MYSQL_USER"
  output "Contrasena de base de datos: (oculta)"
  output "Zona horaria: $timezone"
  output "Correo: $email"
  output "Correo del usuario: $user_email"
  output "Usuario: $user_username"
  output "Nombre: $user_firstname"
  output "Apellido: $user_lastname"
  output "Contrasena del usuario: (oculta)"
  output "Hostname/FQDN: $FQDN"
  output "Configurar Firewall? $CONFIGURE_FIREWALL"
  output "Configurar Let's Encrypt? $CONFIGURE_LETSENCRYPT"
  output "Asumir SSL? $ASSUME_SSL"
  print_brake 62
}

goodbye() {
  print_brake 62
  output "Instalacion del panel completada"
  output ""

  [ "$CONFIGURE_LETSENCRYPT" == true ] && output "Tu panel deberia estar accesible en $(hyperlink "$FQDN")"
  [ "$ASSUME_SSL" == true ] && [ "$CONFIGURE_LETSENCRYPT" == false ] && output "Elegiste usar SSL, pero no via Let's Encrypt automaticamente. El panel no funcionara hasta que SSL este configurado."
  [ "$ASSUME_SSL" == false ] && [ "$CONFIGURE_LETSENCRYPT" == false ] && output "Tu panel deberia estar accesible en $(hyperlink "$FQDN")"

  output ""
  output "La instalacion usa nginx en $OS"
  output "Gracias por usar este script."
  [ "$CONFIGURE_FIREWALL" == false ] && echo -e "* ${COLOR_RED}Nota${COLOR_NC}: Si no configuraste el firewall, los puertos 80/443 (HTTP/HTTPS) deben estar abiertos."
  print_brake 62
}

# run script
main
goodbye
