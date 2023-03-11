#!/bin/bash

set -e 

CURRENT="$(pwd)"
TorrServer_CONFIG_DIR="${HOME}/.config/TorrServer"

# Download TorrServer
mkdir -p "${HOME}/.local/bin"
cd "${HOME}/.local/bin"
curl -O -L "https://github.com/YouROK/TorrServer/releases/download/MatriX.120/TorrServer-linux-arm64"
chmod +x TorrServer-linux-arm64

# Create config dir
mkdir -p "${TorrServer_CONFIG_DIR}"

# Add system.d target for TorrServer
cat > "${HOME}/.config/system.d/TorrServer.service" <<EOF
[Unit]
Description=TorrServer Daemon
Requires=network-online.target
After=network-online.target
Before=kodi.service

[Service]
ExecStart=${HOME}/.local/bin/TorrServer-linux-arm64 --port 8090 -d "${TorrServer_CONFIG_DIR}"
TimeoutStopSec=1
Restart=always
RestartSec=20
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable TorrServer.service
systemctl start TorrServer.service
