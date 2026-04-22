# TS OnDemand - Tailscale On-Demand para Linux

[![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Tailscale](https://img.shields.io/badge/Tailscale-00D2FF?style=for-the-badge&logo=tailscale&logoColor=white)](https://tailscale.com/)
[![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0.html)

**TS Ondemand** es un script y conjunto de herramientas para activar **Tailscale en modo on-demand** en sistemas Linux (Debian, Ubuntu, etc.). Automatiza la conexión/desconexión de Tailscale basada en el SSID de la red WiFi, evitando conexiones permanentes innecesarias y optimizando batería/uso en equipos portátiles. [web:16][web:20]

Perfecto para usuarios que usan Tailscale como VPN pero solo cuando es necesario (ej. redes públicas no confiables).

## Características

- Activación automática de Tailscale al conectarse a redes WiFi específicas o no confiables.
- Desconexión automática al volver a redes de confianza (hogar/oficina).
- Integración con NetworkManager (Debian/Ubuntu).
- Soporte para exit nodes y subnet routes on-demand.
- Scripts ligeros en Bash, sin dependencias extras.
- Configuración via systemd o crontab para persistencia.
- Logs detallados y monitoreo.

## Prerrequisitos

- Tailscale instalado: `curl -fsSL https://tailscale.com/install.sh | sh`
- NetworkManager (predeterminado en Debian/Ubuntu).
- Permisos de root para hooks de NetworkManager.

## Instalación

1. Clona el repositorio:
   ```bash
   git clone https://github.com/Alecaishere/ts-ondemand.git \
   cd ts-ondemand \
   chmod +x install.sh \
   sudo ./install.sh
   ```
2. Agrega en la lista de exclusión que redes quieres que Tailscale se deshabilite:
```bash
EXCLUDED=("TRABAJO" "CASA")
```
3. Tras esto prueba a conectarte a otra red que no esté en la lista anterior y comprueba que Tailscale esté habilitado o no con el siguiente comando:
```bash
tailscale status
```
Si muestra que está desconectado felicidades, todo fue como debía ir.
