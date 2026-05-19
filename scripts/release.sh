#!/bin/bash

RELEASE=$1
DATE=$(date +%F)

COLOR_RED='\033[0;31m'
COLOR_NC='\033[0m'

output() {
  echo -e "* $1"
}

error() {
  echo ""
  echo -e "* ${COLOR_RED}ERROR${COLOR_NC}: $1" 1>&2
  echo ""
}

[ -z "$RELEASE" ] && error "Falta la variable de release" && exit 1

output "Publicando $RELEASE en $DATE"

sed -i "/next-release/c\## $RELEASE (released on $DATE)" CHANGELOG.md

# install.sh (archivo)
sed -i "s/.*SCRIPT_RELEASE=.*/SCRIPT_RELEASE=\"$RELEASE\"/" install.sh
sed -i "s/.*GITHUB_SOURCE=.*/GITHUB_SOURCE=\"$RELEASE\"/" install.sh

output "Haciendo commit del release"

git add .
git commit -S -m "Release $RELEASE"
git push

output "Release $RELEASE enviado"

output "Crea un nuevo release con el changelog abajo - https://github.com/pterodactyl-installer/pterodactyl-installer/releases/new"
output ""

changelog=$(scripts/changelog_parse.py)

cat <<EOF
# $RELEASE

Escribe aqui un mensaje que describa el release.

## Changelog

$changelog
EOF
