#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")"

# CWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
# echo $CWD

mkdir -p $(pwd)/profile
mkdir -p $(pwd)/profile/config
mkdir -p $(pwd)/profile/local

FIRST_RUN_FLAG="$(pwd)/profile/.pwa-setup-done"

xhost +local:docker

if ! docker ps --format '{{.Names}}' | grep -q "^edge$"; then
  echo "Starting container..."
  docker run -d \
    --name edge \
    --cap-drop ALL \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    --shm-size=2g \
    -v $(pwd)/profile/config:/home/edgeuser/.config/microsoft-edge:rw \
    -v $(pwd)/profile/local:/home/edgeuser/.local:rw \
    edge-browser
fi

if [ ! -f "$FIRST_RUN_FLAG" ]; then
  echo "First run — opening Edge for PWA setup."
  echo "Install the Teams PWA, then close Edge and re-run this script."
  docker exec -d edge microsoft-edge-stable \
    --no-sandbox \
    --disable-gpu \
    https://teams.microsoft.com
  # Wait for Edge to exit, then mark setup as done
  docker exec edge bash -c "while pgrep -x msedge > /dev/null; do sleep 2; done"
  touch "$FIRST_RUN_FLAG"
  echo "Setup complete. Re-run the script to launch Teams."
else
  docker exec -d edge microsoft-edge-stable \
    --no-sandbox \
    --disable-gpu \
    --app=https://teams.microsoft.com
fi
