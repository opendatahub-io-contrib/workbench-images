#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=$(dirname -- "$0")
source ${SCRIPT_DIR}/utils/*.sh

# Start nginx and fastcgiwrap
run-nginx.sh &
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap 

# Create .bashrc if not present with custom prompt
if [ ! -f /opt/app-root/src/.bashrc ]
then
	echo 'PS1="\[\033[34;1m\][$PWD]\[\033[0m\]\n\[\033[1;0m\]$ \[\033[0m\]"' > /opt/app-root/src/.bashrc
fi

# Initilize access logs for culling
echo '[{"id":"langflow","name":"langflow","last_activity":"'$(date -Iseconds)'","execution_state":"running","connections":1}]' > /var/log/nginx/langflow.access.log

# Start server
start_process langflow \
  --host 0.0.0.0 \
  --port 8787 \
  --no-open-browser