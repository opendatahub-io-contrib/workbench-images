#!/usr/bin/env bash

# Load bash libraries
SCRIPT_DIR=$(dirname -- "$0")
source ${SCRIPT_DIR}/utils/*.sh

# Start nginx and fastcgiwrap
run-nginx.sh &
spawn-fcgi -s /var/run/fcgiwrap.socket -M 766 /usr/sbin/fcgiwrap 

# Create lib folders if it does not exist
mkdir -p  /opt/app-root/src/Rpackages/4.2

# rstudio terminal cant see environment variables set by the container runtime
# (which breaks kubectl, to fix this we store the KUBERNETES_* env vars in Renviron.site)
env | grep KUBERNETES_ >> /usr/lib64/R/etc/Renviron.site

export USER=$(whoami)

# Initilize access logs for culling
echo '[{"id":"rstudio","name":"rstudio","last_activity":"'$(date -Iseconds)'","execution_state":"running","connections":1}]' > /var/log/nginx/rstudio.access.log

# Create RStudio launch command
launch_command=$(python /opt/app-root/bin/setup_rstudio.py)

echo $launch_command

start_process $launch_command
