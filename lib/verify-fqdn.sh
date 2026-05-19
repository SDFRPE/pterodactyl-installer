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

CHECKIP_URL="https://checkip.pterodactyl-installer.se"
DNS_SERVER="8.8.8.8"

# salir con error si el usuario no es root
if [[ $EUID -ne 0 ]]; then
  echo "* Este script debe ejecutarse con privilegios de root (sudo)." 1>&2
  exit 1
fi

fail() {
  output "El registro DNS ($dns_record) no coincide con la IP del servidor. Asegurate de que el FQDN $fqdn apunte a la IP del servidor, $ip"
  output "Si usas Cloudflare, desactiva el proxy o no uses Let's Encrypt."

  echo -n "* Continuar de todos modos (la instalacion puede fallar si no sabes lo que haces)? (y/N): "
  read -r override

  [[ ! "$override" =~ [Yy] ]] && error "FQDN o registro DNS invalido" && exit 1
  return 0
}

dep_install() {
  update_repos true

  case "$OS" in
  ubuntu | debian)
    install_packages "dnsutils" true
    ;;
  rocky | almalinux)
    install_packages "bind-utils" true
    ;;
  esac

  return 0
}

confirm() {
  output "Este script realizara una solicitud HTTPS al endpoint $CHECKIP_URL"
  output "El servicio oficial de check-IP de este script, https://checkip.pterodactyl-installer.se"
  output "- no registrara ni compartira informacion de IP con terceros."
  output "Si deseas usar otro servicio, puedes modificar el script."

  echo -e -n "* Acepto que se realice esta solicitud HTTPS (y/N): "
  read -r confirm
  [[ "$confirm" =~ [Yy] ]] || (error "El usuario no acepto" && false)
}

dns_verify() {
  output "Resolviendo DNS para $fqdn"
  ip=$(curl -4 -s $CHECKIP_URL)
  dns_record=$(dig +short @$DNS_SERVER "$fqdn" | tail -n1)
  [ "${ip}" != "${dns_record}" ] && fail
  output "DNS verificado."
}

main() {
  fqdn="$1"
  dep_install
  confirm && dns_verify
  true
}

main "$1" "$2"
