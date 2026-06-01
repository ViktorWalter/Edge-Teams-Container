#!/bin/bash
# If it was not built yet.
./build.sh

#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RUN_SCRIPT="$SCRIPT_DIR/run.sh"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/teams-docker.desktop"
ICON_DIR="$HOME/.local/share/icons"
ICON_URL="https://statics.teams.cdn.office.net/evergreen-assets/apps/teams_favicon.ico"

# Sanity check
if [ ! -f "$RUN_SCRIPT" ]; then
  echo "Error: run.sh not found at $RUN_SCRIPT"
  exit 1
fi

chmod +x "$RUN_SCRIPT"
mkdir -p "$DESKTOP_DIR" "$ICON_DIR"

# Download Teams icon
echo "Downloading Teams icon..."
if command -v wget &>/dev/null; then
  wget -q -O "$ICON_DIR/teams-docker.ico" "$ICON_URL"
elif command -v curl &>/dev/null; then
  curl -s -o "$ICON_DIR/teams-docker.ico" "$ICON_URL"
else
  echo "Warning: neither wget nor curl found, skipping icon download."
fi

# Write the .desktop file
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Microsoft Teams (Docker)
Comment=Microsoft Teams running in a Docker container
Exec=$RUN_SCRIPT
Path=$SCRIPT_DIR
Icon=$ICON_DIR/teams-docker.ico
Terminal=false
Categories=Network;InstantMessaging;
StartupNotify=true
StartupWMClass=msedge
EOF

chmod +x "$DESKTOP_FILE"

# Some desktop environments need this
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database "$DESKTOP_DIR"
fi

echo "Installed: $DESKTOP_FILE"
echo "You should now see 'Microsoft Teams (Docker)' in your application launcher."
