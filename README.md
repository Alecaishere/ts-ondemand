Tailscale On-Demand (Trusted Networks Fix & Fallback)
This guide helps you debug why --trusted-networks is not working in Tailscale and provides a bulletproof fallback using NetworkManager.

🧠 Why this exists
The built-in --trusted-networks feature:

Is relatively new

Depends heavily on NetworkManager

Fails silently if requirements are not met

This README walks you through debugging it and gives you a reliable alternative.

✅ Quick Debug Checklist
1. Check Tailscale Version
The feature requires Tailscale ≥ 1.54

text
tailscale version
If older:

text
curl -fsSL https://tailscale.com/install.sh | sh
2. Verify NetworkManager Usage
Tailscale relies entirely on NetworkManager to detect SSID.

text
nmcli general status
If:

It errors

Shows "disconnected"

👉 You are NOT using NetworkManager → feature will not work.

3. Check if Setting Was Saved
text
tailscale debug prefs | grep -i trust
If nothing appears:

The setting was not applied

Likely missing --operator=$USER

🛠️ Bulletproof Fallback (Recommended)
If anything above fails—or you just want reliability—use this method.

Step 1: Create Script
text
sudo nano /usr/local/bin/ts-ondemand
Paste:

text
#!/bin/bash

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
/usr/bin/tailscale up
Make it executable:

text
sudo chmod +x /usr/local/bin/ts-ondemand
Step 2: Hook into NetworkManager
text
sudo nano /etc/NetworkManager/dispatcher.d/99-tailscale-ondemand
Paste:

text
#!/bin/bash

if [ "$2" = "up" ] || [ "$2" = "down" ]; then
    /usr/local/bin/ts-ondemand
fi
Make it executable:

text
sudo chmod +x /etc/NetworkManager/dispatcher.d/99-tailscale-ondemand
⚡ Test Without Reboot
text
sudo /usr/local/bin/ts-ondemand
tailscale status
If it works manually, it will work automatically when:

Connecting to Wi-Fi

Disconnecting

Switching networks

💡 Behavior Summary
Known/trusted Wi-Fi → Tailscale OFF

Unknown/public Wi-Fi → Tailscale ON

No Wi-Fi → Tailscale OFF

🔧 Optional Tweaks
You can modify:

text
/usr/bin/tailscale up
Example:

text
/usr/bin/tailscale up --accept-dns=false
📌 Notes
Requires NetworkManager

Works on any Linux distro using NM

Fully CLI-based and scriptable

No dependency on Tailscale experimental features
