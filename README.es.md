# pterodactyl-installer (Guia en espanol)

Guia corta para instalar Pterodactyl Panel y Wings en Ubuntu 22.04.

## Requisitos

- Ubuntu 22.04 limpio.
- Acceso root.
- Puertos abiertos: 22, 80, 443, 8080, 2022.
- Dominio opcional (si quieres SSL con Let's Encrypt).

## Instalacion rapida

Ejecuta el instalador oficial de este repo:

```bash
bash <(curl -s https://pterodactyl-installer.se)
```

El script te preguntara:

- Si quieres instalar Panel, Wings o ambos.
- Tu FQDN (ejemplo: panel.tudominio.com).
- Si quieres SSL automatico con Let's Encrypt.
- Firewall.

## Si no tienes dominio todavia

- Puedes instalar con la IP del servidor y sin SSL.
- Mas adelante puedes cambiar a un dominio, actualizar Nginx y activar SSL.

## Recomendaciones para tu caso (Velocity + Paper 1.8.8)

- En el Panel, usa el egg de Velocity para el proxy.
- Para Paper 1.8.8, usa Java 8 en el servidor.
- Wings se configura despues de crear el nodo en el Panel.

## Notas

- El instalador genera el usuario admin del Panel durante la instalacion.
- Para SSL necesitas que el DNS apunte a la IP del servidor y puertos 80/443 abiertos.

Si quieres una guia mas detallada (con pasos para configurar dominio y SSL), dime y la preparo.

**Aviso legal:** `LICENSE` es el texto legal oficial y vinculante. `LICENSE.es.md` es solo una traduccion informativa.

