# Wi-Fi networks where Tailscale should be OFF
EXCLUDED=("YOUR_HOME_SSID" "YOUR_WORK_SSID")

# Get current Wi-Fi SSID
CURRENT=$(nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d: -f2)

# If not connected to Wi-Fi → turn off
if [ -z "$CURRENT" ]; then
    /usr/bin/tailscale down
    exit 0
fi

# If SSID is trusted → turn off
for ssid in "${EXCLUDED[@]}"; do
    if [[ "$CURRENT" == "$ssid" ]]; then
        /usr/bin/tailscale down
        exit 0
    fi
done

# Otherwise → turn ON
