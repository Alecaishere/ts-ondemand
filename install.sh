#!/bin/sh
set -eu

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

install_file() {
    src="$1"
    dst="$2"
    mode="$3"

    if [ ! -f "$src" ]; then
        echo "Error: the file doesn't exist: $src" >&2
        exit 1
    fi

    dst_dir=$(dirname -- "$dst")
    sudo mkdir -p "$dst_dir"
    sudo install -m "$mode" "$src" "$dst"
    echo "Instalado: $dst"
}

echo "Installing ts-ondemand and NetworkManager dispatcher..."

install_file "$REPO_DIR/usr/local/bin/ts-ondemand" "/usr/local/bin/ts-ondemand" 755
install_file "$REPO_DIR/etc/NetworkManager/dispatcher.d/99-tailscale-ondemand" "/etc/NetworkManager/dispatcher.d/99-tailscale-ondemand" 755

echo ""
echo "Installation completed."
echo ""
echo "You can try it using this commands:"
echo "  sudo /usr/local/bin/ts-ondemand"
echo "  tailscale status"
