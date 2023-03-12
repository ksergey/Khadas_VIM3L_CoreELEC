#!/bin/bash

set -e 

# Jackett.Binaries.LinuxARM64.tar.gz

Jackett_PARENT_DIR="${HOME}/.local"
Jackett_DIR="${Jackett_PARENT_DIR}/Jackett"

# Create parent dir for Jackett
mkdir -p "${Jackett_PARENT_DIR}"
cd "${Jackett_PARENT_DIR}"

# Download and unpack Jackett
#curl -L "https://github.com/Jackett/Jackett/releases/download/v0.20.3583/Jackett.Binaries.LinuxMuslARM64.tar.gz" | tar xvzp
curl -L "https://github.com/Jackett/Jackett/releases/download/v0.20.3583/Jackett.Binaries.LinuxARM32.tar.gz" | tar xvzp

# Add system.d target for Jackett
cat > "${HOME}/.config/system.d/jackett.service" <<EOF
[Unit]
Description=Jackett Daemon
Requires=network-online.target
After=network-online.target
Before=kodi.service

[Service]
SyslogIdentifier=jackett
Restart=always
RestartSec=5
Type=simple
WorkingDirectory=${Jackett_DIR}
Environment="DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1"
ExecStart=/bin/sh "${Jackett_DIR}/jackett_launcher.sh"
TimeoutStopSec=30

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable jackett.service
systemctl start jackett.service
