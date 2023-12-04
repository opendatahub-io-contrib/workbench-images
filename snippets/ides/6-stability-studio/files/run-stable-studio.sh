#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=$(dirname -- "$0")
source ${SCRIPT_DIR}/utils/*.sh

# Start nginx and fastcgiwrap
run-nginx.sh &
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap 


# Start server
cd /app
/app/node_modules/yarn/bin/yarn dev \
  --host 0.0.0.0 \
  --port 8787
