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

export RM_PANEL=false
export RM_WINGS=false

# --------------- Main functions --------------- #

main() {
  welcome ""

  if [ -d "/var/www/pterodactyl" ]; then
    output "Se detecto una instalacion del panel."
    echo -e -n "* Quieres eliminar el panel? (y/N): "
    read -r RM_PANEL_INPUT
    [[ "$RM_PANEL_INPUT" =~ [Yy] ]] && RM_PANEL=true
  fi

  if [ -d "/etc/pterodactyl" ]; then
    output "Se detecto una instalacion de Wings."
    warning "Esto eliminara todos los servidores."
    echo -e -n "* Quieres eliminar Wings (daemon)? (y/N): "
    read -r RM_WINGS_INPUT
    [[ "$RM_WINGS_INPUT" =~ [Yy] ]] && RM_WINGS=true
  fi

  if [ "$RM_PANEL" == false ] && [ "$RM_WINGS" == false ]; then
    error "No hay nada para desinstalar."
    exit 1
  fi

  summary

  # confirm uninstallation
  echo -e -n "* Continuar con la desinstalacion? (y/N): "
  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "uninstall"
  else
    error "Desinstalacion cancelada."
    exit 1
  fi
}

summary() {
  print_brake 30
  output "Desinstalar panel? $RM_PANEL"
  output "Desinstalar wings? $RM_WINGS"
  print_brake 30
}

goodbye() {
  print_brake 62
  [ "$RM_PANEL" == true ] && output "Desinstalacion del panel completada"
  [ "$RM_WINGS" == true ] && output "Desinstalacion de Wings completada"
  output "Gracias por usar este script."
  print_brake 62
}

main
goodbye
