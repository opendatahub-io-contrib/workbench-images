#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=$(dirname -- "$0")
source ${SCRIPT_DIR}/utils/*.sh

# Create .bashrc if not present
if [ ! -f /opt/app-root/src/.bashrc ]
then
	touch /opt/app-root/src/.bashrc
fi

# Start server
start_process /usr/bin/code-server \
  --bind-addr 0.0.0.0:8888 \
  --disable-telemetry \
  --auth none \
  --disable-update-check \
  /opt/app-root/src